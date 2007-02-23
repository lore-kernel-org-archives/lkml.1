Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbXBWBre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbXBWBre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXBWBre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:47:34 -0500
Received: from mga05.intel.com ([192.55.52.89]:22511 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752112AbXBWBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:47:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,208,1170662400"; 
   d="scan'208"; a="203159446:sNHT18953375"
Date: Thu, 22 Feb 2007 17:12:10 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/5] RT kernel: HPET relates boot option changes in x86-64
Message-ID: <20070222171210.D27475@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Cleanup HPET related boot options in x86-64 and deprecate 'nohpet'.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
@@ -19,6 +19,7 @@
 #include <asm/idle.h>
 
 int nohpet __initdata;
+static int nohpetforce __initdata;
 
 unsigned long hpet_address;
 unsigned long hpet_period;	/* fsecs / HPET clock */
@@ -217,6 +218,19 @@ static int __init nohpet_setup(char *s)
 
 __setup("nohpet", nohpet_setup);
 
+static int __init hpet_setup(char *str)
+{
+	if (str) {
+		if (!strncmp("disable", str, 7))
+			nohpet = 1;
+		if (!strncmp("noforce", str, 7))
+			nohpetforce = 1;
+	}
+	return 1;
+}
+
+__setup("hpet=", hpet_setup);
+
 /* Clocksource */
 #define HPET_MASK	0xFFFFFFFF
 #define HPET_SHIFT	22
@@ -722,7 +736,7 @@ static int __init init_hpet_generic_time
 	if (nohpet)
 		return -ENODEV;
 
-	if (!hpet_address) {
+	if (!hpet_address && !nohpetforce) {
 		hpet_address = force_hpet_address;
 	} else {
 		hpet_timer_stop();
Index: linux-2.6.21-rc-mm/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.21-rc-mm.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.21-rc-mm/Documentation/kernel-parameters.txt
@@ -371,8 +371,12 @@ and is between 256 and 4096 characters. 
 			over the 8254 in addition to over the IO-APIC. The
 			kernel tries to set a sensible default.
 
-	hpet=		[IA-32,HPET] option to disable HPET and use PIT.
-			Format: disable
+	hpet=		[IA-32/X86_64,HPET] option to disable HPET and use PIT.
+			Format: disable|noforce
+			disable - disables HPET timer detection and usage
+			noforce - disables HPET timer detection and usage when
+			          it is not explicitly enabled in BIOS. i.e,
+				  HPET is not enabled based on quirks.
 
 	cm206=		[HW,CD]
 			Format: { auto | [<io>,][<irq>] }
Index: linux-2.6.21-rc-mm/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.21-rc-mm.orig/Documentation/feature-removal-schedule.txt
+++ linux-2.6.21-rc-mm/Documentation/feature-removal-schedule.txt
@@ -316,3 +316,12 @@ Why:	Unmaintained for years, superceded 
 Who:	Jeff Garzik <jeff@garzik.org>
 
 ---------------------------
+
+What:	X86-64 "nohpet" boot option
+When:	May 2007
+Why:	nohpet is not documented boot option in x86-64. There is a documented
+	boot option in i386 for similar purpose (hpet=), which is now in
+	x86-64 as well.
+Who:	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+
+---------------------------
