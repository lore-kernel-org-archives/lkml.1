Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYGMLhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYGMLhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 07:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYGMLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 07:37:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:10732 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYGMLhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 07:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QMI07J1Up/opKixbyLVtuJ4NFYeR5xx3gamz/8Ax4q2rkkWqJ9SYS85N2Q2cyG4Tav
         eWOoVvG8fVsIr/oAbIh4t0ZEwoS1uFImKRiT+cB/81DU1B1xT7BkUbS/Z00JadB57NlN
         1BUd0WGAxDksG79YClOu0J0hRLTNUV5P1aAuc=
Date: Sun, 13 Jul 2008 15:37:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] lapic calibration results fix
Message-ID: <20080713113734.GB7459@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Maciej,

it seems I found a bit strange code snippet in apic_32.c:setup_boot_APIC_clock.
We set local_apic_timer_verify_ok = 1 before checking the results. I think
the following patch make sense. Please take a look on.

---
We set lapic flag that clocksource calibration is
fine too early. Fix it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-07-13 15:25:20.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-07-13 15:31:03.000000000 +0400
@@ -489,8 +489,6 @@ void __init setup_boot_APIC_clock(void)
 		    calibration_result / (1000000 / HZ),
 		    calibration_result % (1000000 / HZ));
 
-	local_apic_timer_verify_ok = 1;
-
 	/*
 	 * Do a sanity check on the APIC calibration result
 	 */
@@ -504,6 +502,8 @@ void __init setup_boot_APIC_clock(void)
 		return;
 	}
 
+	local_apic_timer_verify_ok = 1;
+
 	/* We trust the pm timer based calibration */
 	if (!pm_referenced) {
 		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
