Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXEMEHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXEMEHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 00:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbXEMEHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 00:07:48 -0400
Received: from ozlabs.org ([203.10.76.45]:55854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbXEMEHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 00:07:47 -0400
Subject: Re: [PATCH 1/5] lguest host feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       hch <hch@infradead.org>
In-Reply-To: <1178846354.23513.23.camel@localhost.localdomain>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 13 May 2007 14:07:25 +1000
Message-Id: <1179029245.23513.121.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 11:19 +1000, Rusty Russell wrote:
> 1) Sam Ravnborg says lg-objs is deprecated, use lg-y.
> 2) Sparse: page_tables.c unnecessary initialization
> 3) Lots of __force to shut sparse up: guest "physical" addresses are
>    userspace virtual.
> 4) Change prototype of run_lguest and do cast in caller instead (when we add
>    __iomem to cast, it runs over another line).

(Andrew: replacement for lguest-the-host-code-tidyups.patch)

Christoph Hellwig said runs sparse:
1) page_tables.c unnecessary initialization
2) Change prototype of run_lguest and do cast in caller instead (when we add
   __user to cast, it runs over another line).

Most importantly, I now realize that Christoph's incorrect ranting
about lgread_u32 et al was in fact a subtle ploy to make me diagnose
the real issue: sparse 0.3 complains about casting a __user pointer
to/from u32, but not an "unsigned long".  They are (currently)
equivalent for lguest, but this is a much better solution than __force.

Kudos, Christoph, for such masterful manipulation!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/core.c                 |   37 ++++++++++++++++-----------------
 drivers/lguest/hypercalls.c           |    9 +++-----
 drivers/lguest/interrupts_and_traps.c |    4 +--
 drivers/lguest/io.c                   |    2 -
 drivers/lguest/lg.h                   |   37 ++++++++++++++++-----------------
 drivers/lguest/lguest_user.c          |    2 -
 drivers/lguest/page_tables.c          |    2 -
 drivers/lguest/segments.c             |    6 ++---
 include/linux/lguest_launcher.h       |    4 +--
 10 files changed, 52 insertions(+), 53 deletions(-)

diff -r 35c8b37f8d3c drivers/lguest/core.c
--- a/drivers/lguest/core.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/core.c	Sun May 13 13:05:13 2007 +1000
@@ -212,39 +212,40 @@ int lguest_address_ok(const struct lgues
 }
 
 /* Just like get_user, but don't let guest access lguest binary. */
-u32 lgread_u32(struct lguest *lg, u32 addr)
+u32 lgread_u32(struct lguest *lg, unsigned long addr)
 {
 	u32 val = 0;
 
 	/* Don't let them access lguest binary */
 	if (!lguest_address_ok(lg, addr, sizeof(val))
 	    || get_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad read address %u", addr);
+		kill_guest(lg, "bad read address %#lx", addr);
 	return val;
 }
 
-void lgwrite_u32(struct lguest *lg, u32 addr, u32 val)
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val)
 {
 	if (!lguest_address_ok(lg, addr, sizeof(val))
 	    || put_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad write address %u", addr);
-}
-
-void lgread(struct lguest *lg, void *b, u32 addr, unsigned bytes)
+		kill_guest(lg, "bad write address %#lx", addr);
+}
+
+void lgread(struct lguest *lg, void *b, unsigned long addr, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
 	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
 		/* copy_from_user should do this, but as we rely on it... */
 		memset(b, 0, bytes);
-		kill_guest(lg, "bad read address %u len %u", addr, bytes);
-	}
-}
-
-void lgwrite(struct lguest *lg, u32 addr, const void *b, unsigned bytes)
+		kill_guest(lg, "bad read address %#lx len %u", addr, bytes);
+	}
+}
+
+void lgwrite(struct lguest *lg, unsigned long addr, const void *b,
+	     unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
 	    || copy_to_user((void __user *)addr, b, bytes) != 0)
-		kill_guest(lg, "bad write address %u len %u", addr, bytes);
+		kill_guest(lg, "bad write address %#lx len %u", addr, bytes);
 }
 
 static void set_ts(void)
@@ -294,7 +295,7 @@ static void run_guest_once(struct lguest
 		     : "memory", "%edx", "%ecx", "%edi", "%esi");
 }
 
