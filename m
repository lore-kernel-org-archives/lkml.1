Return-Path: <linux-kernel-owner+w=401wt.eu-S968459AbXFHHeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968459AbXFHHeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938345AbXFHHXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:25 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58311 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938328AbXFHHXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:23 -0400
Message-Id: <20070608072145.369075000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andi Kleen <ak@suse.de>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, guilherme@centralinf.com.br,
       johnstul@us.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 01/54] i386: HPET, check if the counter works
Content-Disposition: inline; filename=i386-hpet-check-if-the-counter-works.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

Some systems have a HPET which is not incrementing, which leads to a
complete hang. Detect it during HPET setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
[chrisw: again, this time with feeling ;-)  expected upstream soon]

 arch/i386/kernel/hpet.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- linux-2.6.21.4.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.21.4/arch/i386/kernel/hpet.c
@@ -226,7 +226,8 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 	uint64_t hpet_freq;
-	u64 tmp;
+	u64 tmp, start, now;
+	cycle_t t1;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -273,6 +274,27 @@ int __init hpet_enable(void)
 	/* Start the counter */
 	hpet_start_counter();
 
+	/* Verify whether hpet counter works */
+	t1 = read_hpet();
+	rdtscll(start);
+
+	/*
+	 * We don't know the TSC frequency yet, but waiting for
+	 * 200000 TSC cycles is safe:
+	 * 4 GHz == 50us
+	 * 1 GHz == 200us
+	 */
+	do {
+		rep_nop();
+		rdtscll(now);
+	} while ((now - start) < 200000UL);
+
+	if (t1 == read_hpet()) {
+		printk(KERN_WARNING
+		       "HPET counter not counting. HPET disabled\n");
+		goto out_nohpet;
+	}
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle

-- 
