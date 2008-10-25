Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYJYDbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYJYDbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYJYDag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:30:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:24367 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYJYDa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wAGwPu3Bdinz+fhwlYliCcUKIwU0fyIW+kKTKX7wqdEmxKc7RzrSnty7Nca19nr6TD
         2pNzyL/eCkEr6omDAnZke+8d6aC0GgAItPmvZKlE8f8OHzJM6SlBLikBcd9BF3sGXpZG
         F6WTmk0M+WQo+1BSyPlo1OhTeDS0wRV7eARWA=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 03/12] x86: Cleanup usage of struct desc_struct
Date: Fri, 24 Oct 2008 20:15:23 -0700
Message-Id: <4810cc08c12cd78612b53f9b52d7ba93a9b03fd0.1224903712.git.ice799@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
References: <>
 <1224904532-9586-1-git-send-email-ice799@gmail.com>
 <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
 <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
In-Reply-To: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
References: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gate_desc typedef for IDT entries instead of struct desc_struct.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 arch/x86/kernel/vmi_32.c              |    2 +-
 drivers/lguest/interrupts_and_traps.c |   12 ++++++------
 drivers/lguest/lg.h                   |    2 +-
 include/asm-x86/lguest.h              |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 8b6c393..8c87b9b 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -63,7 +63,7 @@ static struct {
 	void (*cpuid)(void /* non-c */);
 	void (*_set_ldt)(u32 selector);
 	void (*set_tr)(u32 selector);
-	void (*write_idt_entry)(struct desc_struct *, int, u32, u32);
+	void (*write_idt_entry)(gate_desc *, int, u32, u32);
 	void (*write_gdt_entry)(struct desc_struct *, int, u32, u32);
 	void (*write_ldt_entry)(struct desc_struct *, int, u32, u32);
 	void (*set_kernel_stack)(u32 selector, u32 sp0);
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index a103906..48aa15b 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -133,7 +133,7 @@ void maybe_do_interrupt(struct lg_cpu *cpu)
 {
 	unsigned int irq;
 	DECLARE_BITMAP(blk, LGUEST_IRQS);
-	struct desc_struct *idt;
+	gate_desc *idt;
 
 	/* If the Guest hasn't even initialized yet, we can do nothing. */
 	if (!cpu->lg->lguest_data)
@@ -353,7 +353,7 @@ void guest_set_stack(struct lg_cpu *cpu, u32 seg, u32 esp, unsigned int pages)
 
 /*H:235 This is the routine which actually checks the Guest's IDT entry and
  * transfers it into the entry in "struct lguest": */
-static void set_trap(struct lg_cpu *cpu, struct desc_struct *trap,
+static void set_trap(struct lg_cpu *cpu, gate_desc *trap,
 		     unsigned int num, u32 lo, u32 hi)
 {
 	u8 type = idt_type(lo, hi);
@@ -404,10 +404,10 @@ void load_guest_idt_entry(struct lg_cpu *cpu, unsigned int num, u32 lo, u32 hi)
 /* The default entry for each interrupt points into the Switcher routines which
  * simply return to the Host.  The run_guest() loop will then call
  * deliver_trap() to bounce it back into the Guest. */
-static void default_idt_entry(struct desc_struct *idt,
+static void default_idt_entry(gate_desc *idt,
 			      int trap,
 			      const unsigned long handler,
-			      const struct desc_struct *base)
+			      const gate_desc *base)
 {
 	/* A present interrupt gate. */
 	u32 flags = 0x8e00;
@@ -439,7 +439,7 @@ void setup_default_idt_entries(struct lguest_ro_state *state,
 /*H:240 We don't use the IDT entries in the "struct lguest" directly, instead
  * we copy them into the IDT which we've set up for Guests on this CPU, just
  * before we run the Guest.  This routine does that copy. */
-void copy_traps(const struct lg_cpu *cpu, struct desc_struct *idt,
+void copy_traps(const struct lg_cpu *cpu, gate_desc *idt,
 		const unsigned long *def)
 {
 	unsigned int i;
@@ -447,7 +447,7 @@ void copy_traps(const struct lg_cpu *cpu, struct desc_struct *idt,
 	/* We can simply copy the direct traps, otherwise we use the default
 	 * ones in the Switcher: they will return to the Host. */
 	for (i = 0; i < ARRAY_SIZE(cpu->arch.idt); i++) {
-		const struct desc_struct *gidt = &cpu->arch.idt[i];
+		const gate_desc *gidt = &cpu->arch.idt[i];
 
 		/* If no Guest can ever override this trap, leave it alone. */
 		if (!direct_trap(i))
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 5faefea..4377488 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -147,7 +147,7 @@ void guest_set_stack(struct lg_cpu *cpu, u32 seg, u32 esp, unsigned int pages);
 void pin_stack_pages(struct lg_cpu *cpu);
 void setup_default_idt_entries(struct lguest_ro_state *state,
 			       const unsigned long *def);
-void copy_traps(const struct lg_cpu *cpu, struct desc_struct *idt,
+void copy_traps(const struct lg_cpu *cpu, gate_desc *idt,
 		const unsigned long *def);
 void guest_set_clockevent(struct lg_cpu *cpu, unsigned long delta);
 void init_clockdev(struct lg_cpu *cpu);
diff --git a/include/asm-x86/lguest.h b/include/asm-x86/lguest.h
index 7505e94..9ccf6f4 100644
--- a/include/asm-x86/lguest.h
+++ b/include/asm-x86/lguest.h
@@ -61,7 +61,7 @@ struct lguest_ro_state {
 	struct desc_ptr guest_idt_desc;
 	struct desc_ptr guest_gdt_desc;
 	struct x86_hw_tss guest_tss;
-	struct desc_struct guest_idt[IDT_ENTRIES];
+	gate_desc guest_idt[IDT_ENTRIES];
 	struct desc_struct guest_gdt[GDT_ENTRIES];
 };
 
@@ -70,7 +70,7 @@ struct lg_cpu_arch {
 	struct desc_struct gdt[GDT_ENTRIES];
 
 	/* The IDT entries: some copied into lguest_ro_state when running. */
-	struct desc_struct idt[IDT_ENTRIES];
+	gate_desc idt[IDT_ENTRIES];
 
 	/* The address of the last guest-visible pagefault (ie. cr2). */
 	unsigned long last_pagefault;
-- 
1.5.4.3

