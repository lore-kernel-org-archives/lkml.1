Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYJEPw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYJEPw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 11:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYJEPwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 11:52:18 -0400
Received: from www.tglx.de ([62.245.132.106]:49907 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYJEPwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 11:52:17 -0400
Date: Sun, 5 Oct 2008 17:51:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional
 hotplug CPUs to be set at compile time
In-Reply-To: <20081005152025.GA27066@elte.hu>
Message-ID: <alpine.LFD.2.00.0810051732380.3398@apollo>
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org>
 <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu> <alpine.LFD.2.00.0810051626150.3398@apollo> <20081005152025.GA27066@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Sun, 5 Oct 2008, Ingo Molnar wrote:
> > > * Chuck Ebbert <cebbert@redhat.com> wrote:
> > > 
> > > > Yes, it works and I don't see how it could cause any problems.
> > > > 
> > > > Ingo, can we get this in 2.6.27? You can drop my original patch.
> > > > 
> > > > Tested-by: Chuck Ebbert <cebbert@redhat.com>
> > > 
> > > looks good, applied to tip/x86/core, thanks!
> > 
> > No, this patch is horrible. 
> > 
> > The correct check is num_present_cpus(). There is no need to make the 
> > weird additional_cpus hackery globally available.
> 
> ah, indeed!
> 
> applied to tip/x86/core and i've zapped Andi's patch.
> 
> > Btw, additional_cpus has interesting properties. Providing a negative 
> > number < -1 on the kernel command line - happened due to a typo - 
> > explodes in early boot, which is not really surprising, but should be 
> > sanity checked.
> 
> indeed, and that mess was introduced, interestingly, by this commit, 
> three years ago, by Andi:
> 
> | From 420f8f68c9c5148dddf946bebdbc7eacde2172cb Mon Sep 17 00:00:00 2001
> | From: Andi Kleen <ak@suse.de>
> | Date: Sat, 5 Nov 2005 17:25:54 +0100
> | Subject: [PATCH] [PATCH] x86_64: New heuristics to find out hotpluggable CPUs.
> 
> so to clean up the mess i've removed the additional_cpus= boot parameter 
> and the Kconfig entry as well - see the patch in x86/core below.
> 
> thanks Thomas for decoding this ...
> 
> and no way can any of this go into v2.6.27: this is fragile code with a 
> lot of historic baggage and the original error is non-fatal to begin 
> with. It can easily be backported to .27.1 if testing shows that it has 
> no other adverse side-effects.

Please lets get rid of all this.

Thanks,

	tglx
---------------->
>From 344707c1f43dd0d080828497aacb60c0cc0a8c13 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 5 Oct 2008 17:27:56 +0200
Subject: [PATCH] x86, smpboot: remove additional_cpus

remove remainder of additional_cpus logic. We now just listen to the
disabled_cpus value like we did for years. disabled_cpus is always >=
0 so no need for an extra check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smpboot.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3868018..d6a4d95 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1260,8 +1260,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	check_nmi_watchdog();
 }
 
-static int additional_cpus = -1;
-
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
  * are onlined, or offlined. The reason is per-cpu data-structures
@@ -1281,21 +1279,13 @@ static int additional_cpus = -1;
  */
 __init void prefill_possible_map(void)
 {
-	int i;
-	int possible;
+	int i, possible;
 
 	/* no processor from mptable or madt */
 	if (!num_processors)
 		num_processors = 1;
 
-	if (additional_cpus == -1) {
-		if (disabled_cpus > 0)
-			additional_cpus = disabled_cpus;
-		else
-			additional_cpus = 0;
-	}
-
-	possible = num_processors + additional_cpus;
+	possible = num_processors + disabled_cpus;
 	if (possible > NR_CPUS)
 		possible = NR_CPUS;
 
