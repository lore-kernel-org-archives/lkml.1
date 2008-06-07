Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYFGBQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYFGBQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYFGBJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:16 -0400
Received: from sous-sol.org ([216.99.217.87]:42426 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760035AbYFGBJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:07 -0400
Message-Id: <20080607010615.614223788@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:41 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 26/50] x86: if we cannot calibrate the TSC, we panic.
Content-Disposition: inline; filename=x86-if-we-cannot-calibrate-the-tsc-we-panic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Rusty Russell <rusty@rustcorp.com.au>

upstream commit: 3c2047cd32b1a8c782d7efab72707e7daa251625

The current tsc_init() clears the TSC feature bit if the TSC khz
cannot be calculated, causing us to panic in
arch/x86/kernel/cpu/bugs.c check_config().  We should simply mark it
unstable.

Frankly, someone should take an axe to this code.  mark_tsc_unstable()
not only marks it unstable, but sets tsc_enabled to 0, which seems
redundant but is actually important here because means it won't be
used by sched_clock() either.  Perhaps a tristate enum "UNUSABLE,
UNSTABLE, OK" would be clearer, and separate mark_tsc_unstable() and
mark_tsc_broken() functions?

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/tsc_32.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -392,13 +392,15 @@ void __init tsc_init(void)
 	int cpu;
 
 	if (!cpu_has_tsc)
-		goto out_no_tsc;
+		return;
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
 
-	if (!cpu_khz)
-		goto out_no_tsc;
+	if (!cpu_khz) {
+		mark_tsc_unstable("could not calculate TSC khz");
+		return;
+	}
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
@@ -431,9 +433,4 @@ void __init tsc_init(void)
 		tsc_enabled = 1;
 
 	clocksource_register(&clocksource_tsc);
-
-	return;
-
-out_no_tsc:
-	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }

-- 
