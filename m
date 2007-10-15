Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbXJOVwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbXJOVwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761510AbXJOVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:49:52 -0400
Received: from zrnetservice.com ([209.133.52.163]:33165 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761488AbXJOVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:49:50 -0400
Message-Id: <20071015210115.047186905@goop.org>
References: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH 06/12] xen: add batch completion callbacks
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
 arch/x86/xen/multicalls.c |   29 ++++++++++++++++++++++++++---
 arch/x86/xen/multicalls.h |    3 +++
 2 files changed, 29 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
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
--- a/arch/x86/xen/multicalls.h
+++ b/arch/x86/xen/multicalls.h
@@ -42,4 +42,7 @@ static inline void xen_mc_issue(unsigned
 	local_irq_restore(x86_read_percpu(xen_mc_irq_flags));
 }
 
+/* Set up a callback to be called when the current batch is flushed */
+void xen_mc_callback(void (*fn)(void *), void *data);
+
 #endif /* _XEN_MULTICALLS_H */

-- 

