Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZFYLmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZFYLmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFYLmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:42:25 -0400
Received: from ozlabs.org ([203.10.76.45]:47511 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZFYLmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:42:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier race conditions
Date: Thu, 25 Jun 2009 21:12:24 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Gregory Haskins <ghaskins@novell.com>, mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <200906241255.54709.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906241154350.30928@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906241154350.30928@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252112.24730.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 08:15:11 am Davide Libenzi wrote:
> On Wed, 24 Jun 2009, Rusty Russell wrote:
> > On Tue, 23 Jun 2009 03:33:22 am Davide Libenzi wrote:
> > > What you're doing there, is setting up a kernel-to-kernel (since
> > > userspace only role is to create the eventfd) communication, using a
> > > file* as accessory. That IMO is plain wrong.
> >
> > The most sensible is that userspace can use these fds; an in-kernel
> > variant is possible too, but not primary IMHO.
> >
> > It's nice that userspace create the fds; it can then use the same fd for
> > multiple event sources.
> >
> > But I didn't see anything wrong with the way eventfd used to work: you
> > have a kvm ioctl to say "attach this eventfd to this guest notification"
> > and that does the eventfd_fget.  A detach ioctl does the fput (as does
> > release of the kvm fd).
> >
> > If they close the eventfd and don't do the detach ioctl, it's their
> > problem.
>
> Some components would like to know if userspace dropped the fd, and take
> proper action accordingly (release resources, drop module instances,
> etc...).

Like to know?  Possibly.  Need to know?  Not anything I've seen so far.

If userspace creates the fd, component grab a ref and if userspace wants that 
fd completely freed must close the fd *and* tell component.  Simple, race free 
and explicit.  All wins.

As this discussion shows, doing some kind of implies non-reference is hard, 
complex and racy.

> Another thing that comes in my mind (that for some components might not
> matter) is considering the effect of userspace doing things like:
>
> 	for (;;) {
> 		fd = eventfd(...);
> 		ioctl(xfd, XXX_ADD, fd);
> 		close(fd);
> 	}
>
> That might lead to unprivileged users drawing kernel memory w/out any
> userspace accountability, if not properly handled.

No, fget_eventfd covers this exactly as expected.  Don't doubt your ability to 
design sane kernel interfaces; eventfd is nice!  All lguest needed was a 
couple of EXPORT_SYMBOLS and it fitted in beautifully.

Thanks,
Rusty.
