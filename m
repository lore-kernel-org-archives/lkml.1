Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZFBPQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZFBPQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZFBPPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:15:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48508 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZFBPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:15:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM-RFC PATCH 1/2] eventfd: send POLLHUP on f_ops->release
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       mst@redhat.com, paulmck@linux.vnet.ibm.com
Date: Tue, 02 Jun 2009 11:15:33 -0400
Message-ID: <20090602151533.29746.1533.stgit@dev.haskins.net>
In-Reply-To: <20090602151135.29746.91320.stgit@dev.haskins.net>
References: <20090602151135.29746.91320.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>

Return-path: <davidel@xmailserver.org>
Received: from novell.com ([::ffff:130.57.1.153])
	by soto.provo.novell.com with ESMTP; Wed, 27 May 2009 13:35:04 -0600
Received: from x35.xmailserver.org not authenticated [64.71.152.41]
	by novell.com with M+ Extreme Email Engine 2008.3.release
	via secured & encrypted transport (TLS);
	Wed, 27 May 2009 13:35:04 -0600
X-MailFrom: davidel@xmailserver.org
X-AuthUser: davidel@xmailserver.org
Received: from makko.or.mcafeemobile.com
	by x35.xmailserver.org with [XMail 1.26 ESMTP Server]
	id <S2EBEB0> for <ghaskins@novell.com> from <davidel@xmailserver.org>;
	Wed, 27 May 2009 15:34:01 -0400
Date: Wed, 27 May 2009 12:28:57 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
    Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, avi@redhat.com,
    mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
In-Reply-To: <20090527184106.GA18463@redhat.com>
Message-ID: <alpine.DEB.1.10.0905271222590.20243@makko.or.mcafeemobile.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090527130447.GA11643@redhat.com> <4A1D48FA.9080403@novell.com> <20090527184106.GA18463@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII

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

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 fs/eventfd.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 3f0e197..72f5f8d 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -61,7 +61,15 @@ EXPORT_SYMBOL_GPL(eventfd_signal);
 
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
 

