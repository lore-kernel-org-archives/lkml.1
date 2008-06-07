Return-Path: <linux-kernel-owner+w=401wt.eu-S1764587AbYFGB0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764587AbYFGB0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760663AbYFGBJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:49 -0400
Received: from sous-sol.org ([216.99.217.87]:42565 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760342AbYFGBJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:31 -0400
Message-Id: <20080607010616.336845527@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:42 -0700
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
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 27/50] x86: distangle user disabled TSC from unstable
Content-Disposition: inline; filename=x86-distangle-user-disabled-tsc-from-unstable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

upstream commit: 9ccc906c97e34fd91dc6aaf5b69b52d824386910

tsc_enabled is set to 0 from the command line switch "notsc" and from
the mark_tsc_unstable code. Seperate those functionalities and replace
tsc_enable with tsc_disable. This makes also the native_sched_clock()
decision when to use TSC understandable.

Preparatory patch to solve the sched_clock() issue on 32 bit.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/tsc_32.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -14,7 +14,7 @@
 
 #include "mach_timer.h"
 
-static int tsc_enabled;
+static int tsc_disabled;
 
 /*
  * On some systems the TSC frequency does not
@@ -28,8 +28,8 @@ EXPORT_SYMBOL_GPL(tsc_khz);
 static int __init tsc_setup(char *str)
 {
 	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-				"cannot disable TSC completely.\n");
-	mark_tsc_unstable("user disabled TSC");
+	       "cannot disable TSC completely.\n");
+	tsc_disabled = 1;
 	return 1;
 }
 #else
@@ -121,7 +121,7 @@ unsigned long long native_sched_clock(vo
 	 *   very important for it to be as fast as the platform
 	 *   can achive it. )
 	 */
-	if (unlikely(!tsc_enabled && !tsc_unstable))
+	if (unlikely(tsc_disabled))
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
@@ -310,7 +310,6 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
-		tsc_enabled = 0;
 		printk("Marking TSC unstable due to: %s.\n", reason);
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
@@ -324,7 +323,7 @@ EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
-		       d->ident);
+	       d->ident);
 	tsc_unstable = 1;
 	return 0;
 }
@@ -391,8 +390,11 @@ void __init tsc_init(void)
 {
 	int cpu;
 
-	if (!cpu_has_tsc)
+	if (!cpu_has_tsc || tsc_disabled) {
+		/* Disable the TSC in case of !cpu_has_tsc */
+		tsc_disabled = 1;
 		return;
+	}
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
@@ -429,8 +431,6 @@ void __init tsc_init(void)
 	if (check_tsc_unstable()) {
 		clocksource_tsc.rating = 0;
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-	} else
-		tsc_enabled = 1;
-
+	}
 	clocksource_register(&clocksource_tsc);
 }

-- 
