Return-Path: <linux-kernel-owner+w=401wt.eu-S936559AbXHHXI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936559AbXHHXI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763029AbXHHXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:08:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58366 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763388AbXHHXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:08:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=Dy++aLrjvsrgtCwh4QgfzwCPhYqOKPYjPnF2I7USlxHZ1bSmJfSwDgLSvfu7AfKi2
	zgIOip7p29gSuaqFUQVpw==
Date: Wed, 8 Aug 2007 16:08:02 -0700
From: Aaron Durbin <adurbin@google.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de
Subject: [PATCH] x86_64: Avoid NMI Watchdog and/or long wait in setup_APIC_timer
Message-ID: <20070808230802.GA6290@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

---

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 900ff38..06797e2 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
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
+		while (trigger != hpet_readl(HPET_T0_CMP))
 			/* do nothing */ ;
 	} else {
 		int c1, c2;
