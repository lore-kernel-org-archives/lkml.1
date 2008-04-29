Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYD2UnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYD2UnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYD2UnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:43:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:19710 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbYD2UnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=I3pTZ/aIDkxxX+KaPD2c//xnG6AUyJR9LoIfeDrKBUQR4R0iJ3LEQNVsosk8tMkvKQQ8PQHywdhrEk2xKZlNHrVDIQmGtIgGOMevzTFZV+hccuYfdsyr3Abcqu/INWeC+zuwRk0zOUOH0JOQ/aTuC9L0mNEXslV5LNViqG+dajw=
Date: Tue, 29 Apr 2008 23:43:09 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] x86 mmiotrace: fix page-unaligned ioremaps
Message-ID: <20080429234309.603251ff@daedalus.pq.iki.fi>
In-Reply-To: <20080429234021.071f7948@daedalus.pq.iki.fi>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
	<20080429234021.071f7948@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c306ab1bc1f40e74f7015a498784e1a39ec6229b Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Tue, 29 Apr 2008 22:39:40 +0300
Subject: [PATCH] x86 mmiotrace: fix page-unaligned ioremaps

mmiotrace_ioremap() expects to receive the original unaligned map phys address
and size. Also fix {un,}register_kmmio_probe() to deal properly with
unaligned size.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/ioremap.c  |    4 +++-
 arch/x86/mm/kmmio.c    |   13 +++++++++++--
 arch/x86/mm/mmio-mod.c |    1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ce73980..923621d 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -123,6 +123,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 {
 	unsigned long pfn, offset, vaddr;
 	resource_size_t last_addr;
+	const resource_size_t unaligned_phys_addr = phys_addr;
+	const unsigned long unaligned_size = size;
 	struct vm_struct *area;
 	unsigned long new_prot_val;
 	pgprot_t prot;
@@ -235,7 +237,7 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	}
 
 	ret_addr = (void __iomem *) (vaddr + offset);
-	mmiotrace_ioremap(phys_addr, size, ret_addr);
+	mmiotrace_ioremap(unaligned_phys_addr, unaligned_size, ret_addr);
 
 	return ret_addr;
 }
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 40567d8..c12be07 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -352,11 +352,19 @@ static void release_kmmio_fault_page(unsigned long page,
 	}
 }
 
+/*
+ * With page-unaligned ioremaps, one or two armed pages may contain
+ * addresses from outside the intended mapping. Events for these addresses
+ * are currently silently dropped. The events may result only from programming
+ * mistakes by accessing addresses before the beginning or past the end of a
+ * mapping.
+ */
 int register_kmmio_probe(struct kmmio_probe *p)
 {
 	unsigned long flags;
 	int ret = 0;
 	unsigned long size = 0;
+	const unsigned long size_lim = p->len + (p->addr & ~PAGE_MASK);
 
 	spin_lock_irqsave(&kmmio_lock, flags);
 	if (get_kmmio_probe(p->addr)) {
@@ -365,7 +373,7 @@ int register_kmmio_probe(struct kmmio_probe *p)
 	}
 	kmmio_count++;
 	list_add_rcu(&p->list, &kmmio_probes);
-	while (size < p->len) {
+	while (size < size_lim) {
 		if (add_kmmio_fault_page(p->addr + size))
 			pr_err("kmmio: Unable to set page fault.\n");
 		size += PAGE_SIZE;
@@ -437,11 +445,12 @@ void unregister_kmmio_probe(struct kmmio_probe *p)
 {
 	unsigned long flags;
 	unsigned long size = 0;
+	const unsigned long size_lim = p->len + (p->addr & ~PAGE_MASK);
 	struct kmmio_fault_page *release_list = NULL;
 	struct kmmio_delayed_release *drelease;
 
 	spin_lock_irqsave(&kmmio_lock, flags);
-	while (size < p->len) {
+	while (size < size_lim) {
 		release_kmmio_fault_page(p->addr + size, &release_list);
 		size += PAGE_SIZE;
 	}
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index a8d2a00..278998c 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -280,6 +280,7 @@ static void ioremap_trace_core(unsigned long offset, unsigned long size,
 {
 	static atomic_t next_id;
 	struct remap_trace *trace = kmalloc(sizeof(*trace), GFP_KERNEL);
+	/* These are page-unaligned. */
 	struct mmiotrace_map map = {
 		.phys = offset,
 		.virt = (unsigned long)addr,
-- 
1.5.3.7

