Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXFJJbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXFJJbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXFJJa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:30:58 -0400
Received: from www.osadl.org ([213.239.205.134]:43024 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752634AbXFJJax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:30:53 -0400
Message-Id: <20070610092446.437590871@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Len Brown <lenb@kernel.org>
Subject: [patch-mm 02/23] ACPI: Move timer broadcast and pmtimer access before
	C3 arbiter shutdown
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

So it's not a good idea to access ICH devices after arbiter shut down. It freezes
ICH4 based boxen hard, when HPET is accessed after the arbiter shutdown.

Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>

---
 drivers/acpi/processor_idle.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/drivers/acpi/processor_idle.c	2007-06-10 10:44:37.000000000 +0200
+++ linux-2.6.22-rc4-mm/drivers/acpi/processor_idle.c	2007-06-10 10:44:38.000000000 +0200
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

