Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYLOWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYLOWVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYLOWVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:21:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38839 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYLOWVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:21:07 -0500
Date: Mon, 15 Dec 2008 23:33:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: re-enable MCE on secondary CPUS after suspend/resume
Message-ID: <20081215223310.GX25779@one.firstfloor.org>
References: <20081212180650.GS19144@alberich.amd.com> <20081212181021.GU19144@alberich.amd.com> <873agtnrgy.fsf@basil.nowhere.org> <20081215190509.GB5620@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215190509.GB5620@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
> {
>         static cpumask_t mce_cpus = CPU_MASK_NONE;
> 
>         mce_cpu_quirks(c);
> 
>         if (mce_dont_init ||
>             cpu_test_and_set(smp_processor_id(), mce_cpus) ||
>             !mce_available(c))
>   =>             return;
> 
>         mce_init(NULL);
>         mce_cpu_features(c);
> }
> 
> But we need to call mce_init to clear all MCE state.
> IMHO the best location to call mce_init for APs is the cpu notifier.

Ah got it. Thanks that makes sense. 

But I think the better fix is to just drop the mce_cpus check and
then handly it naturally in the standard bootup path. I'm not
sure what it was good for anyways. I copied it into the 64bit code
from 32bit, but I suppose even there it isn't really needed and on 
32bit it is already gone even.

How about this patch. Does it fix the problem for you too?

-Andi

--


Don't prevent multiple initialization of MCEs.

Back from early prehistory mcheck_init() has a reentry check. Presumably
that was needed in very old kernels to prevent it entering twice.

But as Andreas points out this prevents CPU hotplug (and therefore resume)
to correctly reinitialize MCEs when a AP boots again after being
offlined. 

Just drop the check.

Based on a report from Andreas Herrmann

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-12-15 23:13:02.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-12-15 23:13:44.000000000 +0100
@@ -510,12 +510,9 @@
  */
 void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 {
-	static cpumask_t mce_cpus = CPU_MASK_NONE;
-
 	mce_cpu_quirks(c);
 
 	if (mce_dont_init ||
-	    cpu_test_and_set(smp_processor_id(), mce_cpus) ||
 	    !mce_available(c))
 		return;
 
