Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYJBUeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYJBUeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 16:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYJBUei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 16:34:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34018 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbYJBUeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 16:34:37 -0400
Date: Thu, 2 Oct 2008 22:40:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs to be set at compile time
Message-ID: <20081002204018.GD8318@one.firstfloor.org>
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002160907.68d79e0b@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The prefix rewriting doesn't happen unless I boot with additional_cpus=0,
> maxcpus=1, or with this patch applied and the config option set. I think
> the rules for when/if the rewriting happens changed a while ago to avoid
> multiple switches and now it's not happening at all on this machine by
> default.

Well then something is broken, but the fix is not to lower num_possible_cpus(),
but to fix the root cause.

Does the appended patch help?

> Oh, and with NR_CPUS=512 I am seeing 1.6MB per-cpu data (I'll have to
> check that, but I remember being surprised at how big the number was.)

How did you measure? And you mean total right? If it's total
then it's ~32KB/CPU which is roughly similar to my 40k number
(probably depends on CONFIG options) 

The standard way is  __per_cpu_start - __per_cpu_end (on 64bit;
or the other way round on 32bit). That segment is duplicated
per CPU. Ok there are some dynamic data structures that scale too,
so it's possible a little more.

Single per cpu data should not scale with NR_CPUS, but be constant.

-Andi

---

Take disabled cpus into account in alternative.c

Otherwise an UP system with one hotplug CPU will not 
go into UP mode.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/alternative.c
+++ linux-2.6.27-rc4-misc/arch/x86/kernel/alternative.c
@@ -454,7 +454,7 @@ void __init alternative_instructions(voi
 					    _text, _etext);
 
 		/* Only switch to UP mode if we don't immediately boot others */
-		if (num_possible_cpus() == 1 || setup_max_cpus <= 1)
+		if (num_possible_cpus() - additional_cpus == 1 || setup_max_cpus <= 1)
 			alternatives_smp_switch(0);
 	}
 #endif
Index: linux-2.6.27-rc4-misc/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.27-rc4-misc/arch/x86/kernel/smpboot.c
@@ -1276,7 +1276,7 @@ static void remove_siblinginfo(int cpu)
 	cpu_clear(cpu, cpu_sibling_setup_map);
 }
 
-static int additional_cpus __initdata = -1;
+int additional_cpus = -1;
 
 static __init int setup_additional_cpus(char *s)
 {
Index: linux-2.6.27-rc4-misc/include/asm-x86/smp.h
===================================================================
--- linux-2.6.27-rc4-misc.orig/include/asm-x86/smp.h
+++ linux-2.6.27-rc4-misc/include/asm-x86/smp.h
@@ -204,5 +204,7 @@ static inline int hard_smp_processor_id(
 extern void cpu_uninit(void);
 #endif
 
+extern int additional_cpus;
+
 #endif /* __ASSEMBLY__ */
 #endif
-- 
ak@linux.intel.com
