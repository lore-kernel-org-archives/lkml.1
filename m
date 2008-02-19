Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbYBSLW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbYBSLW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYBSLWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:22:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45882 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759213AbYBSLWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:22:46 -0500
Date: Tue, 19 Feb 2008 11:00:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, jbohac@suse.cz
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
Message-ID: <20080219100029.GA1637@elf.ucw.cz>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TSC is used even on machines when CONFIG_X86_TSC is not set (X86_TSC
means _require_ TSC), but it is not properly disabled when it is
unusable, because acpi code understood the config switch as "may use
TSC".

This actually fixes suspend problems on my x60.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 980e1c3..6f3b217 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -364,7 +364,7 @@ int acpi_processor_resume(struct acpi_de
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 static int tsc_halts_in_c(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -544,7 +544,7 @@ #endif
 		/* Get end time (ticks) */
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 		/* TSC halts in C2, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C2))
 			mark_tsc_unstable("possible TSC halt in C2");
@@ -609,7 +609,7 @@ #endif
 			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
 		}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 		/* TSC halts in C3, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C3))
 			mark_tsc_unstable("TSC halts in C3");
@@ -1500,7 +1500,7 @@ static int acpi_idle_enter_simple(struct
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
@@ -1614,7 +1614,7 @@ static int acpi_idle_enter_bm(struct cpu
 		spin_unlock(&c3_lock);
 	}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
