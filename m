Return-Path: <linux-kernel-owner+w=401wt.eu-S936168AbXHHXSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936168AbXHHXSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbXHHXSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:18:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760731AbXHHXSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:18:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=s1ECOEldzvRU67+O00xK7aKcDHjrMvCIKBW76Jb6pfjP6/aDunk1kuZCha5nbIIDY
	Bgluof1SH8/3ALNCfkeSA==
Date: Wed, 8 Aug 2007 16:17:19 -0700
From: Aaron Durbin <adurbin@google.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@osdl.org
Subject: [PATCH] x86_64: Avoid NMI Watchdog and/or long wait in setup_APIC_timer
Message-ID: <20070808231719.GA7101@google.com>
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

The last patch had a typo in the diff which really would cause the
problem state above. Sorry.

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
+		while (trigger == hpet_readl(HPET_T0_CMP))
 			/* do nothing */ ;
 	} else {
 		int c1, c2;

