Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbXCYLPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbXCYLPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXCYLPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:15:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXCYLPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:15:21 -0400
Date: Sun, 25 Mar 2007 13:14:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, john stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [patch] ntp: avoid integer overflow in do_adjtimex()
Message-ID: <20070325111420.GA16988@elte.hu>
References: <1174696834.5690.14.camel@localhost.localdomain> <Pine.LNX.4.64.0703240153220.14457@scrub.home> <20070325010903.a0e6e624.akpm@linux-foundation.org> <1174820872.10840.494.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174820872.10840.494.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Here you go. It's ugly, but it should do the trick for now.
> 
> 	tglx

here's your patch with proper metadata:

--------------------->
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] ntp: avoid integer overflow in do_adjtimex()

John Stultz traced back ntpd problems to the following issue: 
do_adjtimex() [used by ntpd] can overflow if there's a too long delay 
between timer interrupts - as it can happen on NO_HZ. Expand the 
time_adjust calculation/division from 32 bits to 64 bits.

Found-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -196,7 +196,7 @@ void __attribute__ ((weak)) notify_arch_
  */
 int do_adjtimex(struct timex *txc)
 {
-	long mtemp, save_adjust;
+	long mtemp, save_adjust, rem;
 	s64 freq_adj, temp64;
 	int result;
 
@@ -314,7 +314,9 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    do_div(time_offset, NTP_INTERVAL_FREQ);
+		    time_offset = div_long_long_rem_signed(time_offset,
+							   NTP_INTERVAL_FREQ,
+							   &rem);
 		    time_offset <<= SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */

