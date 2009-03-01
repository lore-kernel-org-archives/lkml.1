Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZCAOMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZCAOMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZCAOMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:12:06 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:38374 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZCAOMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=vWy2xCjxz0YRk2DiA4VKGUHnRGbeq8ge2kmuz23t0329Vd73w1BZszvfCeQB6HB5Fn
         CpelIWtgNqm9croRKPPNB4C7BLGdx/tnkuuRkPd4rQzwuXzoQaATrrm0S7eLfjtvxzUh
         LzvR96VgUmQI88Cjko/y5M8gpAVLLVtTp8jAE=
Date: Sun, 1 Mar 2009 16:11:58 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] x86 mmiotrace: fix save/restore page table state
Message-ID: <20090301161158.2c4b130d@daedalus.pq.iki.fi>
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From baa99e2b32449ec7bf147c234adfa444caecac8a Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 22 Feb 2009 20:02:43 +0200
Subject: [PATCH] x86 mmiotrace: fix save/restore page table state

Blindly setting _PAGE_PRESENT in disarm_kmmio_fault_page() overlooks the
possibility, that the page was not present when it was armed.

Make arm_kmmio_fault_page() store the previous page presence in struct
kmmio_fault_page and use it on disarm.

This patch was originally written by Stuart Bennett, but Pekka Paalanen
rewrote it a little different.

Cc: Stuart Bennett <stuart@freedesktop.org>
Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c |   66 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index fb1f115..be361eb 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -32,6 +32,8 @@ struct kmmio_fault_page {
 	struct list_head list;
 	struct kmmio_fault_page *release_next;
 	unsigned long page; /* location of the fault page */
+	bool old_presence; /* page presence prior to arming */
+	bool armed;
 
 	/*
 	 * Number of times this page has been registered as a part
@@ -105,8 +107,7 @@ static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 	return NULL;
 }
 
-static int set_page_present(unsigned long addr, bool present,
-							unsigned int *pglevel)
+static int set_page_presence(unsigned long addr, bool present, bool *old)
 {
 	pteval_t pteval;
 	pmdval_t pmdval;
@@ -119,20 +120,21 @@ static int set_page_present(unsigned long addr, bool present,
 		return -1;
 	}
 
-	if (pglevel)
-		*pglevel = level;
-
 	switch (level) {
 	case PG_LEVEL_2M:
 		pmd = (pmd_t *)pte;
-		pmdval = pmd_val(*pmd) & ~_PAGE_PRESENT;
+		pmdval = pmd_val(*pmd);
+		*old = !!(pmdval & _PAGE_PRESENT);
+		pmdval &= ~_PAGE_PRESENT;
 		if (present)
 			pmdval |= _PAGE_PRESENT;
 		set_pmd(pmd, __pmd(pmdval));
 		break;
 
 	case PG_LEVEL_4K:
-		pteval = pte_val(*pte) & ~_PAGE_PRESENT;
+		pteval = pte_val(*pte);
+		*old = !!(pteval & _PAGE_PRESENT);
+		pteval &= ~_PAGE_PRESENT;
 		if (present)
 			pteval |= _PAGE_PRESENT;
 		set_pte_atomic(pte, __pte(pteval));
@@ -148,19 +150,39 @@ static int set_page_present(unsigned long addr, bool present,
 	return 0;
 }
 
-/** Mark the given page as not present. Access to it will trigger a fault. */
-static int arm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
+/*
+ * Mark the given page as not present. Access to it will trigger a fault.
+ *
+ * Struct kmmio_fault_page is protected by RCU and kmmio_lock, but the
+ * protection is ignored here. RCU read lock is assumed held, so the struct
+ * will not disappear unexpectedly. Furthermore, the caller must guarantee,
+ * that double arming the same virtual address (page) cannot occur.
+ *
+ * Double disarming on the other hand is allowed, and may occur when a fault
+ * and mmiotrace shutdown happen simultaneously.
+ */
+static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
-	int ret = set_page_present(page & PAGE_MASK, false, pglevel);
-	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", page);
+	int ret;
+	WARN_ONCE(f->armed, KERN_ERR "kmmio page already armed.\n");
+	if (f->armed) {
+		pr_warning("kmmio double-arm: page 0x%08lx, ref %d, old %d\n",
+					f->page, f->count, f->old_presence);
+	}
+	ret = set_page_presence(f->page, false, &f->old_presence);
+	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", f->page);
+	f->armed = true;
 	return ret;
 }
 
-/** Mark the given page as present. */
-static void disarm_kmmio_fault_page(unsigned long page, unsigned int *pglevel)
+/** Restore the given page to saved presence state. */
+static void disarm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
-	int ret = set_page_present(page & PAGE_MASK, true, pglevel);
-	WARN_ONCE(ret < 0, KERN_ERR "kmmio disarming 0x%08lx failed.\n", page);
+	bool tmp;
+	int ret = set_page_presence(f->page, f->old_presence, &tmp);
+	WARN_ONCE(ret < 0,
+			KERN_ERR "kmmio disarming 0x%08lx failed.\n", f->page);
+	f->armed = false;
 }
 
 /*
@@ -207,7 +229,7 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 
 	ctx = &get_cpu_var(kmmio_ctx);
 	if (ctx->active) {
-		disarm_kmmio_fault_page(faultpage->page, NULL);
+		disarm_kmmio_fault_page(faultpage);
 		if (addr == ctx->addr) {
 			/*
 			 * On SMP we sometimes get recursive probe hits on the
@@ -249,7 +271,7 @@ int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 	regs->flags &= ~X86_EFLAGS_IF;
 
 	/* Now we set present bit in PTE and single step. */
-	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
+	disarm_kmmio_fault_page(ctx->fpage);
 
 	/*
 	 * If another cpu accesses the same page while we are stepping,
@@ -288,7 +310,7 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	if (ctx->probe && ctx->probe->post_handler)
 		ctx->probe->post_handler(ctx->probe, condition, regs);
 
-	arm_kmmio_fault_page(ctx->fpage->page, NULL);
+	arm_kmmio_fault_page(ctx->fpage);
 
 	regs->flags &= ~X86_EFLAGS_TF;
 	regs->flags |= ctx->saved_flags;
@@ -320,19 +342,19 @@ static int add_kmmio_fault_page(unsigned long page)
 	f = get_kmmio_fault_page(page);
 	if (f) {
 		if (!f->count)
-			arm_kmmio_fault_page(f->page, NULL);
+			arm_kmmio_fault_page(f);
 		f->count++;
 		return 0;
 	}
 
-	f = kmalloc(sizeof(*f), GFP_ATOMIC);
+	f = kzalloc(sizeof(*f), GFP_ATOMIC);
 	if (!f)
 		return -1;
 
 	f->count = 1;
 	f->page = page;
 
-	if (arm_kmmio_fault_page(f->page, NULL)) {
+	if (arm_kmmio_fault_page(f)) {
 		kfree(f);
 		return -1;
 	}
@@ -356,7 +378,7 @@ static void release_kmmio_fault_page(unsigned long page,
 	f->count--;
 	BUG_ON(f->count < 0);
 	if (!f->count) {
-		disarm_kmmio_fault_page(f->page, NULL);
+		disarm_kmmio_fault_page(f);
 		f->release_next = *release_list;
 		*release_list = f;
 	}
-- 
1.6.0.6

