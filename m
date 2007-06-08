Return-Path: <linux-kernel-owner+w=401wt.eu-S938898AbXFHIHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938898AbXFHIHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938663AbXFHHjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:39:19 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35532 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938754AbXFHHjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:39:16 -0400
Message-Id: <20070608072147.763475000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, tglx@linutronix.de,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 03/54] NOHZ: Rate limit the local softirq pending warning output
Content-Disposition: inline; filename=nohz-rate-limit-the-local-softirq-pending-warning-output.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

The warning in the NOHZ code, which triggers when a CPU goes idle with
softirqs pending can fill up the logs quite quickly.  Rate limit the output
until we found the root cause of that problem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 kernel/time/tick-sched.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.21.4.orig/kernel/time/tick-sched.c
+++ linux-2.6.21.4/kernel/time/tick-sched.c
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

-- 