-int run_guest(struct lguest *lg, char *__user user)
+int run_guest(struct lguest *lg, unsigned long __user *user)
 {
 	while (!lg->dead) {
 		unsigned int cr2 = 0; /* Damn gcc */
@@ -302,8 +303,8 @@ int run_guest(struct lguest *lg, char *_
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
@@ -367,7 +368,7 @@ int run_guest(struct lguest *lg, char *_
 		if (deliver_trap(lg, lg->regs->trapnum))
 			continue;
 
-		kill_guest(lg, "unhandled trap %i at %#x (%#x)",
+		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
 			   lg->regs->trapnum, lg->regs->eip,
 			   lg->regs->trapnum == 14 ? cr2 : lg->regs->errcode);
 	}
@@ -420,7 +421,7 @@ static int __init init(void)
 	lock_cpu_hotplug();
 	if (cpu_has_pge) { /* We have a broader idea of "global". */
 		cpu_had_pge = 1;
-		on_each_cpu(adjust_pge, 0, 0, 1);
+		on_each_cpu(adjust_pge, (void *)0, 0, 1);
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 	}
 	unlock_cpu_hotplug();
diff -r 35c8b37f8d3c drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/hypercalls.c	Sun May 13 13:07:20 2007 +1000
@@ -83,7 +83,7 @@ static void do_hcall(struct lguest *lg, 
 		guest_set_pmd(lg, regs->edx, regs->ebx);
 		break;
 	case LHCALL_LOAD_TLS:
-		guest_load_tls(lg, (struct desc_struct __user*)regs->edx);
+		guest_load_tls(lg, regs->edx);
 		break;
 	case LHCALL_TS:
 		lg->ts = regs->edx;
@@ -92,7 +92,7 @@ static void do_hcall(struct lguest *lg, 
 		lg->halted = 1;
 		break;
 	default:
-		kill_guest(lg, "Bad hypercall %i\n", regs->eax);
+		kill_guest(lg, "Bad hypercall %li\n", regs->eax);
 	}
 }
 
@@ -137,15 +137,14 @@ static void initialize(struct lguest *lg
 static void initialize(struct lguest *lg)
 {
 	if (lg->regs->eax != LHCALL_LGUEST_INIT) {
-		kill_guest(lg, "hypercall %i before LGUEST_INIT",
+		kill_guest(lg, "hypercall %li before LGUEST_INIT",
 			   lg->regs->eax);
 		return;
 	}
 
 	lg->lguest_data = (struct lguest_data __user *)lg->regs->edx;
 	/* We check here so we can simply copy_to_user/from_user */
-	if (!lguest_address_ok(lg, (long)lg->lguest_data,
-			       sizeof(*lg->lguest_data))) {
+	if (!lguest_address_ok(lg, lg->regs->edx, sizeof(*lg->lguest_data))) {
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 		return;
 	}
diff -r 35c8b37f8d3c drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/interrupts_and_traps.c	Sun May 13 13:20:40 2007 +1000
@@ -18,7 +18,7 @@ static int idt_present(u32 lo, u32 hi)
 
 static void push_guest_stack(struct lguest *lg, u32 __user **gstack, u32 val)
 {
-	lgwrite_u32(lg, (u32)--(*gstack), val);
+	lgwrite_u32(lg, (unsigned long)--(*gstack), val);
 }
 
 static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
@@ -53,7 +53,7 @@ static void set_guest_interrupt(struct l
 
 	/* Change the real stack so switcher returns to trap handler */
 	lg->regs->ss = ss;
-	lg->regs->esp = (u32)gstack + lg->page_offset;
+	lg->regs->esp = (unsigned long)gstack + lg->page_offset;
 	lg->regs->cs = (__KERNEL_CS|GUEST_PL);
 	lg->regs->eip = idt_address(lo, hi);
 
diff -r 35c8b37f8d3c drivers/lguest/io.c
--- a/drivers/lguest/io.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/io.c	Sun May 13 13:09:20 2007 +1000
@@ -52,7 +52,7 @@ static int check_dma_list(struct lguest 
 	return 1;
 
 kill:
-	kill_guest(lg, "bad DMA entry: %u@%#x", dma->len[i], dma->addr[i]);
+	kill_guest(lg, "bad DMA entry: %u@%#lx", dma->len[i], dma->addr[i]);
 	return 0;
 }
 
diff -r 35c8b37f8d3c drivers/lguest/lg.h
--- a/drivers/lguest/lg.h	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/lg.h	Sun May 13 13:06:53 2007 +1000
@@ -25,18 +25,18 @@ struct lguest_regs
 struct lguest_regs
 {
 	/* Manually saved part. */
-	u32 ebx, ecx, edx;
-	u32 esi, edi, ebp;
-	u32 gs;
-	u32 eax;
-	u32 fs, ds, es;
-	u32 trapnum, errcode;
+	unsigned long ebx, ecx, edx;
+	unsigned long esi, edi, ebp;
+	unsigned long gs;
+	unsigned long eax;
+	unsigned long fs, ds, es;
+	unsigned long trapnum, errcode;
 	/* Trap pushed part */
-	u32 eip;
-	u32 cs;
-	u32 eflags;
-	u32 esp;
-	u32 ss;
+	unsigned long eip;
+	unsigned long cs;
+	unsigned long eflags;
+	unsigned long esp;
+	unsigned long ss;
 };
 
 void free_pagetables(void);
@@ -175,14 +175,14 @@ extern struct mutex lguest_lock;
 extern struct mutex lguest_lock;
 
 /* core.c: */
-u32 lgread_u32(struct lguest *lg, u32 addr);
-void lgwrite_u32(struct lguest *lg, u32 val, u32 addr);
-void lgread(struct lguest *lg, void *buf, u32 addr, unsigned bytes);
-void lgwrite(struct lguest *lg, u32 addr, const void *buf, unsigned bytes);
+u32 lgread_u32(struct lguest *lg, unsigned long addr);
+void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val);
+void lgread(struct lguest *lg, void *buf, unsigned long addr, unsigned len);
+void lgwrite(struct lguest *lg, unsigned long, const void *buf, unsigned len);
 int find_free_guest(void);
 int lguest_address_ok(const struct lguest *lg,
 		      unsigned long addr, unsigned long len);
-int run_guest(struct lguest *lg, char *__user user);
+int run_guest(struct lguest *lg, unsigned long __user *user);
 
 
 /* interrupts_and_traps.c: */
@@ -199,9 +199,8 @@ void copy_traps(const struct lguest *lg,
 /* segments.c: */
 void setup_default_gdt_entries(struct lguest_ro_state *state);
 void setup_guest_gdt(struct lguest *lg);
-void load_guest_gdt(struct lguest *lg, u32 table, u32 num);
-void guest_load_tls(struct lguest *lg,
-		    const struct desc_struct __user *tls_array);
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
+void guest_load_tls(struct lguest *lg, unsigned long tls_array);
 void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
 
 /* page_tables.c: */
diff -r 35c8b37f8d3c drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/lguest_user.c	Sun May 13 11:48:43 2007 +1000
@@ -65,7 +65,7 @@ static ssize_t read(struct file *file, c
 	if (lg->dma_is_pending)
 		lg->dma_is_pending = 0;
 
-	return run_guest(lg, user);
+	return run_guest(lg, (unsigned long __user *)user);
 }
 
 /* Take: pfnlimit, pgdir, start, pageoffset. */
diff -r 35c8b37f8d3c drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/page_tables.c	Sun May 13 11:48:43 2007 +1000
@@ -13,7 +13,7 @@
 #define PTES_PER_PAGE (1 << PTES_PER_PAGE_SHIFT)
 #define SWITCHER_PGD_INDEX (PTES_PER_PAGE - 1)
 
-static DEFINE_PER_CPU(spte_t *, switcher_pte_pages) = { NULL };
+static DEFINE_PER_CPU(spte_t *, switcher_pte_pages);
 #define switcher_pte_page(cpu) per_cpu(switcher_pte_pages, cpu)
 
 static unsigned vaddr_to_pgd_index(unsigned long vaddr)
diff -r 35c8b37f8d3c drivers/lguest/segments.c
--- a/drivers/lguest/segments.c	Wed May 09 23:23:56 2007 +1000
+++ b/drivers/lguest/segments.c	Sun May 13 13:07:01 2007 +1000
@@ -95,7 +95,7 @@ void copy_gdt(const struct lguest *lg, s
 			gdt[i] = lg->gdt[i];
 }
 
-void load_guest_gdt(struct lguest *lg, u32 table, u32 num)
+void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
 {
 	if (num > ARRAY_SIZE(lg->gdt))
 		kill_guest(lg, "too many gdt entries %i", num);
@@ -105,11 +105,11 @@ void load_guest_gdt(struct lguest *lg, u
 	lg->changed |= CHANGED_GDT;
 }
 
-void guest_load_tls(struct lguest *lg, const struct desc_struct __user *gtls)
+void guest_load_tls(struct lguest *lg, unsigned long gtls)
 {
 	struct desc_struct *tls = &lg->gdt[GDT_ENTRY_TLS_MIN];
 
-	lgread(lg, tls, (u32)gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
+	lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
 	fixup_gdt_table(lg);
 	lg->changed |= CHANGED_GDT;
 }
diff -r 35c8b37f8d3c include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h	Wed May 09 23:23:56 2007 +1000
+++ b/include/linux/lguest_launcher.h	Sun May 13 14:01:33 2007 +1000
@@ -13,7 +13,7 @@ struct lguest_dma
 {
 	/* 0 if free to be used, filled by hypervisor. */
  	u32 used_len;
-	u32 addr[LGUEST_MAX_DMA_SECTIONS];
+	unsigned long addr[LGUEST_MAX_DMA_SECTIONS];
 	u16 len[LGUEST_MAX_DMA_SECTIONS];
 };
 


