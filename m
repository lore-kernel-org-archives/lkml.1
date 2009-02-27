Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZB0Cm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZB0Cm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 21:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZB0Cmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 21:42:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:57945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbZB0Cms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 21:42:48 -0500
Message-ID: <49A752D2.50404@kernel.org>
Date: Thu, 26 Feb 2009 18:41:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: only set warm_reset_vector for NMI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

don't need to set that for INIT etc

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/smpboot.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -609,7 +609,7 @@ wakeup_secondary_cpu_via_nmi(int logical
 	return (send_status | accept_status);
 }
 
-int __devinit
+static int __devinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -816,11 +816,14 @@ do_rest:
 
 	atomic_set(&init_deasserted, 0);
 
-	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
+	if (apic->wakeup_secondary_cpu == wakeup_secondary_cpu_via_nmi) {
 
 		pr_debug("Setting warm reset code and vector.\n");
 
 		smpboot_setup_warm_reset_vector(start_ip);
+	}
+
+	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
 		/*
 		 * Be paranoid about clearing APIC errors.
 		*/
@@ -893,10 +896,12 @@ do_rest:
 	/* mark "stuck" area as not stuck */
 	*((volatile unsigned long *)trampoline_base) = 0;
 
-	/*
-	 * Cleanup possible dangling ends...
-	 */
-	smpboot_restore_warm_reset_vector();
+	if (apic->wakeup_secondary_cpu == wakeup_secondary_cpu_via_nmi) {
+		/*
+		 * Cleanup possible dangling ends...
+		 */
+		smpboot_restore_warm_reset_vector();
+	}
 
 	return boot_error;
 }
