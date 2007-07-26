Return-Path: <linux-kernel-owner+w=401wt.eu-S936846AbXGZU7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936846AbXGZU7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933772AbXGZU64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:58:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59674 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762416AbXGZU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:58:55 -0400
Date: Thu, 26 Jul 2007 15:58:47 -0500
From: Robin Holt <holt@sgi.com>
To: Andi Kleen <ak@suse.de>, Jiri Bohac <jbohac@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 1/9] Fix HPET init race
Message-ID: <20070726205847.GA23109@lnx-holt.americas.sgi.com>
References: <20070201095952.589234000@jet.suse.cz> <20070206164459.GA7271@dwarf.suse.cz> <20070206161256.43fd11de.akpm@linux-foundation.org> <200702101331.02131.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702101331.02131.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have had four seperate system lockups attributable to this exact problem
in two days of testing.  Instead of trying to handle all the weird end
cases and wrap, how about changing it to look for exactly what we appear
to want.

The following patch removes a couple races in setup_APIC_timer.  One occurs
when the HPET advances the COUNTER past the T0_CMP value between the time
the T0_CMP was originally read and when COUNTER is read.  This results in
a delay waiting for the counter to wrap.  The other results from the counter
wrapping.

This change takes a snapshot of T0_CMP at the beginning of the loop and
simply loops until T0_CMP has changed (a tick has happened).

Signed-off-by: Robin Holt <holt@sgi.com>


Index: apic_fixes/arch/x86_64/kernel/apic.c
===================================================================
--- apic_fixes.orig/arch/x86_64/kernel/apic.c	2007-07-26 15:45:17.000000000 -0500
+++ apic_fixes/arch/x86_64/kernel/apic.c	2007-07-26 15:46:15.000000000 -0500
@@ -791,10 +791,8 @@ static void setup_APIC_timer(unsigned in
 
 	/* wait for irq slice */
 	if (hpet_address && hpet_use_timer) {
-		int trigger = hpet_readl(HPET_T0_CMP);
-		while (hpet_readl(HPET_COUNTER) >= trigger)
-			/* do nothing */ ;
-		while (hpet_readl(HPET_COUNTER) <  trigger)
+		u32 trigger = hpet_readl(HPET_T0_CMP);
+		while (hpet_readl(HPET_T0_CMP) == trigger)
 			/* do nothing */ ;
 	} else {
 		int c1, c2;
