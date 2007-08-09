Return-Path: <linux-kernel-owner+w=401wt.eu-S964984AbXHIMq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984AbXHIMq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939658AbXHIMlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:34971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939652AbXHIMli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:38 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: adurbin@google.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/12] x86_64: Avoid NMI Watchdog and/or long wait in setup_APIC_timer
Message-Id: <20070809124137.0FE4D14F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Aaron Durbin <adurbin@google.com>
In setup_APIC_timer with the HPET in use, a condition can arise while
waiting for the next irq slice to expire on the HPET which will either
cause an NMI watchdog to fire or a 3 minute busy loop if the NMI
watchdog is disabled.

The HPET comparator and the counter keep incrementing during its normal
operation. When a comparison event fires the comparator will increment
by the designated period. If the HPET trigger occurs right after
the 'int trigger = hpet_readl(HPET_T0_CMP);' line, we will will spin
for up to 3 minutes (with a clock of 25MHz) waiting for the HPET
counter to wrap around. However, when the NMI watchdog is enabled the
NMI watchdog will detect a lockup and reboot the machine. This
scenario can be exasperated by the presence of an SMI which will
increase the window of opportunity for the condition to occur.

The fix is to wait for the compartor to change which signals the
end of the tick slice.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/apic.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -791,10 +791,12 @@ static void setup_APIC_timer(unsigned in
 
 	/* wait for irq slice */
 	if (hpet_address && hpet_use_timer) {
+		/*
+		 * Wait for the comparator value to change which signals that
+		 * the tick slice has expired.
+		 */
 		int trigger = hpet_readl(HPET_T0_CMP);
-		while (hpet_readl(HPET_COUNTER) >= trigger)
-			/* do nothing */ ;
-		while (hpet_readl(HPET_COUNTER) <  trigger)
+		while (trigger == hpet_readl(HPET_T0_CMP))
 			/* do nothing */ ;
 	} else {
 		int c1, c2;
