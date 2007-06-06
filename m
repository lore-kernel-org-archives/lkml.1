Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbXFFJiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbXFFJiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXFFJh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:37:57 -0400
Received: from www.osadl.org ([213.239.205.134]:34531 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751599AbXFFJh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:37:56 -0400
Subject: [PATCH] ACPI: Move timer broadcast and pmtimer access before C3
	arbiter shutdown
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Stable Team <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@suse.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Dave Jones <davej@redhat.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 11:37:53 +0200
Message-Id: <1181122673.4404.200.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Udo A. Steinberg <us15@os.inf.tu-dresden.de>

The chip set doc for IHC4 says:

1.In general, software should not attempt any non-posted accesses during
arbiter disable except to the ICH4's power management registers. This
implies that interrupt handlers for any unmasked hardware interrupts and
SMI/NMI should check ARB_DIS status before reading from ICH devices.

So it's not a good idea to access ICH devices after arbiter shut down. 

Signed-off-by: Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/acpi/processor_idle.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc4/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/acpi/processor_idle.c	2007-06-06 11:47:21.000000000 +0200
+++ linux-2.6.22-rc4/drivers/acpi/processor_idle.c	2007-06-06 11:48:21.000000000 +0200
@@ -488,6 +488,11 @@ static void acpi_processor_idle(void)
 
 	case ACPI_STATE_C3:
 
+		/* Get start time (ticks) */
+		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		/* Handle timer broadcast before bus arbiter shutdown ! */
+		acpi_state_timer_broadcast(pr, cx, 1);
+
 		if (pr->flags.bm_check) {
 			if (atomic_inc_return(&c3_cpu_count) ==
 			    num_online_cpus()) {
@@ -502,10 +507,7 @@ static void acpi_processor_idle(void)
 			ACPI_FLUSH_CPU_CACHE();
 		}
 
-		/* Get start time (ticks) */
-		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 		/* Invoke C3 */
-		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);


