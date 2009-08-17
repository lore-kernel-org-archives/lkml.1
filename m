Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbZHQXly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbZHQXly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZHQXly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:41:54 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53073 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZHQXlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:41:53 -0400
Subject: [PATCH] make tsc=reliable override boot time stability checks
From: john stultz <johnstul@us.ibm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       akataria@vmware.com
In-Reply-To: <20090817162729.451613b4@nehalam>
References: <20090817090319.20979986@nehalam>
	 <1250531337.26171.12.camel@work-vm>	<20090817110127.40ee5c29@nehalam>
	 <1250532954.26171.35.camel@work-vm>	<20090817112704.2b4b2987@nehalam>
	 <1250543459.7212.41.camel@localhost.localdomain>
	 <1250545077.7212.49.camel@localhost.localdomain>
	 <20090817144546.7f1d6572@nehalam>
	 <1250547802.7212.82.camel@localhost.localdomain>
	 <20090817160212.029b3e42@nehalam>
	 <1250551074.7212.84.camel@localhost.localdomain>
	 <20090817162729.451613b4@nehalam>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 16:40:47 -0700
Message-Id: <1250552447.7212.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 16:27 -0700, Stephen Hemminger wrote:
> On Mon, 17 Aug 2009 16:17:54 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Mon, 2009-08-17 at 16:02 -0700, Stephen Hemminger wrote:
> > > This adds tsc, but makes it first?  it is reliable, but do I want
> > > to make it most important?
> > > 
> > > $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > tsc acpi_pm
> > 
> > 
> > Well, if you're overriding the system saying that its safe, then sure,
> > its better then anything else, why wouldn't we?
> > 
> 
> That's acceptable, maybe add change to Documentation/kernel-parameters.txt
> 
> 	tsc=		Disable clocksource-must-verify flag for TSC.
> 			Format: <string>
> 			[x86] reliable: mark tsc clocksource as reliable and
>                         makes tsc the default clocksource; this
> 			disables clocksource verification at runtime.
> 			Used to enable high-resolution timer mode on older
> 			hardware, and in virtualized environment.
> 

Sounds good. Thanks so much for the bug report and testing!


This patch makes the tsc=reliable option disable the boot time stability
checks. Currently the option only disables the runtime watchdog checks.
This change allows folks who want to override the boot time TSC
stability checks and use the TSC when the system would otherwise
disqualify it.

There still are some situations that the TSC will be disqualified, such
as cpufreq scaling. But these are situations where the box will hang if
allowed.

Patch also includes a fix for an issue found by Thomas Gleixner, where
the TSC disqualification message wouldn't be printed after a call to
unsynchronized_tsc().

I'd recommend queuing this for 2.6.32, since it probably should get more
testing then we have time for in 2.6.31.

thanks
-john


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7936b80..4c6b415 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2484,12 +2484,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format:
 			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>
 
-	tsc=		Disable clocksource-must-verify flag for TSC.
+	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
-			disables clocksource verification at runtime.
-			Used to enable high-resolution timer mode on older
-			hardware, and in virtualized environment.
+			disables clocksource verification at runtime, as well
+			as the stability checks done at bootup.	Used to enable
+			high-resolution timer mode on older hardware, and in
+			virtualized environment.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 71f4368..648fb26 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -825,6 +825,9 @@ __cpuinit int unsynchronized_tsc(void)
 
 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		return 0;
+
+	if (tsc_clocksource_reliable)
+		return 0;
 	/*
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
@@ -832,10 +835,10 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			return 1;
 	}
 
-	return tsc_unstable;
+	return 0;
 }
 
 static void __init init_tsc_clocksource(void)



