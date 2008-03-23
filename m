Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbYCWTJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbYCWTJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 15:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYCWTJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 15:09:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbYCWTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 15:09:25 -0400
Subject: Re: 2.6.25-rc: complete lockup on boot/start of X (bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1206299168.6437.119.camel@lappy>
References: <20080302185935.GA6100@joi> <1204485071.6240.56.camel@lappy>
	 <20080302194748.GA6005@joi> <1204487917.6240.64.camel@lappy>
	 <20080323154416.GA6817@joi> <1206287670.6437.113.camel@lappy>
	 <20080323184427.GA6691@joi>  <1206299168.6437.119.camel@lappy>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 20:09:01 +0100
Message-Id: <1206299341.6437.121.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 20:06 +0100, Peter Zijlstra wrote:
> On Sun, 2008-03-23 at 19:46 +0100, Marcin Slusarz wrote:
> 
> > 4 different lockups:
> > http://alan.umcs.lublin.pl/~mslusarz/kernel/2008.03.23-lockup/ 
> 
> Brilliant, these are extremely helpful.
> 
> What seems to happen is a classic xtime deadlock, doing a xtime
> seq_readlock while holding a seq_writelock.
> 
> Only need to figure out _why_ that is happening....

Does your machine boot with the following patch applied:


diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 671af61..e300889 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -190,9 +190,6 @@ static void change_clocksource(void)
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
-
-	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-	       clock->name);
 }
 #else
 static inline void change_clocksource(void) { }


