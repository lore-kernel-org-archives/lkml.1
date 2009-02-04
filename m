Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZBDPiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZBDPiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZBDPhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:37:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754912AbZBDPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:37:50 -0500
Date: Wed, 4 Feb 2009 07:36:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090204073636.30f15339.akpm@linux-foundation.org>
In-Reply-To: <200902042111.35543.rusty@rustcorp.com.au>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200902041314.32277.rusty@rustcorp.com.au>
	<20090203190111.2ec31cef.akpm@linux-foundation.org>
	<200902042111.35543.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 21:11:35 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 04 February 2009 13:31:11 Andrew Morton wrote:
> > On Wed, 4 Feb 2009 13:14:31 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > I think you're right though: smp_call_function_single (or neat wrappers)
> > > where possible, work_on_cpu which can fail for the others, and we'll just
> > > have to plumb in the error returns.
> > 
> > I bet a lot of those can use plain old schedule_work_on().
> 
> Which is where work_on_cpu started: a little wrapper around schedule_work_on.
> 
> We're going in circles, no?

No, we've made some progress.  We have a better understanding of what
the restrictions, shortcomings and traps are in this stuff.  We've
learned (surprise!) that a one-size-fits-all big hammer wasn't such a
great idea.

Proposed schedule_work_on() rule: either the flush_work() caller or the
callback should not hold any explicit or implicit sleeping locks.

Quick scan:

arch/x86/kernel/reboot.c:native_machine_shutdown()

  I think this can/should continue to use set_cpus_allowed(). 
  Although it could be converted to schedule_work_on(), as long as the
  scheduler is still working properly at this time.

x86 microcode:

  This code is just nuts.  What's the point in pinning itself to a
  CPU for the act of loading the microcode into main memory?  It's only
  the loading of the microcode which should care about which CPU
  executes the code.  ie: apply_microcode().

  The code needs some laundering, switch to schedule_work_on(). 
  Ensure that the callback functions don't take microcode_mutex.

arch/x86/kernel/apm_32.c:

  It's a kernel thread.  Add kthread_bind() to caller, done.

arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c:

  Switch to rdmsr_on_cpu() and friends

arch/x86/kernel/cpu/cpufreq/powernow-k8.c

  Could get similar treatment (needs new cpuid_on_cpu()?).  Looks
  like schedule_work_on() would be OK to use as well.

arch/x86/kernel/cpu/cpufreq/speedstep-ich.c

  Use rdmsr_on_cpu().

arch/blackfin/kernel/ipipe.c

  Use kthread_bind()

arch/arm/mach-integrator/cpu.c

  Not sure.

arch/sparc/kernel/us3_cpufreq.c

  Use smp_call_function_single().  Write sparc64_get_clock_tick_on_cpu().

arch/sparc/kernel/us2e_cpufreq.c

  Ditto

arch/sparc/kernel/sysfs.c

  If sun4v_mmustat_info() can be called from interrupt, use
  smp_call_function_single().  Otherwise schedule_work_on().

arch/powerpc/platforms/pseries/rtasd.c

  Ditto

arch/powerpc/kernel/smp.c

  Ditto

arch/powerpc/kernel/sysfs.c

  Blah.  Looks like schedule_work_on() will be OK.

arch/mips/kernel/traps.c

  NFI what this does

arch/sh/kernel/cpufreq.c

  schedule_work_on()

arch/ia64/sn/kernel/sn2/sn_hwperf.c

  schedule_work_on()

arch/ia64/kernel/salinfo.c:

  schedule_work_on()

arch/ia64/kernel/topology.c:

  schedule_work_on()

arch/ia64/kernel/cpufreq/acpi-cpufreq.c:

  schedule_work_on()

mm/pdflush.c:

  wtf what the heck is all that stuff and who added it?  weird.

  Leave it alone I guess.  Can admins manually move kernel threads to
  other CPUs?

mm/vmscan.c:

  switch to kthread_bind()

net/sunrpc/svc.c:

  switch to kthread_bind()

kernel/kmod.c:

  switch to kthreads, write then switch to kthread_bind_mask().

drivers/firmware/dcdbas.c:

  smp_call_function_single()

drivers/misc/sgi-xp/xpc_main.c:

  kthread_bind()

drivers/acpi/processor_throttling.c:

  already done


