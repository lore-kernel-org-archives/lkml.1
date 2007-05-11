Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbXEKBTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbXEKBTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXEKBTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:19:30 -0400
Received: from ozlabs.org ([203.10.76.45]:50066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbXEKBT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:19:29 -0400
Subject: [PATCH 1/5] lguest host feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1178846246.23513.21.camel@localhost.localdomain>
References: <1178846246.23513.21.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 11 May 2007 11:19:14 +1000
Message-Id: <1178846354.23513.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) Sam Ravnborg says lg-objs is deprecated, use lg-y.
2) Sparse: page_tables.c unnecessary initialization
3) Lots of __force to shut sparse up: guest "physical" addresses are
   userspace virtual.
4) Change prototype of run_lguest and do cast in caller instead (when we add
   __iomem to cast, it runs over another line).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/Makefile               |    2 +-
 drivers/lguest/core.c                 |   16 ++++++++--------
 drivers/lguest/hypercalls.c           |    3 ++-
 drivers/lguest/interrupts_and_traps.c |    4 ++--
 drivers/lguest/lg.h                   |    2 +-
 drivers/lguest/lguest_user.c          |    2 +-
 drivers/lguest/page_tables.c          |    2 +-
 7 files changed, 16 insertions(+), 15 deletions(-)

===================================================================
--- a/drivers/lguest/Makefile
+++ b/drivers/lguest/Makefile
@@ -3,5 +3,5 @@ obj-$(CONFIG_LGUEST_GUEST) += lguest.o l
 
 # Host requires the other files, which can be a module.
 obj-$(CONFIG_LGUEST)	+= lg.o
-lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+lg-y := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
 	segments.o io.o lguest_user.o switcher.o
===================================================================
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -218,7 +218,7 @@ u32 lgread_u32(struct lguest *lg, u32 ad
 
 	/* Don't let them access lguest binary */
 	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || get_user(val, (u32 __user *)addr) != 0)
+	    || get_user(val, (__force u32 __user *)addr) != 0)
 		kill_guest(lg, "bad read address %u", addr);
 	return val;
 }
@@ -226,14 +226,14 @@ void lgwrite_u32(struct lguest *lg, u32 
 void lgwrite_u32(struct lguest *lg, u32 addr, u32 val)
 {
 	if (!lguest_address_ok(lg, addr, sizeof(val))
-	    || put_user(val, (u32 __user *)addr) != 0)
+	    || put_user(val, (__force u32 __user *)addr) != 0)
 		kill_guest(lg, "bad write address %u", addr);
 }
 
 void lgread(struct lguest *lg, void *b, u32 addr, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
+	    || copy_from_user(b, (__force void __user *)addr, bytes) != 0) {
 		/* copy_from_user should do this, but as we rely on it... */
 		memset(b, 0, bytes);
 		kill_guest(lg, "bad read address %u len %u", addr, bytes);
@@ -243,7 +243,7 @@ void lgwrite(struct lguest *lg, u32 addr
 void lgwrite(struct lguest *lg, u32 addr, const void *b, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
-	    || copy_to_user((void __user *)addr, b, bytes) != 0)
+	    || copy_to_user((__force void __user *)addr, b, bytes) != 0)
 		kill_guest(lg, "bad write address %u len %u", addr, bytes);
 }
 
@@ -294,7 +294,7 @@ static void run_guest_once(struct lguest
 		     : "memory", "%edx", "%ecx", "%edi", "%esi");
 }
 
-int run_guest(struct lguest *lg, char *__user user)
+int run_guest(struct lguest *lg, unsigned long __user *user)
 {
 	while (!lg->dead) {
 		unsigned int cr2 = 0; /* Damn gcc */
@@ -302,8 +302,8 @@ int run_guest(struct lguest *lg, char *_
 		/* Hypercalls first: we might have been out to userspace */
 		do_hypercalls(lg);
 		if (lg->dma_is_pending) {
-			if (put_user(lg->pending_dma, (unsigned long *)user) ||
-			    put_user(lg->pending_key, (unsigned long *)user+1))
+			if (put_user(lg->pending_dma, user) ||
+			    put_user(lg->pending_key, user+1))
 				return -EFAULT;
 			return sizeof(unsigned long)*2;
 		}
@@ -420,7 +420,7 @@ static int __init init(void)
 	lock_cpu_hotplug();
 	if (cpu_has_pge) { /* We have a broader idea of "global". */
 		cpu_had_pge = 1;
-		on_each_cpu(adjust_pge, 0, 0, 1);
+		on_each_cpu(adjust_pge, (void *)0, 0, 1);
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 	}
 	unlock_cpu_hotplug();
===================================================================
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -83,7 +83,8 @@ static void do_hcall(struct lguest *lg, 
 		guest_set_pmd(lg, regs->edx, regs->ebx);
 		break;
 	case LHCALL_LOAD_TLS:
-		guest_load_tls(lg, (struct desc_struct __user*)regs->edx);
+		guest_load_tls(lg,
+			       (__force struct desc_struct __user*)regs->edx);
 		break;
 	case LHCALL_TS:
 		lg->ts = regs->edx;
===================================================================
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -18,7 +18,7 @@ static int idt_present(u32 lo, u32 hi)
 
 static void push_guest_stack(struct lguest *lg, u32 __user **gstack, u32 val)
 {
-	lgwrite_u32(lg, (u32)--(*gstack), val);
+	lgwrite_u32(lg, (__force u32)--(*gstack), val);
 }
 
 static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
@@ -53,7 +53,7 @@ static void set_guest_interrupt(struct l
 
 	/* Change the real stack so switcher returns to trap handler */
 	lg->regs->ss = ss;
-	lg->regs->esp = (u32)gstack + lg->page_offset;
+	lg->regs->esp = (__force u32)gstack + lg->page_offset;
 	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
 	lg->regs->eip = idt_address(lo, hi);
 
===================================================================
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -182,7 +182,7 @@ int find_free_guest(void);
 int find_free_guest(void);
 int lguest_address_ok(const struct lguest *lg,
 		      unsigned long addr, unsigned long len);
-int run_guest(struct lguest *lg, char *__user user);
+int run_guest(struct lguest *lg, unsigned long __user *user);
 
 
 /* interrupts_and_traps.c: */
===================================================================
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -65,7 +65,7 @@ static ssize_t read(struct file *file, c
 	if (lg->dma_is_pending)
 		lg->dma_is_pending = 0;
 
-	return run_guest(lg, user);
+	return run_guest(lg, (unsigned long __user *)user);
 }
 
 /* Take: pfnlimit, pgdir, start, pageoffset. */
===================================================================
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -13,7 +13,7 @@
 #define PTES_PER_PAGE (1 << PTES_PER_PAGE_SHIFT)
 #define SWITCHER_PGD_INDEX (PTES_PER_PAGE - 1)
 
-static DEFINE_PER_CPU(spte_t *, switcher_pte_pages) = { NULL };
+static DEFINE_PER_CPU(spte_t *, switcher_pte_pages);
 #define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
 
 static unsigned vaddr_to_pgd_index(unsigned long vaddr)


