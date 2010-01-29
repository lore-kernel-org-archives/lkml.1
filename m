Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453Ab0A2Gwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0A2Gwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235Ab0A2Gwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:52:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:18125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0A2Gwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:52:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,365,1262592000"; 
   d="scan'208";a="768320370"
Subject: Re: [BUG] tip tree - No irq handler for vector (irq -1)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B625296.5090903@np.css.fujitsu.com>
References: <4B6143C5.7060602@cn.fujitsu.com>
	 <1264709113.2849.14.camel@sbs-t61.sc.intel.com>
	 <4B62366E.6040207@cn.fujitsu.com>
	 <1264727895.2849.70.camel@sbs-t61.sc.intel.com>
	 <4B6238DB.8010102@cn.fujitsu.com>  <4B625296.5090903@np.css.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 28 Jan 2010 22:51:27 -0800
Message-Id: <1264747887.2689.37.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 19:14 -0800, Jin Dongming wrote:
> Hi,
> 
> Maybe this problem is caused by that FIRST_DEVICE_VECTOR(IRQ 0x30)
> does not assigned really.

No. The problem is that this system's logical flat is behaving weird.

Even when the IO-APIC RTE says send the interrupt to cpu-0, it sends the
interrupt to cpu-1 (for which we haven't really initialized the vector
to irq mapping).

Actually this case is documented by Eric Biederman in the code like
this:

static void flat_vector_allocation_domain(int cpu, struct cpumask
*retmask)
{
        /* Careful. Some cpus do not strictly honor the set of cpus
         * specified in the interrupt destination when using lowest
         * priority interrupt delivery mode.
         *
         * In particular there was a hyperthreading cpu observed to
         * deliver interrupts to the wrong hyperthread when only one
         * hyperthread was specified in the interrupt desitination.
         */
        cpumask_clear(retmask);
        cpumask_bits(retmask)[0] = APIC_ALL_CPUS;
}

And the previous kernel codes were handling this and my recent changes
to vector assignments broke this behavior. My previous fix addressed a
portion of this issue and hence Zefan's keyboard etc started working.
Nevertheless there is one more corner case which needs to get addressed
and if my understanding is correct, the appended patch (ontop of the
patch that Zefan has already tested) should fix the issue.

Zefan, can you also apply this fix (untested/uncompiled) on top of the
previous fix and see if it resolves the issue? If so, I will add
appropriate changelog, comments and send it tomorrow morning for -tip
consideration after more testing. Thanks.
---

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..5d9896b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -241,6 +241,13 @@ static void __cpuinit smp_callin(void)
 	map_cpu_to_logical_apicid();
 
 	notify_cpu_starting(cpuid);
+
+	/*
+ 	 * Need to setup vector mappings before we enable interrupts.
+ 	 */
+	lock_vector_lock();
+	__setup_vector_irq(smp_processor_id());
+	unlock_vector_lock();
 	/*
 	 * Get our bogomips.
 	 *
@@ -315,7 +322,6 @@ notrace static void __cpuinit start_secondary(void
*unused)
 	 */
 	ipi_call_lock();
 	lock_vector_lock();
-	__setup_vector_irq(smp_processor_id());
 	set_cpu_online(smp_processor_id(), true);
 	unlock_vector_lock();
 	ipi_call_unlock();


