Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbZE0TfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbZE0TfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZE0TfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:35:02 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54292 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZE0TfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:35:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 May 2009 12:28:57 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
In-Reply-To: <20090527184106.GA18463@redhat.com>
Message-ID: <alpine.DEB.1.10.0905271222590.20243@makko.or.mcafeemobile.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090527130447.GA11643@redhat.com> <4A1D48FA.9080403@novell.com> <20090527184106.GA18463@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Michael S. Tsirkin wrote:

> On Wed, May 27, 2009 at 10:06:50AM -0400, Gregory Haskins wrote:
> > Michael S. Tsirkin wrote:
> > > On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
> > >   
> > >> +static int
> > >> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
> > >> +{
> > >> +	struct _irqfd *irqfd;
> > >> +	struct file *file = NULL;
> > >> +	int ret;
> > >> +
> > >> +	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> > >> +	if (!irqfd)
> > >> +		return -ENOMEM;
> > >> +
> > >> +	irqfd->kvm = kvm;
> > >> +	irqfd->gsi = gsi;
> > >> +	INIT_LIST_HEAD(&irqfd->list);
> > >> +	INIT_WORK(&irqfd->work, irqfd_inject);
> > >> +
> > >> +	/*
> > >> +	 * Embed the file* lifetime in the irqfd.
> > >> +	 */
> > >> +	file = fget(fd);
> > >> +	if (IS_ERR(file)) {
> > >> +		ret = PTR_ERR(file);
> > >> +		goto fail;
> > >> +	}
> > >>     
> > >
> > > So we get a reference to a file, and unless the user is nice to us, it
> > > will only be dropped when kvm char device file is closed?
> > > I think this will deadlock if the fd in question is the open kvm char device.
> > >
> > >
> > >   
> > Hmm...I hadn't considered this possibility, though I am not sure if it
> > would cause a deadlock in the pattern you suggest.  It seems more like
> > it would result in, at worst, an extra reference to itself (and thus a
> > leak) rather than a deadlock...
> > 
> > I digress.  In either case, perhaps I should s/fget/eventfd_fget to at
> > least limit the type of fd to eventfd.  I was trying to be "slick" by
> > not needing the eventfd_fget() exported, but I am going to need to
> > export it later anyway for iosignalfd, so its probably a moot point.
> > 
> > Thanks Michael,
> > -Greg
> > 
> 
> This only works as long as eventfd does not do fget on some fd as well.
> Which it does not do now, and may never do - but we create a fragile
> system this way.
> 
> I think it's really wrong, fundamentally, to keep a reference to a
> file until another file is closed, unless you are code under fs/.
> We will get nasty circular references sooner or later.
> 
> Isn't the real reason we use fd to be able to support the same interface
> on top of both kvm and lguest?
> And if so, wouldn't some kind of bus be a better solution?

Another solution, that I proposed in the past, is having irqfd hold no 
references to the eventfd. It's just register (holding an eventfd-get()) 
for events (in the way that currently does), notice the POLLHUP, unchain 
from it, and propagate the eventfd-close event to whatever the irqfd logic 
is supposed to.



- Davide



---
 fs/eventfd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-05-27 12:10:03.000000000 -0700
+++ linux-2.6.mod/fs/eventfd.c	2009-05-27 12:16:57.000000000 -0700
@@ -59,7 +59,15 @@ int eventfd_signal(struct file *file, in
 
 static int eventfd_release(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
+	struct eventfd_ctx *ctx = file->private_data;
+
+	/*
+	 * No need to hold the lock here, since we are on the file cleanup
+	 * path and the ones still attached to the wait queue will be
+	 * serialized by wake_up_locked_poll().
+	 */
+	wake_up_locked_poll(&ctx->wqh, POLLHUP);
+	kfree(ctx);
 	return 0;
 }
 
