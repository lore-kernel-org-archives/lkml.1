Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZEZQnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZEZQnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbZEZQm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:42:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbZEZQm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:42:57 -0400
Date: Tue, 26 May 2009 19:42:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
Message-ID: <20090526164201.GD9842@redhat.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520142234.22285.72274.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
> +static int
> +irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> +
> +	/*
> +	 * The wake_up is called with interrupts disabled.  Therefore we need
> +	 * to defer the IRQ injection until later since we need to acquire the
> +	 * kvm->lock to do so.
> +	 */
> +	schedule_work(&irqfd->work);
> +
> +	return 0;
> +}

This schedule_work is there just to work around the spinlock
in eventfd_signal, which we don't really need. Isn't this right?
And this is on each interrupt. Seems like a pity.
How about a flag in eventfd that would
convert it from waking up someone to a plain function call?

Davide, could we add something like


diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2a701d5..8bfa308 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -29,6 +29,7 @@ struct eventfd_ctx {
 	 */
 	__u64 count;
 	unsigned int flags;
+	int nolock;
 };
 
 /*
@@ -46,6 +47,12 @@ int eventfd_signal(struct file *file, int n)
 
 	if (n < 0)
 		return -EINVAL;
+	if (ctx->nolock) {
+               /* Whoever set nolock
+                  better set wqh.func as well. */
+		ctx->wqh.func(&ctx->wqh, 0, 0, NULL);
+		return 0;
+	}
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ULLONG_MAX - ctx->count < n)
 		n = (int) (ULLONG_MAX - ctx->count);

-- 
MST
