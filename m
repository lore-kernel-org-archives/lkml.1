Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYIRTNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYIRTNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYIRTMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:12:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:16825 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYIRTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:12:53 -0400
X-BigFish: VPS-3(zz4015Mzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7EO0U-02-X1M-01
Date: Thu, 18 Sep 2008 21:12:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: c1e_idle: don't mark TSC unstable if CPU has
	invariant TSC
Message-ID: <20080918191210.GD23287@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Sep 2008 19:12:37.0362 (UTC) FILETIME=[83477D20:01C919C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. otherwise TSC is marked unstable on AMD family 0x10 and 0x11 CPUs.
This would be wrong because for those CPUs "invariant TSC" means:

   "The TSC counts at the same rate in all P-states, all C states, S0,
   or S1"

(See "Processor BIOS and Kernel Developer's Guides" for those CPUs.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/process.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Please apply for 2.6.27.

Thanks,


Andreas


diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7fc4d5b..ba6b16b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -265,7 +265,8 @@ static void c1e_idle(void)
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			c1e_detected = 1;
-			mark_tsc_unstable("TSC halt in C1E");
+			if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+				mark_tsc_unstable("TSC halt in C1E");
 			printk(KERN_INFO "System has C1E enabled\n");
 		}
 	}
-- 
1.6.0.1



