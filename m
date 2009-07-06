Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZGFQuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZGFQuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZGFQud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:50:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZGFQuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:50:32 -0400
Date: Mon, 6 Jul 2009 19:49:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
Message-ID: <20090706164955.GE12399@redhat.com>
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <4A4CD729.6050300@redhat.com> <4A50723E.6030305@redhat.com> <4A521082.40209@novell.com> <20090706161331.GB12399@redhat.com> <4A522957.4070901@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A522957.4070901@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 12:41:59PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Mon, Jul 06, 2009 at 10:56:02AM -0400, Gregory Haskins wrote:
> >   
> >> Avi Kivity wrote:
> >>     
> >>> On 07/02/2009 06:50 PM, Avi Kivity wrote:
> >>>       
> >>>> On 07/02/2009 06:37 PM, Gregory Haskins wrote:
> >>>>         
> >>>>> (Applies to kvm.git/master:1f9050fd)
> >>>>>
> >>>>> The following is the latest attempt to fix the races in
> >>>>> irqfd/eventfd, as
> >>>>> well as restore DEASSIGN support.  For more details, please read the
> >>>>> patch
> >>>>> headers.
> >>>>>
> >>>>> As always, this series has been tested against the kvm-eventfd unit
> >>>>> test
> >>>>> and everything appears to be functioning properly. You can download
> >>>>> this
> >>>>> test here:
> >>>>>           
> >>>> Applied, thanks.
> >>>>
> >>>>         
> >>> ... and unapplied.  There's a refcounting mismatch in irqfd_cleanup: a
> >>> reference is taken for each irqfd, but dropped for each guest.  This
> >>> causes an oops if a guest with no irqfds is created and destroyed:
> >>>       
> >> I was able to reproduce this issue.  The problem turned out to be that I
> >> inadvertently always did a flush_workqueue(), even if the work-queue was
> >> never initialized.   
> >>
> >> The following interdiff applied to the reverted patch has been confirmed
> >> to fix the issue:
> >>     
> >
> > Could you document the init boolean and its locking rules?
> > The best place to put it would be where the field is declared btw.
> >   
> 
> Will do
> 
> > Is it true that init === list_empty(&kvm->irqfds.items)?
> > If yes maybe we don't need this field at all.
> >
> >   
> No,

OK, I thought it is. I'll wait for the documentation patch then.

> because its more difficult to maintain the work-queue when
> referenced against active irqfds (*).  So instead, its maintained
> against guests that use irqfd, whether they have an active irqfd or
> not.  Otherwise you have to contend with the eventfd-side release, which
> is a little tricky.
> 
> (*) I'm sure its not rocket science to get this working, but it was
> getting more complex than I thought it was worth, so I simplified the
> model to be per-vm.  Note that this design decision/limitation is
> declared in the patch header.
> >   
> >> -------------------
> >>
> >> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> >> index fcc3469..52b0e04 100644
> >> --- a/virt/kvm/eventfd.c
> >> +++ b/virt/kvm/eventfd.c
> >> @@ -318,6 +318,9 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
> >>         struct _irqfd *irqfd, *tmp;
> >>         struct eventfd_ctx *eventfd;
> >>  
> >> +       if (!kvm->irqfds.init)
> >> +               return -ENOENT;
> >> +
> >>         eventfd = eventfd_ctx_fdget(fd);
> >>         if (IS_ERR(eventfd))
> >>                 return PTR_ERR(eventfd);
> >>     
> >
> > wouldn't it be cleaner to error out in the for each loop if we don't
> > find an entry to deactivate?  Might be helpful for apps to get an error
> > if they didn't deassign anything.
> >   
> 
> Again, irqfds.init is somewhat orthogonal to whether the list is
> populated or not.  This check is for sanity (how can you deassign if you
> didnt assign, etc).  Normally this would be a simple BUG_ON() sanity
> check, but I don't want a malicious/broken userspace to gain an easy
> attack vector ;)

what I'm saying is that deassign should return an error if it's passed
and entry that is not on the list.  And if you do this and return before
flush, this check won't be needed.

> >   
> >> @@ -360,6 +363,9 @@ kvm_irqfd_release(struct kvm *kvm)
> >>  {
> >>         struct _irqfd *irqfd, *tmp;
> >>  
> >> +       if (!kvm->irqfds.init)
> >> +               return;
> >> +
> >>     
> >
> > So here, I recall some old comment that flush below was
> > needed even if list is empty. Is this no longer true?
> >   
> 
> If you are using irqfd, its true.  If irqfds.init == false, you are not
> using irqfd and thus the flush cannot be needed.
> 
> > If not it might be cleaner to only flush if list is not empty.
> >
> >   
> You have to flush if irqfds.init == true even if the list is empty
> because you need to be sure that eventfd-side releases complete.  They
> may have already removed themselves from the list, but the work-item is
> still in flight.
> 
> Regards,
> -Greg
> 


