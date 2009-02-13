Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZBMCtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZBMCtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZBMCs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:48:58 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45493 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZBMCs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:48:57 -0500
Subject: [PATCH][RFC] Fix for LS21 + HPET = boot hang (since 2.6.24-rc1)
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1234254831.6323.10.camel@jstultz-laptop>
References: <1233974209.7141.7.camel@localhost.localdomain>
	 <1234254831.6323.10.camel@jstultz-laptop>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 18:48:53 -0800
Message-Id: <1234493333.7042.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Between 2.6.23 and 2.6.24-rc1 a change was made that broke IBM LS21
systems that had the HPET enabled in the BIOS, resulting in boot hangs
for x86_64. 

Specifically commit b8ce33590687888ebb900d09557b8807c4539022, which
merges the i386 and x86_64 HPET code.

Prior to this commit, when we setup the HPET timers in x86_64, we did
the following:

	hpet_writel(HPET_TN_ENABLE | HPET_TN_PERIODIC | HPET_TN_SETVAL |
                    HPET_TN_32BIT, HPET_T0_CFG);

However after the i386/x86_64 HPET merge, we do the following:

	cfg = hpet_readl(HPET_Tn_CFG(timer));
	cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
			HPET_TN_SETVAL | HPET_TN_32BIT;
	hpet_writel(cfg, HPET_Tn_CFG(timer));


However on LS21s with HPET enabled in the BIOS, the HPET_T0_CFG register
boots with Level triggered interrupts (HPET_TN_LEVEL) enabled. This
causes the periodic interrupt to be not so periodic, and that results in
the boot time hang I reported earlier in the delay calibration.


My fix: Always disable HPET_TN_LEVEL when setting up periodic mode.

Does that seem ok to folks? I've not been able to run this on an i386
system, so it could use some extra testing. So while it is a regression
fix, the bug has been around for awhile, so I'd probably queue it for
2.6.30.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 388254f..a00545f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -269,6 +269,8 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		now = hpet_readl(HPET_COUNTER);
 		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
+		/* Make sure we use edge triggered interrupts */
+		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));


