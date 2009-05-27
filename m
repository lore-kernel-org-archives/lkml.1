Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZE0Unp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZE0Unp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZE0Unc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:43:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50119 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbZE0Unb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:43:31 -0400
Date: Wed, 27 May 2009 23:43:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
Message-ID: <20090527204324.GA22915@redhat.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090527130447.GA11643@redhat.com> <4A1D48FA.9080403@novell.com> <20090527184106.GA18463@redhat.com> <4A1D9D7B.9080507@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D9D7B.9080507@novell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 04:07:23PM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Wed, May 27, 2009 at 10:06:50AM -0400, Gregory Haskins wrote:
> >   
> >> Michael S. Tsirkin wrote:
> >>     
> >>> On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
> >>>   
> >>>       
> >>>> +static int
> >>>> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
> >>>> +{
> >>>> +	struct _irqfd *irqfd;
> >>>> +	struct file *file = NULL;
> >>>> +	int ret;
> >>>> +
> >>>> +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> >>>> +	if (!irqfd)
> >>>> +		return -ENOMEM;
> >>>> +
> >>>> +	irqfd->kvm = kvm;
> >>>> +	irqfd->gsi = gsi;
> >>>> +	INIT_LIST_HEAD(&irqfd->list);
> >>>> +	INIT_WORK(&irqfd->work, irqfd_inject);
> >>>> +
> >>>> +	/*
> >>>> +	 * Embed the file* lifetime in the irqfd.
> >>>> +	 */
> >>>> +	file = fget(fd);
> >>>> +	if (IS_ERR(file)) {
> >>>> +		ret = PTR_ERR(file);
> >>>> +		goto fail;
> >>>> +	}
> >>>>     
> >>>>         
> >>> So we get a reference to a file, and unless the user is nice to us, it
> >>> will only be dropped when kvm char device file is closed?
> >>> I think this will deadlock if the fd in question is the open kvm char device.
> >>>
> >>>
> >>>   
> >>>       
> >> Hmm...I hadn't considered this possibility, though I am not sure if it
> >> would cause a deadlock in the pattern you suggest.  It seems more like
> >> it would result in, at worst, an extra reference to itself (and thus a
> >> leak) rather than a deadlock...
> >>
> >> I digress.  In either case, perhaps I should s/fget/eventfd_fget to at
> >> least limit the type of fd to eventfd.  I was trying to be "slick" by
> >> not needing the eventfd_fget() exported, but I am going to need to
> >> export it later anyway for iosignalfd, so its probably a moot point.
> >>
> >> Thanks Michael,
> >> -Greg
> >>
> >>     
> >
> > This only works as long as eventfd does not do fget on some fd as well.
> > Which it does not do now, and may never do - but we create a fragile
> > system this way.
> >
> > I think it's really wrong, fundamentally, to keep a reference to a
> > file until another file is closed, unless you are code under fs/.
> > We will get nasty circular references sooner or later.
> >   
> 
> Hmm.. I understand your concern, but I respectfully disagree.
> 
> One object referencing another is a natural expression, regardless of
> what type they may be.  The fact is that introducing the concept of
> irqfd creates a relationship between an eventfd instance and a kvm
> instance whether we like it or not, and this relationship needs to be
> managed.  It is therefore IMO perfectly natural to express that
> relationship with a reference count, and I do not currently see anything
> wrong or even particularly fragile about how I've currently done this. 
> I'm sure there are other ways, however.  Do you have a particular
> suggestion in mind?

Yes. I'll try to post a patch soon.

> > Isn't the real reason we use fd to be able to support the same interface
> > on top of both kvm and lguest?
> >   
> 
> Actually, the reason why we use an fd is to decouple the
> interrupt-producing end-point from the KVM core.  Ignoring eventfd in
> specific for a moment, one convenient way to do that is with an fd
> because it provides a nice, already written/tested handle-to-pointer
> translation, and a polymorphic interface (e.g. f_ops).  Choosing to use
> eventfd flavored fd's buys us additional advantages in terms of
> leveraging already tested f_ops code, and compatibility with an
> interface that is designed-for/used-by other established subsystems for
> signaling.
> > And if so, wouldn't some kind of bus be a better solution?
> >   
> 
> Ultimately I aim to implement a bus (vbus, specifically) in terms of
> irqfd (and iosignalfd, for that matter).  However, the eventfd
> interfaces are general purpose and can be used in other areas as well
> (for instance, virtio-pci, or the shared-mem driver recently
> discussed).  I realize this is probably not the point you were making
> here, but fyi.
> 
> Regards,
> -Greg
> 
> 


