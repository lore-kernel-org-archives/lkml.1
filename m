Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbXBALMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbXBALMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbXBALMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:12:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:53741 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751721AbXBALMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:12:33 -0500
X-Greylist: delayed 1247 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 06:12:33 EST
Message-Id: <20070201103753.357427000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:53 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 1/9] Fix HPET init race
Content-Disposition: inline; filename=fix_hpet_init_race
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a race in the initialization of HPET, which might result in a 
5 minute lockup on boot.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

Index: linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/apic.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/apic.c
@@ -764,10 +767,12 @@ static void setup_APIC_timer(unsigned in
 
 	/* wait for irq slice */
  	if (vxtime.hpet_address && hpet_use_timer) {
- 		int trigger = hpet_readl(HPET_T0_CMP);
- 		while (hpet_readl(HPET_COUNTER) >= trigger)
- 			/* do nothing */ ;
- 		while (hpet_readl(HPET_COUNTER) <  trigger)
+		int trigger;
+		do
+			trigger = hpet_readl(HPET_T0_CMP);
+		while (hpet_readl(HPET_COUNTER) >= trigger);
+
+		while (hpet_readl(HPET_COUNTER) <  trigger)
  			/* do nothing */ ;
  	} else {
 		int c1, c2;

--
