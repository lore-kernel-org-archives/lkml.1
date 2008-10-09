Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYJIVSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYJIVSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbYJIVSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:18:16 -0400
Received: from kara.rubysoft.com ([64.34.171.174]:56987 "EHLO
	kara.rubysoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbYJIVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:18:15 -0400
Date: Thu, 9 Oct 2008 15:18:11 -0600 (MDT)
From: Jeff Hansen <x@jeffhansen.com>
X-X-Sender: ninkid@ren
Reply-To: Jeff Hansen <x@jeffhansen.com>
To: Chris Snook <csnook@redhat.com>
cc: Alok kataria <alokkataria1@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, akataria@vmware.com
Subject: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <48EE71A9.2010907@redhat.com>
Message-ID: <Pine.LNX.4.64.0810091517200.28336@ren>
References: <Pine.LNX.4.64.0810071640110.25661@ren>  <48ED1728.5060708@redhat.com>
 <Pine.LNX.4.64.0810081542300.14815@ren>  <48ED2A89.3000902@redhat.com>
 <Pine.LNX.4.64.0810081554380.14982@ren>  <alpine.LFD.2.00.0810090910510.3237@apollo>
  <48EE4FC4.7070902@redhat.com>  <alpine.LFD.2.00.0810092118100.3271@apollo>
  <Pine.LNX.4.64.0810091344250.24851@ren>  <alpine.LFD.2.00.0810092152410.3271@apollo>
 <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>
 <48EE71A9.2010907@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[X86] Add tsc=stable option for marking TSC as stable

This enables legacy hardware or VMs without HPET, LAPIC, or ACPI
timers to enter high-resolution timer mode.

Signed-off-by: Jeff Hansen <jhansen@cardaccess-inc.com>
---
  Documentation/kernel-parameters.txt |    4 ++++
  arch/x86/kernel/tsc_32.c            |   12 +++++++++++-
  arch/x86/kernel/tsc_64.c            |    9 +++++++++
  3 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9611505..8488074 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2084,6 +2084,10 @@ and is between 256 and 4096 characters. It is defined in the file
  			Format:
  			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>

+	tsc=		[X86-32,X86-64]
+			tsc=stable: Mark TSC clocksource as stable, enabling
+			        high-resolution timer mode on older hardware.
+
  	turbografx.map[2|3]=	[HW,JOY]
  			TurboGraFX parallel port interface
  			Format:
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 65b7063..f6e8f71 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -49,6 +49,17 @@ static int __init tsc_setup(char *str)

  __setup("notsc", tsc_setup);

+static struct clocksource clocksource_tsc;
+
+static int __init tscx_setup(char *str)
+{
+	if (!strcmp(str, "stable"))
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+	return 1;
+}
+
+__setup("tsc=", tscx_setup);
+
  /*
   * code to mark and check if the TSC is unstable
   * due to cpufreq or due to unsynced TSCs
@@ -287,7 +298,6 @@ core_initcall(cpufreq_tsc);
  /* clock source code */

  static unsigned long current_tsc_khz;
-static struct clocksource clocksource_tsc;

  /*
   * We compare the TSC to the cycle_last value in the clocksource
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 1784b80..4a3e555 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -291,6 +291,15 @@ __setup("notsc", notsc_setup);

  static struct clocksource clocksource_tsc;

+static int __init tscx_setup(char *str)
+{
+	if (!strcmp(str, "stable"))
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+	return 1;
+}
+
+__setup("tsc=", tscx_setup);
+
  /*
   * We compare the TSC to the cycle_last value in the clocksource
   * structure to avoid a nasty time-warp. This can be observed in a
-- 
1.5.6.4

---------------------------------------------------
"If someone's gotta do it, it might as well be me."

On Thu, 9 Oct 2008, Chris Snook wrote:

> Alok kataria wrote:
>>  On Thu, Oct 9, 2008 at 12:53 PM, Thomas Gleixner <tglx@linutronix.de>
>>  wrote:
>> >  On Thu, 9 Oct 2008, Jeff Hansen wrote:
>> > 
>> > >  OK, so are we all agreed that something like clocksource_trust=tsc 
>> > >  would be
>> > >  the best?
>> >  No, it's per affected device: tsc=trust or tsc=stable or whatever
>> >  unintuitive name we want to come up. And it is a modification to TSC
>> >  not to the clocksource layer.
>>
>>  Yep, this is cool. I too have a patch in my local tree which does a
>>  similar thing i have a tsc_reliable flag which is set right now only
>>  when we are running under a VMware hypervisor.
>>  Along with marking the no_verify flag for TSC, this patch of mine also
>>  skips the TSC synchornization checks.
>>
>>          The TSC synchronization loop which is run whenever a new cpu is
>>  brought up is not actually needed on systems which are known to have a
>>  reliable TSC. TSC between 2 cpus can be off by a marginal value on such
>>  systems and thats okay for timekeeping, since we do check for tsc going
>>  back in read_tsc.
>>
>>  Can this reasoning be included and synchronization skipped for all
>>  these systems with reliable aka trustworthy TSC's  ?
>
> In general, no.  Not all hardware/hypervisors behave this way, even when the 
> TSC is otherwise stable once synchronized.
>
> -- Chris
>
>
>
