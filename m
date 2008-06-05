Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYFEJUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYFEJUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFEJUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:20:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46444 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYFEJUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:20:20 -0400
Date: Thu, 5 Jun 2008 11:19:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
Message-ID: <20080605091949.GA2307@elte.hu>
References: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl> <20080531101832.GA15170@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531101832.GA15170@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Maciej,

-tip testing found an IO-APIC related hang, and i bisected it down to 
the problem below. What do you think about my solution? Another option 
would be to add the lapic as a clockevent device in the failure path. 
(since we know the NMI watchdog wont work)

	Ingo

------------>
Subject: x86, io-apic: fix nmi_watchdog=1 bootup hang
From: Ingo Molnar <mingo@elte.hu>

nmi_watchdog=1 hangs on 64-bit:

[    0.250000] Detected 12.564 MHz APIC timer.
[    0.254178] APIC timer registered as dummy, due to nmi_watchdog=1!
[    0.260366] Testing NMI watchdog ... <4>WARNING: CPU#0: NMI appears to be stuck (0->0)!
[    ...     ]
[    0.470003] calling  genl_init+0x0/0xd0
[  hard hang ]

bisected it down to:

 git-bisect start
 git-bisect good 1beee8dc8cf58e3f605bd7b34d7a39939be7d8d2
 git-bisect bad 11582ece0aaa2d0f94f345c08a4ab9997078a083
 git-bisect bad 5479c623bb44089844022c03d4c0eb16d5b7a15f
 git-bisect bad cfb4c7fabeb499e1c29f9d1878968e37a938e28a
 git-bisect good 246dd412d31e4f5de1d43aa6422a325b785f36e4
 git-bisect bad 3f8237eaff7dc1e35fa791dae095574fd974e671
 git-bisect good 90e23b13ab849e2a11f00c655eb3a2011b4623be
 git-bisect bad 833526a34eeefc117df3191a594c3c3a4f15a9ac
 git-bisect good 791b93d3dfaf16c23e978bec0cc0a3dd9d855d63
 git-bisect bad 65767c64068f2c93e56a1accfed5c78230ac12d7
 git-bisect bad 2abc5c05dd82c188e3bdf6641a274f013348d14b
 git-bisect bad 317e1f2597ffb4d4db940577bbe56dc6e881ef07

| 317e1f2597ffb4d4db940577bbe56dc6e881ef07 is first bad commit
| commit 317e1f2597ffb4d4db940577bbe56dc6e881ef07
| Author: Maciej W. Rozycki <macro@linux-mips.org>
| Date:   Wed May 21 22:10:22 2008 +0100
|     x86: I/O APIC: clean up the 8259A on a NMI watchdog failure

the problem is that in the dummy-lapic branch we rely on the i8259A
but if the NMI watchdog fails we turn off IRQ 0 - which doesnt work
too well ;-)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic_32.c |    6 ++++--
 arch/x86/kernel/apic_64.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux/arch/x86/kernel/apic_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic_32.c
+++ linux/arch/x86/kernel/apic_32.c
@@ -547,11 +547,13 @@ void __init setup_boot_APIC_clock(void)
 		 * PIT/HPET going.  Otherwise register lapic as a dummy
 		 * device.
 		 */
-		if (nmi_watchdog != NMI_IO_APIC)
+		if (nmi_watchdog != NMI_IO_APIC) {
 			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
-		else
+		} else {
 			printk(KERN_WARNING "APIC timer registered as dummy,"
 			       " due to nmi_watchdog=1!\n");
+			timer_through_8259 = 1;
+		}
 	}
 
 	/* Setup the lapic or request the broadcast */
Index: linux/arch/x86/kernel/apic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/apic_64.c
+++ linux/arch/x86/kernel/apic_64.c
@@ -413,11 +413,13 @@ void __init setup_boot_APIC_clock(void)
 	 * PIT/HPET going.  Otherwise register lapic as a dummy
 	 * device.
 	 */
-	if (nmi_watchdog != NMI_IO_APIC)
+	if (nmi_watchdog != NMI_IO_APIC) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
-	else
+	} else {
 		printk(KERN_WARNING "APIC timer registered as dummy,"
 		       " due to nmi_watchdog=1!\n");
+		timer_through_8259 = 1;
+	}
 
 	setup_APIC_timer();
 }

