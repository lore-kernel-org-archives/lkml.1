Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXBLHi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXBLHi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964778AbXBLHid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:49637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095AbXBLHiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:18 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Jack Steiner <steiner@sgi.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [29/39] x86_64: - Ignore long SMI interrupts in clock calibration code - update 1
Message-Id: <20070212073817.452CC13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jack Steiner <steiner@sgi.com>
Add failsafe mechanism to HPET/TSC clock calibration.
	
	Signed-off-by: Jack Steiner <steiner@sgi.com>

Updated to include failsafe mechanism & additional community feedback.
Patch built on latest 2.6.20-rc4-mm1 tree.




Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/time.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -657,6 +657,7 @@ core_initcall(cpufreq_tsc);
 
 #define TICK_COUNT 100000000
 #define TICK_MIN   5000
+#define MAX_READ_RETRIES 5
 
 /*
  * Some platforms take periodic SMI interrupts with 5ms duration. Make sure none
@@ -664,13 +665,17 @@ core_initcall(cpufreq_tsc);
  */
 static void __init read_hpet_tsc(int *hpet, int *tsc)
 {
-	int tsc1, tsc2, hpet1;
+	int tsc1, tsc2, hpet1, retries = 0;
+	static int msg;
 
 	do {
 		tsc1 = get_cycles_sync();
 		hpet1 = hpet_readl(HPET_COUNTER);
 		tsc2 = get_cycles_sync();
-	} while (tsc2 - tsc1 > TICK_MIN);
+	} while (tsc2 - tsc1 > TICK_MIN && retries++ < MAX_READ_RETRIES);
+	if (retries >= MAX_READ_RETRIES && !msg++)
+		printk(KERN_WARNING
+		       "hpet.c: exceeded max retries to read HPET & TSC\n");
 	*hpet = hpet1;
 	*tsc = tsc2;
 }
