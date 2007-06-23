Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXFWNXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXFWNXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXFWNV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:21:59 -0400
Received: from www.osadl.org ([213.239.205.134]:59194 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756179AbXFWNV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:21:57 -0400
Message-Id: <20070623124030.215035893@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Len Brown <lenb@kernel.org>
Subject: [patch -mm 02/28] ACPI: Move timer broadcast and pmtimer access
	before C3 arbiter shutdown
Content-Disposition: inline;
	filename=acpi-move-timer-broadcast-before-arb-dis.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Udo A. Steinberg <us15@os.inf.tu-dresden.de>

The chipset doc for IHC4 tells us:

1.In general, software should not attempt any non-posted accesses during
arbiter disable except to the ICH4's power management registers. This implies
that interrupt handlers for any unmasked hardware interrupts and SMI/NMI should
check ARB_DIS status before reading from ICH devices.

So it's not a good idea to access ICH devices after arbiter shut down.

Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>

---
 drivers/acpi/processor_idle.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/drivers/acpi/processor_idle.c	2007-06-23 14:38:57.000000000 +0200
+++ linux-2.6.22-rc4-mm/drivers/acpi/processor_idle.c	2007-06-23 14:38:57.000000000 +0200
@@ -978,6 +978,12 @@ static int acpi_idle_enter_c3(struct cpu
 		return 0;
 	}
 
+	/*
+	 * Must be done before busmaster disable as we might need to
+	 * access HPET !
+	 */
+	acpi_state_timer_broadcast(pr, cx, 1);
+
 	/* disable bus master */
 	if (pr->flags.bm_check) {
 		spin_lock(&c3_lock);
@@ -997,7 +1003,6 @@ static int acpi_idle_enter_c3(struct cpu
 
 	/* Get start time (ticks) */
 	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
-	acpi_state_timer_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 

-- 

