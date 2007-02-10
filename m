Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbXBJLkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbXBJLkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXBJLkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:40:18 -0500
Received: from ozlabs.org ([203.10.76.45]:46174 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbXBJLkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:40:16 -0500
Subject: Re: [PATCH 2/10] lguest: Export symbols for lguest as a module
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <20070209135855.GC18080@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012458.2718.30.camel@localhost.localdomain>
	 <1171012513.2718.32.camel@localhost.localdomain>
	 <200702091032.44547.ak@muc.de>
	 <1171022766.2718.94.camel@localhost.localdomain>
	 <20070209135855.GC18080@muc.de>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 22:39:32 +1100
Message-Id: <1171107572.15356.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 14:58 +0100, Andi Kleen wrote:
> On Fri, Feb 09, 2007 at 11:06:06PM +1100, Rusty Russell wrote:
> > On Fri, 2007-02-09 at 10:32 +0100, Andi Kleen wrote:
> > > Are you sure this will work with varying TSC frequencies? 
> > 
> > I'm actually quite sure it doesn't (there's a FIXME in the lguest code).
> > Given the debate over how useful the TSC was, I originally didn't use
> > it, but (1) it's simple, and (2) when it doesn't change, it's pretty
> > accurate.
> 
> But when it changes users become pretty unhappy

True.  Simplest fix is below.  There are several time issues on the TODO
list, and I will simply add this one.

Thanks!
Rusty.

lguest: Don't use the TSC in guest.

Andi complained that lguest guests don't deal with host TSC speed
changing.  Close this can of worms by not using the TSC in the guest.
Later on we could do something clever when we overhaul this to deal
with stolen time (also on the TODO list).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -475,4 +475,3 @@ static int __init init_tsc_clocksource(v
 }
 
 module_init(init_tsc_clocksource);
-EXPORT_SYMBOL_GPL(tsc_khz);
===================================================================
--- a/arch/i386/lguest/hypercalls.c
+++ b/arch/i386/lguest/hypercalls.c
@@ -18,7 +18,6 @@
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
-#include <linux/clocksource.h>
 #include <asm/lguest.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -179,8 +178,6 @@ int hypercall(struct lguest *lg, struct 
 		/* We reserve the top pgd entry. */
 		put_user(4U*1024*1024, &lg->lguest_data->reserve_mem);
 		put_user(lg->guestid, &lg->lguest_data->guestid);
-		put_user(clocksource_khz2mult(tsc_khz, 22),
-			 &lg->lguest_data->clock_mult);
 		return 0;
 	}
 	pending = do_hcall(lg, regs);
===================================================================
--- a/arch/i386/lguest/lguest.c
+++ b/arch/i386/lguest/lguest.c
@@ -25,7 +25,6 @@
 #include <linux/screen_info.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/clocksource.h>
 #include <asm/paravirt.h>
 #include <asm/lguest.h>
 #include <asm/lguest_user.h>
@@ -138,29 +137,10 @@ static struct notifier_block paniced = {
 	.notifier_call = lguest_panic
 };
 
-static cycle_t lguest_clock_read(void)
-{
-	/* FIXME: This is just the native one.  Account stolen time! */
-	return paravirt_ops.read_tsc();
-}
-
-/* FIXME: Update iff tsc rate changes. */
-static struct clocksource lguest_clock = {
-	.name			= "lguest",
-	.rating			= 400,
-	.read			= lguest_clock_read,
-	.mask			= CLOCKSOURCE_MASK(64),
-	.mult			= 0, /* to be set */
-	.shift			= 22,
-	.is_continuous		= 1,
-};
-
 static char *lguest_memory_setup(void)
 {
 	/* We do these here because lockcheck barfs if before start_kernel */
 	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
-	lguest_clock.mult = lguest_data.clock_mult;
-	clocksource_register(&lguest_clock);
 
 	e820.nr_map = 0;
 	add_memory_region(0, PFN_PHYS(boot->max_pfn), E820_RAM);
===================================================================
--- a/include/asm-i386/lguest.h
+++ b/include/asm-i386/lguest.h
@@ -74,8 +74,6 @@ struct lguest_data
 	unsigned long reserve_mem;
 	/* ID of this guest (used by network driver to set ethernet address) */
 	u16 guestid;
-	/* Multiplier for TSC clock. */
-	u32 clock_mult;
 
 /* Fields initialized by the guest at boot: */
 	/* Instruction range to suppress interrupts even if enabled */


