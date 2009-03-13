Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZCMEe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZCMEe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZCMEeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:34:20 -0400
Received: from ozlabs.org ([203.10.76.45]:36618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZCMEeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:34:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Fri, 13 Mar 2009 15:04:08 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903131316.26455.rusty@rustcorp.com.au> <20090313032015.GD18760@elte.hu>
In-Reply-To: <20090313032015.GD18760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131504.09388.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 13:50:15 Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Friday 13 March 2009 11:27:43 Ingo Molnar wrote:
> > > 
> > > * Rusty Russell <rusty@rustcorp.com.au> wrote: 
> > > > Missing a core patch (it even got a compile warning with that 
> > > > config).
> > > So it's manual work and sometimes i notice them amongst a 
> > > boatload of other warnings, sometimes i dont.
> > 
> > Me too :( I thought you were starting a de-warning tree?  I'd 
> > be happy to send you patches (particularly, exporting 
> > deprecated symbols should not give a warning!).
> 
> Yeah - i have a de-warning tree, but it's not yet fully up and 
> running for -tip qa automation.
> 
> > > > But there's something else wrong.  Firing up my 64-bit 
> > > > test box now.
> > > 
> > > Great - so you can reproduce. Thanks,
> > 
> > Yep, and I'm running some stress tests as well now.
> > 
> > Perhaps throw away that tree, and I'll feed you a new one (the 
> > core patch needs to go at the front), but I can work either 
> > way.
> 
> Ok, i dropped it back to d95c357.
> 
> Suggestion for future workflow: we wouldnt have these somewhat 
> stressful (and stressful to you mostly!), large hickups and 
> history-less trees if you sent stuff more gradually and not so 
> close to the merge window. You exposed some of your changes to 
> linux-next but that's not nearly enough testing in practice for 
> x86-affecting patches.

Yes, I wanted to complete the patchset to make sure I wasn't going to hit
some subtle problem.

OK, please check the first patch (it's a new addition, I *think* using
the topology_* macros is right here), and the other change is:

Here's the other change: it's a little ugly (AFAICT boot_cpu_data isn't
even *used* on 64 bit, so a cleanup may be in order):

+++ b/arch/x86/kernel/smpboot.c
@@ -329,6 +329,23 @@ notrace static void __cpuinit start_seco
 	cpu_idle();
 }
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/* In this case, llc_shared_map is a pointer to a cpumask. */
+static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
+				    const struct cpuinfo_x86 *src)
+{
+	struct cpumask *llc = dst->llc_shared_map;
+	*dst = *src;
+	dst->llc_shared_map = llc;
+}
+#else
+static inline void copy_cpuinfo_x86(struct cpuinfo_x86 *dst,
+				    const struct cpuinfo_x86 *src)
+{
+	*dst = *src;
+}
+#endif /* CONFIG_CPUMASK_OFFSTACK */
+
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
@@ -338,7 +355,7 @@ void __cpuinit smp_store_cpu_info(int id
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
-	*c = boot_cpu_data;
+	copy_cpuinfo_x86(c, &boot_cpu_data);
 	c->cpu_index = id;
 	if (id != 0)
 		identify_secondary_cpu(c);

BTW, these didn't go thru linux-next: your testing is better and your
tree is too different or me to ask Stephen to merge.

Thanks!
Rusty.

The following changes since commit d95c3578120e5bc4784069439f00ccb1b5f87717:
  Ingo Molnar (1):
        Merge branch 'x86/core' into cpus4096

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-x86.git cpus4096

Rusty Russell (22):
      cpumask: use topology_core_cpumask/topology_thread_cpumask instead of cpu_core_map/cpu_sibling_map
      cpumask: replace node_to_cpumask with cpumask_of_node.
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: x86
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): x86
      cpumask: remove cpu_coregroup_map: x86
      cpumask: remove obsolete topology_core_siblings and topology_thread_siblings: x86
      cpumask: convert c1e_mask in arch/x86/kernel/process.c to cpumask_var_t.
      cpumask: convert arch/x86/kernel/nmi.c's backtrace_mask to a cpumask_var_t
      cpumask: x86: convert cpu_sibling_map/cpu_core_map to cpumask_var_t
      cpumask: convert arch/x86/kernel/cpu/mcheck/mce_64.c
      x86: arch_send_call_function_ipi_mask
      cpumask: remove x86's node_to_cpumask now everyone uses cpumask_of_node
      x86: unify 32 and 64-bit node_to_cpumask_map
      cpumask: convert node_to_cpumask_map[] to cpumask_var_t
      cpumask: convert struct cpuinfo_x86's llc_shared_map to cpumask_var_t
      x86: unify cpu_callin_mask/cpu_callout_mask/cpu_initialized_mask/cpu_sibling_setup_mask
      cpumask: use new cpumask functions throughout x86
      cpumask: clean up summit's send_IPI functions
      cpumask: make Xen use the new operators.
      cpumask: remove cpumask_t assignment from vector_allocation_domain()
      cpumask: use cpumask_var_t in uv_flush_tlb_others.
      cpumask: remove x86 cpumask_t uses.

 arch/x86/include/asm/cpumask.h              |   18 -----
 arch/x86/include/asm/pci.h                  |    5 -
 arch/x86/include/asm/processor.h            |    2 +-
 arch/x86/include/asm/smp.h                  |   13 ++--
 arch/x86/include/asm/topology.h             |   89 +++++-----------------
 arch/x86/kernel/apic/bigsmp_32.c            |   16 ++--
 arch/x86/kernel/apic/es7000_32.c            |   17 ++--
 arch/x86/kernel/apic/nmi.c                  |   11 ++-
 arch/x86/kernel/apic/numaq_32.c             |   11 ++-
 arch/x86/kernel/apic/probe_32.c             |    3 +-
 arch/x86/kernel/apic/summit_32.c            |   21 ++---
 arch/x86/kernel/cpu/common.c                |   12 ---
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c   |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |   13 ++-
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c         |   10 ++-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c     |    6 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c   |    2 +-
 arch/x86/kernel/cpu/proc.c                  |    6 +-
 arch/x86/kernel/process.c                   |   12 ++-
 arch/x86/kernel/smpboot.c                   |   70 ++++++++++-------
 arch/x86/kernel/tlb_uv.c                    |    9 ++-
 arch/x86/mm/Makefile                        |    2 +-
 arch/x86/mm/numa.c                          |   67 ++++++++++++++++
 arch/x86/mm/numa_64.c                       |  111 ++-------------------------
 arch/x86/oprofile/op_model_p4.c             |    2 +-
 arch/x86/xen/smp.c                          |    6 +-
 block/blk.h                                 |    2 +-
 drivers/base/node.c                         |    2 +-
 drivers/pci/pci-driver.c                    |    3 +-
 drivers/xen/cpu_hotplug.c                   |    4 +-
 include/linux/topology.h                    |    6 +-
 kernel/sched.c                              |    8 +-
 mm/page_alloc.c                             |    6 +-
 mm/quicklist.c                              |    2 +-
 mm/slab.c                                   |    2 +-
 mm/vmscan.c                                 |    6 +-
 net/sunrpc/svc.c                            |    3 +-
 38 files changed, 246 insertions(+), 336 deletions(-)
 create mode 100644 arch/x86/mm/numa.c
