Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYLLFZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYLLFZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbYLLFZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:25:09 -0500
Received: from kroah.org ([198.145.64.141]:36991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751955AbYLLFZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:25:07 -0500
Date: Thu, 11 Dec 2008 21:21:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Jake Edge <jake@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Milton Miller <miltonm@bga.com>
Subject: [patch 84/83] powerpc: Use cpu_thread_in_core in smp_init for
	of_spin_map
Message-ID: <20081212052123.GB9024@kroah.com>
References: <20081211191014.GA5759@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

commit 6a75a6b8e85e92cc774d42a4e113c76c30b5a539 upstream.

We used to assume that even numbered threads were the primary
threads, ie those that would be listed and started as a cpu from
open firmware.  Replace a left over is even (% 2) check with a check
for it being a primary thread and update the comments.

Tested with a debug print on pseries, identical code found for cell.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/cell/smp.c    |   10 +++-------
 arch/powerpc/platforms/pseries/smp.c |   13 ++++---------
 2 files changed, 7 insertions(+), 16 deletions(-)

--- a/arch/powerpc/platforms/cell/smp.c
+++ b/arch/powerpc/platforms/cell/smp.c
@@ -54,8 +54,8 @@
 #endif
 
 /*
- * The primary thread of each non-boot processor is recorded here before
- * smp init.
+ * The Primary thread of each non-boot processor was started from the OF client
+ * interface by prom_hold_cpus and is spinning on secondary_hold_spinloop.
  */
 static cpumask_t of_spin_map;
 
@@ -208,11 +208,7 @@ void __init smp_init_cell(void)
 	/* Mark threads which are still spinning in hold loops. */
 	if (cpu_has_feature(CPU_FTR_SMT)) {
 		for_each_present_cpu(i) {
-			if (i % 2 == 0)
-				/*
-				 * Even-numbered logical cpus correspond to
-				 * primary threads.
-				 */
+			if (cpu_thread_in_core(i) == 0)
 				cpu_set(i, of_spin_map);
 		}
 	} else {
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -52,8 +52,8 @@
 
 
 /*
- * The primary thread of each non-boot processor is recorded here before
- * smp init.
+ * The Primary thread of each non-boot processor was started from the OF client
+ * interface by prom_hold_cpus and is spinning on secondary_hold_spinloop.
  */
 static cpumask_t of_spin_map;
 
@@ -191,8 +191,7 @@ static void __devinit smp_pSeries_kick_c
 static int smp_pSeries_cpu_bootable(unsigned int nr)
 {
 	/* Special case - we inhibit secondary thread startup
-	 * during boot if the user requests it.  Odd-numbered
-	 * cpus are assumed to be secondary threads.
+	 * during boot if the user requests it.
 	 */
 	if (system_state < SYSTEM_RUNNING &&
 	    cpu_has_feature(CPU_FTR_SMT) &&
@@ -229,11 +228,7 @@ static void __init smp_init_pseries(void
 	/* Mark threads which are still spinning in hold loops. */
 	if (cpu_has_feature(CPU_FTR_SMT)) {
 		for_each_present_cpu(i) { 
-			if (i % 2 == 0)
-				/*
-				 * Even-numbered logical cpus correspond to
-				 * primary threads.
-				 */
+			if (cpu_thread_in_core(i) == 0)
 				cpu_set(i, of_spin_map);
 		}
 	} else {
