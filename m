Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbXEDO7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbXEDO7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbXEDO7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:59:08 -0400
Received: from ozlabs.org ([203.10.76.45]:48283 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbXEDO7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:59:04 -0400
Subject: [PATCH 2/3] lguest: remove put_user etc warnings, add bloat
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <1178290638.23670.114.camel@localhost.localdomain>
References: <1178290638.23670.114.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 05 May 2007 00:58:50 +1000
Message-Id: <1178290730.23670.117.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've long disliked Linux's user access functions.  Nonetheless, let's
stop the warnings.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 drivers/lguest/core.c                 |    8 +++++---
 drivers/lguest/hypercalls.c           |   33 ++++++++++++++++++++++-----------
 drivers/lguest/interrupts_and_traps.c |   17 ++++++++++++-----
 3 files changed, 39 insertions(+), 19 deletions(-)

===================================================================
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -303,8 +303,9 @@ int run_guest(struct lguest *lg, char *_
 		/* Hypercalls first: we might have been out to userspace */
 		do_hypercalls(lg);
 		if (lg->dma_is_pending) {
-			put_user(lg->pending_dma, (unsigned long *)user);
-			put_user(lg->pending_key, (unsigned long *)user+1);
+			if (put_user(lg->pending_dma, (unsigned long *)user) ||
+			    put_user(lg->pending_key, (unsigned long *)user+1))
+				return -EFAULT;
 			return sizeof(unsigned long)*2;
 		}
 
@@ -350,7 +351,8 @@ int run_guest(struct lguest *lg, char *_
 				continue;
 
 			/* If lguest_data is NULL, this won't hurt. */
-			put_user(cr2, &lg->lguest_data->cr2);
+			if (put_user(cr2, &lg->lguest_data->cr2))
+				kill_guest(lg, "Writing cr2");
 			break;
 		case 7: /* We've intercepted a Device Not Available fault. */
 			/* If they don't want to know, just absorb it. */
===================================================================
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -102,7 +102,9 @@ static void do_async_hcalls(struct lgues
 	unsigned int i;
 	u8 st[LHCALL_RING_SIZE];
 
-	copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st));
+	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(st); i++) {
 		struct lguest_regs regs;
 		unsigned int n = lg->next_hcall;
@@ -113,12 +115,20 @@ static void do_async_hcalls(struct lgues
 		if (++lg->next_hcall == LHCALL_RING_SIZE)
 			lg->next_hcall = 0;
 
-		get_user(regs.eax, &lg->lguest_data->hcalls[n].eax);
-		get_user(regs.edx, &lg->lguest_data->hcalls[n].edx);
-		get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx);
-		get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx);
+		if (get_user(regs.eax, &lg->lguest_data->hcalls[n].eax)
+		    || get_user(regs.edx, &lg->lguest_data->hcalls[n].edx)
+		    || get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx)
+		    || get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx)) {
+			kill_guest(lg, "Fetching async hypercalls");
+			break;
+		}
+
 		do_hcall(lg, &regs);
-		put_user(0xFF, &lg->lguest_data->hcall_status[n]);
+		if (put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
+			kill_guest(lg, "Writing result for async hypercall");
+			break;
+		}
+
 		if (lg->dma_is_pending)
 			break;
 	}
@@ -139,11 +149,12 @@ static void initialize(struct lguest *lg
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 		return;
 	}
-	get_user(lg->noirq_start, &lg->lguest_data->noirq_start);
-	get_user(lg->noirq_end, &lg->lguest_data->noirq_end);
-	/* We reserve the top pgd entry. */
-	put_user(4U*1024*1024, &lg->lguest_data->reserve_mem);
-	put_user(lg->guestid, &lg->lguest_data->guestid);
+	if (get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
+	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
+	    /* We reserve the top pgd entry. */
+	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
+	    || put_user(lg->guestid, &lg->lguest_data->guestid))
+		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 
 	/* This is the one case where the above accesses might have
 	 * been the first write to a Guest page.  This may have caused
===================================================================
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -40,7 +40,8 @@ static void set_guest_interrupt(struct l
 	/* We use IF bit in eflags to indicate whether irqs were disabled
 	   (it's always 0, since irqs are enabled when guest is running). */
 	eflags = lg->regs->eflags;
-	get_user(irq_enable, &lg->lguest_data->irq_enabled);
+	if (get_user(irq_enable, &lg->lguest_data->irq_enabled))
+		irq_enable = 0;
 	eflags |= (irq_enable & X86_EFLAGS_IF);
 
 	push_guest_stack(lg, &gstack, eflags);
@@ -58,7 +59,8 @@ static void set_guest_interrupt(struct l
 
 	/* Disable interrupts for an interrupt gate. */
 	if (idt_type(lo, hi) == 0xE)
-		put_user(0, &lg->lguest_data->irq_enabled);
+		if (put_user(0, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Disabling interrupts");
 }
 
 void maybe_do_interrupt(struct lguest *lg)
@@ -75,7 +77,10 @@ void maybe_do_interrupt(struct lguest *l
 		set_bit(0, lg->irqs_pending);
 
 	/* Mask out any interrupts they have blocked. */
-	copy_from_user(&blk, lg->lguest_data->blocked_interrupts, sizeof(blk));
+	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
+			   sizeof(blk)))
+		return;
+
 	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
 
 	irq = find_first_bit(blk, LGUEST_IRQS);
@@ -88,12 +93,14 @@ void maybe_do_interrupt(struct lguest *l
 	/* If they're halted, we re-enable interrupts. */
 	if (lg->halted) {
 		/* Re-enable interrupts. */
-		put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled);
+		if (put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Re-enabling interrupts");
 		lg->halted = 0;
 	} else {
 		/* Maybe they have interrupts disabled? */
 		u32 irq_enabled;
-		get_user(irq_enabled, &lg->lguest_data->irq_enabled);
+		if (get_user(irq_enabled, &lg->lguest_data->irq_enabled))
+			irq_enabled = 0;
 		if (!irq_enabled)
 			return;
 	}


