Return-Path: <linux-kernel-owner+w=401wt.eu-S1759028AbXJLVpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028AbXJLVpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760332AbXJLVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:44:37 -0400
Received: from 224.sub-75-208-255.myvzw.com ([75.208.255.224]:42253 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760122AbXJLVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:44:35 -0400
Message-Id: <20071012211148.065483000@goop.org>
References: <20071012211132.198718000@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 14:11:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH 04/10] xen: add batch completion callbacks
Content-Disposition: inline; filename=xen-multicall-callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a mechanism to register a callback function to be called once
a batch of hypercalls has been issued.  This is typically used to unlock
things which must remain locked until the hypercall has taken place.

[ Stable folks: pre-req for 2.6.23 bugfix "xen: deal with stale cr3
  values when unpinning pagetables" ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Stable Kernel <stable@kernel.org>

---
 arch/i386/xen/multicalls.c |   29 ++++++++++++++++++++++++++---
 arch/i386/xen/multicalls.h |    3 +++
 2 files changed, 29 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/i386/xen/multicalls.c
+++ b/arch/i386/xen/multicalls.c
@@ -32,7 +32,11 @@ struct mc_buffer {
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
@@ -64,6 +67,13 @@ void xen_mc_flush(void)
 		BUG_ON(b->argidx != 0);
 
 	local_irq_restore(flags);
+
+	for(i = 0; i < b->cbidx; i++) {
+		struct callback *cb = &b->callbacks[i];
+
+		(*cb->fn)(cb->data);
+	}
+	b->cbidx = 0;
 
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
===================================================================
--- a/arch/i386/xen/multicalls.h
+++ b/arch/i386/xen/multicalls.h
@@ -42,4 +42,7 @@ static inline void xen_mc_issue(unsigned
 	local_irq_restore(x86_read_percpu(xen_mc_irq_flags));
 }
 
+/* Set up a callback to be called when the current batch is flushed */
+void xen_mc_callback(void (*fn)(void *), void *data);
+
 #endif /* _XEN_MULTICALLS_H */

-- 

