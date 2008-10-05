Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbYJEPUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbYJEPUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 11:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYJEPUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 11:20:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42406 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbYJEPUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 11:20:38 -0400
Date: Sun, 5 Oct 2008 17:20:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional
	hotplug CPUs to be set at compile time
Message-ID: <20081005152025.GA27066@elte.hu>
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org> <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu> <alpine.LFD.2.00.0810051626150.3398@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810051626150.3398@apollo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 5 Oct 2008, Ingo Molnar wrote:
> > * Chuck Ebbert <cebbert@redhat.com> wrote:
> > 
> > > Yes, it works and I don't see how it could cause any problems.
> > > 
> > > Ingo, can we get this in 2.6.27? You can drop my original patch.
> > > 
> > > Tested-by: Chuck Ebbert <cebbert@redhat.com>
> > 
> > looks good, applied to tip/x86/core, thanks!
> 
> No, this patch is horrible. 
> 
> The correct check is num_present_cpus(). There is no need to make the 
> weird additional_cpus hackery globally available.

ah, indeed!

applied to tip/x86/core and i've zapped Andi's patch.

> Btw, additional_cpus has interesting properties. Providing a negative 
> number < -1 on the kernel command line - happened due to a typo - 
> explodes in early boot, which is not really surprising, but should be 
> sanity checked.

indeed, and that mess was introduced, interestingly, by this commit, 
three years ago, by Andi:

| From 420f8f68c9c5148dddf946bebdbc7eacde2172cb Mon Sep 17 00:00:00 2001
| From: Andi Kleen <ak@suse.de>
| Date: Sat, 5 Nov 2005 17:25:54 +0100
| Subject: [PATCH] [PATCH] x86_64: New heuristics to find out hotpluggable CPUs.

so to clean up the mess i've removed the additional_cpus= boot parameter 
and the Kconfig entry as well - see the patch in x86/core below.

thanks Thomas for decoding this ...

and no way can any of this go into v2.6.27: this is fragile code with a 
lot of historic baggage and the original error is non-fatal to begin 
with. It can easily be backported to .27.1 if testing shows that it has 
no other adverse side-effects.

	Ingo

------------------>
>From a3f493ab543d300b3a01ad18bf12f73746ae5c9f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 5 Oct 2008 17:12:36 +0200
Subject: [PATCH] x86: remove additional_cpus configurability

additional_cpus=<x> parameter is dangerous and broken: for example
if we boot additional_cpus=-2 on a stock dual-core system it will
crash the box on bootup.

So reduce the maze of code a bit by removingthe user-configurability
angle.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig          |   18 ------------------
 arch/x86/kernel/smpboot.c |    8 +-------
 2 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7dff081..e2c060e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1365,24 +1365,6 @@ config HOTPLUG_CPU
 	  Say N if you want to disable CPU hotplug and don't need to
 	  suspend.
 
-config HOTPLUG_RESTRICT_TO_BOOTUP_CPUS
-	def_bool n
-	prompt "Restrict CPU hotplugging to processors found during boot" if HOTPLUG_CPU
-	---help---
-	  Say no here to use the default, which allows as many CPUs as are marked
-	  "disabled" by ACPI or MPTABLES to be hotplugged after bootup.
-
-	  Say yes if you do not want to allow CPUs to be added after booting, for
-	  example if you only need CPU hotplugging enabled for suspend/resume.
-
-	  If CPU_HOTPLUG is enabled this value may be overridden at boot time
-	  with the "additional_cpus" kernel parameter.
-
-config HOTPLUG_ADDITIONAL_CPUS
-	int
-	default  0 if !HOTPLUG_CPU || HOTPLUG_RESTRICT_TO_BOOTUP_CPUS
-	default -1
-
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9ac428a..3868018 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1260,7 +1260,7 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	check_nmi_watchdog();
 }
 
-static int additional_cpus __initdata = CONFIG_HOTPLUG_ADDITIONAL_CPUS;
+static int additional_cpus = -1;
 
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
@@ -1333,12 +1333,6 @@ static void remove_siblinginfo(int cpu)
 	cpu_clear(cpu, cpu_sibling_setup_map);
 }
 
-static __init int setup_additional_cpus(char *s)
-{
-	return s && get_option(&s, &additional_cpus) ? 0 : -EINVAL;
-}
-early_param("additional_cpus", setup_additional_cpus);
-
 static void __ref remove_cpu_from_maps(int cpu)
 {
 	cpu_clear(cpu, cpu_online_map);
