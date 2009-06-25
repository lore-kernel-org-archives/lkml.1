Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZFYXpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZFYXpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 19:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZFYXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 19:44:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:59494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbZFYXow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 19:44:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,293,1243839600"; 
   d="scan'208";a="702617539"
Date: Thu, 25 Jun 2009 16:44:31 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Subject: [PATCH] x86: tsc based udelay should have rdtsc_barrier
Message-ID: <20090625234431.GC29401@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


delay_tsc needs rdtsc_barrier to provide proper delay.

Output from a test driver using hpet to cross check delay
provided by udelay().

Before:
[   86.794363] Expected delay 5us actual 4679ns
[   87.154362] Expected delay 5us actual 698ns
[   87.514162] Expected delay 5us actual 4539ns
[   88.653716] Expected delay 5us actual 4539ns
[   94.664106] Expected delay 10us actual 9638ns
[   95.049351] Expected delay 10us actual 10126ns
[   95.416110] Expected delay 10us actual 9568ns
[   95.799216] Expected delay 10us actual 9638ns
[  103.624104] Expected delay 10us actual 9707ns
[  104.020619] Expected delay 10us actual 768ns
[  104.419951] Expected delay 10us actual 9707ns

After:
[   50.983320] Expected delay 5us actual 5587ns
[   51.261807] Expected delay 5us actual 5587ns
[   51.565715] Expected delay 5us actual 5657ns
[   51.861171] Expected delay 5us actual 5587ns
[   52.164704] Expected delay 5us actual 5726ns
[   52.487457] Expected delay 5us actual 5657ns
[   52.789338] Expected delay 5us actual 5726ns
[   57.119680] Expected delay 10us actual 10755ns
[   57.893997] Expected delay 10us actual 10615ns
[   58.261287] Expected delay 10us actual 10755ns
[   58.620505] Expected delay 10us actual 10825ns
[   58.941035] Expected delay 10us actual 10755ns
[   59.320903] Expected delay 10us actual 10615ns
[   61.306311] Expected delay 10us actual 10755ns
[   61.520542] Expected delay 10us actual 10615ns


Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/lib/delay.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index f456860..ff485d3 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -55,8 +55,10 @@ static void delay_tsc(unsigned long loops)
 
 	preempt_disable();
 	cpu = smp_processor_id();
+	rdtsc_barrier();
 	rdtscl(bclock);
 	for (;;) {
+		rdtsc_barrier();
 		rdtscl(now);
 		if ((now - bclock) >= loops)
 			break;
@@ -78,6 +80,7 @@ static void delay_tsc(unsigned long loops)
 		if (unlikely(cpu != smp_processor_id())) {
 			loops -= (now - bclock);
 			cpu = smp_processor_id();
+			rdtsc_barrier();
 			rdtscl(bclock);
 		}
 	}
-- 
1.6.0.6

