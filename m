Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbYHNSr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbYHNSr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYHNSqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:55419 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYHNSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=KQw1ihPU5loWHJ541Y6Zs21M33pUvgrpRh6dH/IkarWhfRvhAciiFqLnQY/P7vibIa
         dXPfQ+iGl+e3mUKKQOCnj68GhcoJWOfp6J1ODRhd9nz/Rqc2G7bFHkPKw1/lI2T/CvHJ
         LHiXSZOw31Fj1dQmYBDa5e1+t1NRNpsLYPuoQ=
Message-Id: <20080814184651.471268866@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/8] x86: apic - unify disable_apic_timer
Content-Disposition: inline; filename=x86-apic-unify-disable_apic_timer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of local_apic_timer_disabled and use disable_apic_timer instead.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-12 22:45:09.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-12 22:46:16.000000000 +0400
@@ -63,7 +63,7 @@ int disable_apic;
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int local_apic_timer_disabled;
+static int disable_apic_timer __cpuinitdata;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -574,7 +574,7 @@ void __init setup_boot_APIC_clock(void)
 	 * timer as a dummy clock event source on SMP systems, so the
 	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
-	if (local_apic_timer_disabled) {
+	if (disable_apic_timer) {
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() > 1) {
 			lapic_clockevent.mult = 1;
@@ -1703,12 +1703,19 @@ static int __init parse_nolapic(char *ar
 }
 early_param("nolapic", parse_nolapic);
 
-static int __init parse_disable_lapic_timer(char *arg)
+static int __init parse_disable_apic_timer(char *arg)
 {
-	local_apic_timer_disabled = 1;
+	disable_apic_timer = 1;
 	return 0;
 }
-early_param("nolapic_timer", parse_disable_lapic_timer);
+early_param("noapictimer", parse_disable_apic_timer);
+
+static int __init parse_nolapic_timer(char *arg)
+{
+	disable_apic_timer = 1;
+	return 0;
+}
+early_param("nolapic_timer", parse_nolapic_timer);
 
 static int __init parse_lapic_timer_c2_ok(char *arg)
 {
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-08-12 22:45:37.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-08-12 22:46:16.000000000 +0400
@@ -45,6 +45,7 @@
 #include <mach_ipi.h>
 #include <mach_apic.h>
 
+/* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
@@ -1587,14 +1588,19 @@ static int __init parse_lapic_timer_c2_o
 }
 early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
 
-static __init int setup_noapictimer(char *str)
+static int __init parse_disable_apic_timer(char *arg)
 {
-	if (str[0] != ' ' && str[0] != 0)
-		return 0;
 	disable_apic_timer = 1;
-	return 1;
+	return 0;
+}
+early_param("noapictimer", parse_disable_apic_timer);
+
+static int __init parse_nolapic_timer(char *arg)
+{
+	disable_apic_timer = 1;
+	return 0;
 }
-__setup("noapictimer", setup_noapictimer);
+early_param("nolapic_timer", parse_nolapic_timer);
 
 static __init int setup_apicpmtimer(char *s)
 {

-- 
