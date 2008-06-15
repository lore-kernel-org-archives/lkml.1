Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYFOAUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYFOAUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 20:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbYFOAU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 20:20:26 -0400
Received: from aun.it.uu.se ([130.238.12.36]:54959 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYFOAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 20:20:26 -0400
Date: Sun, 15 Jun 2008 02:19:56 +0200 (MEST)
Message-Id: <200806150019.m5F0JujB026872@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: tglx@linutronix.de
Subject: [PATCH 2.6.26-rc6] x86-32: fix boot failure on TSC-less processors
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 2.6.26-rc6 on my 486 DX/4 fails with a "BUG: Int 6"
(invalid opcode) and a kernel halt immediately after the
kernel has been uncompressed. The BUG shows EIP pointing
to an rdtsc instruction in native_read_tsc(), invoked from
native_sched_clock().

(This error occurs so early that not even the serial console
can capture it.)

A bisection showed that this bug first occurs in 2.6.26-rc3-git7,
via commit 9ccc906c97e34fd91dc6aaf5b69b52d824386910:

>x86: distangle user disabled TSC from unstable
>
>tsc_enabled is set to 0 from the command line switch "notsc" and from
>the mark_tsc_unstable code. Seperate those functionalities and replace
>tsc_enable with tsc_disable. This makes also the native_sched_clock()
>decision when to use TSC understandable.
>
>Preparatory patch to solve the sched_clock() issue on 32 bit.
>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

The core reason for this bug is that native_sched_clock() gets
called before tsc_init().

Before the commit above, tsc_32.c used a "tsc_enabled" variable
which defaulted to 0 == disabled, and which only got enabled late
in tsc_init(). Thus early calls to native_sched_clock() would skip
the TSC and use jiffies instead.

After the commit above, tsc_32.c uses a "tsc_disabled" variable
which defaults to 0, meaning that the TSC is Ok to use. Early calls
to native_sched_clock() now erroneously try to use the TSC on
!cpu_has_tsc processors, leading to invalid opcode exceptions.

My proposed fix is to initialise tsc_disabled to a "soft disabled"
state distinct from the hard disabled state set up by the "notsc"
kernel option. This fixes the native_sched_clock() problem. It also
allows tsc_init() to be simplified: instead of setting tsc_disabled = 1
on every error return, we just set tsc_disabled = 0 once when all
checks have succeeded.

I've verified that this lets my 486 boot again. I've also verified
that a Core2 machine still uses the TSC as clocksource after the patch.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 arch/x86/kernel/tsc_32.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -rupN linux-2.6.26-rc6/arch/x86/kernel/tsc_32.c linux-2.6.26-rc6.x86-unbreak-nontsc-cpus/arch/x86/kernel/tsc_32.c
--- linux-2.6.26-rc6/arch/x86/kernel/tsc_32.c	2008-06-15 01:08:30.000000000 +0200
+++ linux-2.6.26-rc6.x86-unbreak-nontsc-cpus/arch/x86/kernel/tsc_32.c	2008-06-15 01:10:15.000000000 +0200
@@ -14,7 +14,10 @@
 
 #include "mach_timer.h"
 
-static int tsc_disabled;
+/* native_sched_clock() is called before tsc_init(), so
+   we must start with the TSC soft disabled to prevent
+   erroneous rdtsc usage on !cpu_has_tsc processors */
+static int tsc_disabled = -1;
 
 /*
  * On some systems the TSC frequency does not
@@ -402,25 +405,20 @@ void __init tsc_init(void)
 {
 	int cpu;
 
-	if (!cpu_has_tsc || tsc_disabled) {
-		/* Disable the TSC in case of !cpu_has_tsc */
-		tsc_disabled = 1;
+	if (!cpu_has_tsc || tsc_disabled > 0)
 		return;
-	}
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
 
 	if (!cpu_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
-		/*
-		 * We need to disable the TSC completely in this case
-		 * to prevent sched_clock() from using it.
-		 */
-		tsc_disabled = 1;
 		return;
 	}
 
+	/* now allow native_sched_clock() to use rdtsc */
+	tsc_disabled = 0;
+
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);
