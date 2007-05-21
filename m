Return-Path: <linux-kernel-owner+w=401wt.eu-S934631AbXEUUBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631AbXEUUBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936185AbXEUT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:59:11 -0400
Received: from www.osadl.org ([213.239.205.134]:57726 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935940AbXEUT7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:59:09 -0400
Subject: Re: [patch 43/69] i386: HPET, check if the counter works
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Andi Kleen <ak@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, guilherme@centralinf.com.br,
       johnstul@us.ibm.com
In-Reply-To: <20070521191740.534306000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
	 <20070521191740.534306000@sous-sol.org>
Content-Type: text/plain
Date: Mon, 21 May 2007 21:58:55 +0200
Message-Id: <1179777535.12708.37.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 12:16 -0700, Chris Wright wrote:
> plain text document attachment
> (i386-hpet-check-if-the-counter-works.patch)
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Some systems have a HPET which is not incrementing, which leads to a
> complete hang. Detect it during HPET setup.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> [chrisw: Why is this not upstream yet?]

Dunno. There is another one missing:

------------------------------->
Subject: NOHZ: Rate limit the local softirq pending warning output

The warning in the NOHZ code, which triggers when a CPU goes idle with
softirqs pending can fill up the logs quite quickly. Rate limit the
output until we found the root cause of that problem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6.21/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.21.orig/kernel/time/tick-sched.c
+++ linux-2.6.21/kernel/time/tick-sched.c
@@ -167,9 +167,15 @@ void tick_nohz_stop_sched_tick(void)
 		goto end;
 
 	cpu = smp_processor_id();
-	if (unlikely(local_softirq_pending()))
-		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-		       local_softirq_pending());
+	if (unlikely(local_softirq_pending())) {
+		static int ratelimit;
+
+		if (ratelimit < 10) {
+			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
+			       local_softirq_pending());
+			ratelimit++;
+		}
+	}
 
 	now = ktime_get();
 	/*


