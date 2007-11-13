Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbXKMWvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbXKMWvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761447AbXKMWu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:50:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761297AbXKMWu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:50:57 -0500
Subject: patch xen-multicall-callbacks.patch queued to -stable tree
To: jeremy@goop.org, ak@muc.de, akpm@linux-foundation.org, chrisw@sous-sol.org,
       gregkh@suse.de, jeremy@xensource.com, keir@xensource.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Tue, 13 Nov 2007 14:50:42 -0800
In-Reply-To: <20071012211148.065483000@goop.org>
Message-Id: <20071113225054.7148F14543E5@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: xen: add batch completion callbacks

to the 2.6.23-stable tree.  Its filename is

     xen-multicall-callbacks.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Fri Oct 12 14:33:42 2007
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 12 Oct 2007 14:11:36 -0700
Subject: xen: add batch completion callbacks
To: LKML <linux-kernel@vger.kernel.org>
Cc: xen-devel@lists.xensource.com, virtualization@lists.osdl.org, Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>, Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Message-ID: <20071012211148.065483000@goop.org>
Content-Disposition: inline; filename=xen-multicall-callbacks.patch

From: Jeremy Fitzhardinge <jeremy@goop.org>

patch 91e0c5f3dad47838cb2ecc1865ce789a0b7182b1 in mainline.

This adds a mechanism to register a callback function to be called once
a batch of hypercalls has been issued.  This is typically used to unlock
things which must remain locked until the hypercall has taken place.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/xen/multicalls.c |   29 ++++++++++++++++++++++++++---
 arch/i386/xen/multicalls.h |    3 +++
 2 files changed, 29 insertions(+), 3 deletions(-)

--- a/arch/i386/xen/multicalls.c
+++ b/arch/i386/xen/multicalls.c
@@ -32,7 +32,11 @@
 struct mc_buffer {
 	struct multicall_entry entries[MC_BATCH];
 	u64 args[MC_ARGS];
-	unsigned mcidx, argidx;
+	struct callback {
+		void (*fn)(void *);
+		void *data;
+	} callbacks[MC_BATCH];
+	unsigned mcidx, argidx, cbidx;
 };
 
 static DEFINE_PER_CPU(struct mc_buffer, mc_buffer);
@@ -43,6 +47,7 @@ void xen_mc_flush(void)
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
 	int ret = 0;
 	unsigned long flags;
+	int i;
 
 	BUG_ON(preemptible());
 
@@ -51,8 +56,6 @@ void xen_mc_flush(void)
 	local_irq_save(flags);
 
 	if (b->mcidx) {
-		int i;
-
 		if (HYPERVISOR_multicall(b->entries, b->mcidx) != 0)
 			BUG();
 		for (i = 0; i < b->mcidx; i++)
@@ -65,6 +68,13 @@ void xen_mc_flush(void)
 
 	local_irq_restore(flags);
 
+	for(i = 0; i < b->cbidx; i++) {
+		struct callback *cb = &b->callbacks[i];
+
+		(*cb->fn)(cb->data);
+	}
+	b->cbidx = 0;
+
 	BUG_ON(ret);
 }
 
@@ -88,3 +98,16 @@ struct multicall_space __xen_mc_entry(si
 
 	return ret;
 }
+
+void xen_mc_callback(void (*fn)(void *), void *data)
+{
+	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct callback *cb;
+
+	if (b->cbidx == MC_BATCH)
+		xen_mc_flush();
+
+	cb = &b->callbacks[b->cbidx++];
+	cb->fn = fn;
+	cb->data = data;
+}
--- a/arch/i386/xen/multicalls.h
+++ b/arch/i386/xen/multicalls.h
@@ -42,4 +42,7 @@ static inline void xen_mc_issue(unsigned
 	local_irq_restore(x86_read_percpu(xen_mc_irq_flags));
 }
 
+/* Set up a callback to be called when the current batch is flushed */
+void xen_mc_callback(void (*fn)(void *), void *data);
+
 #endif /* _XEN_MULTICALLS_H */


Patches currently in stable-queue which might be from jeremy@goop.org are

queue-2.6.23/xen-handle-lazy-cr3-on-unpin.patch
queue-2.6.23/xen-multicall-callbacks.patch
queue-2.6.23/xen-fix-register_vcpu_info.patch
queue-2.6.23/xen-xfs-unmap.patch
