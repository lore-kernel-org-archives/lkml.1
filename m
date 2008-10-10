Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbYJJOZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbYJJOZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbYJJOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:25:04 -0400
Received: from kara.rubysoft.com ([64.34.171.174]:59114 "EHLO
	kara.rubysoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbYJJOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:25:03 -0400
Date: Fri, 10 Oct 2008 08:24:53 -0600 (MDT)
From: Jeff Hansen <x@jeffhansen.com>
X-X-Sender: ninkid@ren
Reply-To: Jeff Hansen <x@jeffhansen.com>
To: Chris Snook <csnook@redhat.com>
cc: akataria@vmware.com, Alok kataria <alokkataria1@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <48EE959D.7090706@redhat.com>
Message-ID: <Pine.LNX.4.64.0810100823230.32632@ren>
References: <Pine.LNX.4.64.0810071640110.25661@ren>  <48ED1728.5060708@redhat.com>
 <Pine.LNX.4.64.0810081542300.14815@ren>  <48ED2A89.3000902@redhat.com>
 <Pine.LNX.4.64.0810081554380.14982@ren>  <alpine.LFD.2.00.0810090910510.3237@apollo>
  <48EE4FC4.7070902@redhat.com>  <alpine.LFD.2.00.0810092118100.3271@apollo>
  <Pine.LNX.4.64.0810091344250.24851@ren>  <alpine.LFD.2.00.0810092152410.3271@apollo>
  <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com> 
 <48EE71A9.2010907@redhat.com> <1223589220.32639.24.camel@alok-dev1> 
 <48EE8AB2.5000302@redhat.com> <1223594575.32639.58.camel@alok-dev1>
 <48EE959D.7090706@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is against 2.6.27.


[X86] Add tsc=stable option for marking TSC as stable

This enables legacy hardware or VMs without HPET, LAPIC, or ACPI timers
to enter high-resolution timer mode.

Signed-off-by: Jeff Hansen <jhansen@cardaccess-inc.com>
---
  Documentation/kernel-parameters.txt |    4 ++++
  arch/x86/kernel/tsc.c               |   11 +++++++++++
  2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1150444..0528bcb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2174,6 +2174,10 @@ and is between 256 and 4096 characters. It is defined in the file
  			Format:
  			<io>,<irq>,<dma>,<dma2>,<sb_io>,<sb_irq>,<sb_dma>,<mpu_io>,<mpu_irq>

+	tsc=		[X86-32,X86-64]
+			tsc=stable: Mark TSC clocksource as stable, enabling
+			        high-resolution timer mode on older hardware.
+
  	turbografx.map[2|3]=	[HW,JOY]
  			TurboGraFX parallel port interface
  			Format:
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 8f98e9d..70e485e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -98,6 +98,17 @@ int __init notsc_setup(char *str)

  __setup("notsc", notsc_setup);

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
  #define MAX_RETRIES     5
  #define SMI_TRESHOLD    50000

-- 
1.5.6.4

---------------------------------------------------
"If someone's gotta do it, it might as well be me."

On Thu, 9 Oct 2008, Chris Snook wrote:

> Alok Kataria wrote:
>>  On Thu, 2008-10-09 at 15:50 -0700, Chris Snook wrote:
>> >  Alok Kataria wrote:
>> > >  On Thu, 2008-10-09 at 14:03 -0700, Chris Snook wrote:
>> > > 
>> > >  I agree that in general this should be no, but since this is a
>> > >  commandline variable it will be normally set for only those systems
>> > >  which have only TSC as a option or know that the TSC is reliable.
>> > >  wouldn't doing this be ok for such systems ?
>> >  Hardware doesn't deliberately do any TSC synchronization, though you 
>> >  might get
>> >  it by accident in some configurations.  A VMware guest gets it for free 
>> >  thanks
>> >  to the hypervisor doing it in software, but we need to run the check 
>> >  when we're
>> >  booting on bare metal.
>>
>>  The TSC sync algorithm right now expects that TSC are perfectly in sync
>>  between cpus.
>>  But, the hardware doesn't deliberately do any synchronization, so we can
>>  have situations where TSC was (accidently ? )off by a marginal value
>>  during boot and as a result we mark TSC as unstable and don't use it as
>>  a clocksource at all. For systems like the ones Jeff is using wouldn't
>>  that be a problem. IOW, even though the TSC was *marginally* off during
>>  bootup it should still be used as a clocksource, since you have no other
>>  option, no ? 
>
> You seem to be conflating position and rate.  When we mark TSC as stable, 
> we're saying it will always advance at a known rate on all CPUs, but this 
> says nothing about the relative positions on the different CPUs.  That skew 
> can be huge on some hardware, not just marginal, so we still need to 
> synchronize them at boot time, even though we don't need to (and can't, in 
> this case) verify stability with another continuous clock source.
>
> -- Chris
>
>
