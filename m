Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYICVjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYICVjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYICViD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:38:03 -0400
Received: from www.tglx.de ([62.245.132.106]:41443 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449AbYICVh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:37:59 -0400
Message-Id: <20080903212753.398727327@linutronix.de>
References: <20080903212735.713411776@linutronix.de>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 21:37:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Dmitry Nezhevenko <dion@inhex.net>
Subject: [patch 6/6] HPET: make minimum reprogramming delta useful
Content-Disposition: inline; filename=hpet-make-minimum-delta-useful.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The minimum reprogramming delta was hardcoded in HPET ticks,
which is stupid as it does not work with faster running HPETs.
The C1E idle patches made this prominent on AMD/RS690 chipsets,
where the HPET runs with 25MHz. Set it to 5us which seems to be
a reasonable value and fixes the problems on the bug reporters
machines. We have a further sanity check now in the clock events,
which increases the delta when it is not sufficient.

Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Tested-by: Dmitry Nezhevenko <dion@inhex.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -210,8 +210,8 @@ static void hpet_legacy_clockevent_regis
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
-	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
-							   &hpet_clockevent);
+	/* 5 usec minimum reprogramming delta. */
+	hpet_clockevent.min_delta_ns = 5000;
 
 	/*
 	 * Start hpet with the boot cpu mask and make it

-- 

