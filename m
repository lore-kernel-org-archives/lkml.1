Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYEHRbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYEHRbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764361AbYEHRbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:31:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:35777 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763127AbYEHRbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:31:32 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19pR+RbRGZp0zGIPwtQhxit/uf0G0uxk5zh/WuKf9
	Os7x8/gahdjGmf
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion
	from 2.6.24)
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Knoblauch <spamtrap@knobisoft.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br
In-Reply-To: <alpine.LFD.1.10.0805081609080.3318@apollo.tec.linutronix.de>
References: <295530.5900.qm@web32602.mail.mud.yahoo.com>
	 <alpine.LFD.1.10.0805081609080.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 08 May 2008 19:31:28 +0200
Message-Id: <1210267888.4744.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 16:13 +0200, Thomas Gleixner wrote:
> On Thu, 8 May 2008, Martin Knoblauch wrote:
> > on two different systems running 2.6.25.2:
> > 
> > ibm x3650(2xDualCore)
> > -------------------------------------
> > [root@lpsdm60 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > tsc hpet acpi_pm jiffies
> > [root@lpsdm60 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > tsc
> > 
> > HP Proliant DL-380G4 (2xSingleCore)
> > ------------------------------------------------------------
> > [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > tsc hpet acpi_pm jiffies
> > [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > tsc
> > 
> > and on the DL380G4 running 2.6.24:
> > ---------------------------------------------------------
> > [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > hpet acpi_pm jiffies tsc
> > [root@lpsdm52 ~]# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > hpet
> 
> So on 2.6.24 the TSC is declared unstable at some point and 2.6.25
> thinks it works fine. Is this the same kernel config (aside of the 24/25 fuzz) ?

I had a problem with my P4's tsc being declared unstable after S2R.  I
carry this patchlet (it's in mainline) in my 2.6.24 kernels to keep the
TSC operational.  (browsing, dunno if it's the same problem, but it
might be..)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9125efe..05d8f25 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -129,24 +129,24 @@ void __cpuinit check_tsc_sync_source(int cpu)
 	while (atomic_read(&stop_count) != cpus-1)
 		cpu_relax();
 
-	/*
-	 * Reset it - just in case we boot another CPU later:
-	 */
-	atomic_set(&start_count, 0);
-
 	if (nr_warps) {
 		printk("\n");
 		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
 				    " turning off TSC clock.\n", max_warp);
 		mark_tsc_unstable("check_tsc_sync_source failed");
-		nr_warps = 0;
-		max_warp = 0;
-		last_tsc = 0;
 	} else {
 		printk(" passed.\n");
 	}
 
 	/*
+	 * Reset it - just in case we boot another CPU later:
+	 */
+	atomic_set(&start_count, 0);
+	nr_warps = 0;
+	max_warp = 0;
+	last_tsc = 0;
+
+	/*
 	 * Let the target continue with the bootup:
 	 */
 	atomic_inc(&stop_count);


