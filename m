Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYIIPuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYIIPuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYIIPuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:50:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55020 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756614AbYIIPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:50:14 -0400
Message-Id: <20080909155013.455071000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 09 Sep 2008 08:50:13 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: remove extraneous stack cpumask variables
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some more minor cleanups in cpumask stack usage with no new cpumask
functions (except for the for_each_online_cpu_mask_nr call).  Frees
up more memory for the stack.  Also, cleans up the genapic API to
always pass pointers (for both 32 and 64) and to not return cpumask
function values.

  * Add for_each_online_cpu_mask_nr to eliminate a common case of needing
    a temporary on-stack cpumask_t variable.

  * Change the genapic->send_IPI_mask function to accept cpumask_t pointer.

  * Rewrite "send_IPI_allbutself" to not need a temp cpumask_t variable.

  * Change send_IPI_mask function in xen to use for_each_online_cpu_mask_nr().

  * Modify internal io_apic.c functions to accept cpumask_t pointer where
    possible.


Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---

Summary from allmodconfig (NR_CPUS=4k, #NODES=512)

====== Stack (-l 500)
... files 4 vars 144 all 0 lim 500 unch 0

    1 - initial
    3 - send_IPI_mask
    4 - stack-hogs-kernel_sched_c

   .1.    .3.   .4.    ..final..
  1608  -1008     .  600   -62%  setup_IO_APIC_irq
  1592  -1024     .  568   -64%  msi_compose_msg
  1576      .  -512 1064   -32%  move_task_off_dead_cpu
  1560  -1024     .  536   -65%  setup_ioapic_dest
  1560  -1008     .  552   -64%  migrate_ioapic_irq
  1560  -1032     .  528   -66%  arch_setup_ht_irq
  1560  -1008     .  552   -64%  __assign_irq_vector
  1552  -1024     .  528   -65%  ir_set_msi_irq_affinity
  1144   -512     .  632   -44%  setup_IO_APIC
  1048   -520     .  528   -49%  setup_timer_IRQ0_pin
  1048  -1048     .    .  -100%  native_machine_crash_shutdown
  1048   -512     .  536   -48%  native_flush_tlb_others
  1040   -512     .  528   -49%  set_msi_irq_affinity
  1040   -512     .  528   -49%  set_ht_irq_affinity
  1040   -512     .  528   -49%  hpet_msi_set_affinity
  1040   -512     .  528   -49%  dmar_msi_set_affinity
  1032  -1032     .    .  -100%  set_ioapic_affinity_irq
  1032   -520     .  512   -50%  irq_complete_move
  1032   -520     .  512   -50%  create_irq_nr
  1024  -1024     .    .  -100%  x2apic_vector_allocation_domain
  1024  -1024     .    .  -100%  x2apic_send_IPI_allbutself
  1024  -1024     .    .  -100%  uv_vector_allocation_domain
  1024  -1024     .    .  -100%  uv_send_IPI_allbutself
  1024  -1024     .    .  -100%  physflat_send_IPI_allbutself
  1024  -1024     .    .  -100%  native_send_call_func_ipi
  1024  -1024     .    .  -100%  flat_send_IPI_allbutself
   552      .  -552    .  -100%  free_sched_groups
   520   -520     .    .  -100%  x2apic_send_IPI_all
   520   -520     .    .  -100%  uv_send_IPI_all
   520   -520     .    .  -100%  set_ir_ioapic_affinity_irq
   520   -520     .    .  -100%  physflat_send_IPI_mask
   520   -520     .    .  -100%  physflat_send_IPI_all
   520   -520     .    .  -100%  native_smp_send_reschedule
   520   -520     .    .  -100%  native_send_call_func_single_ipi
   520   -520     .    .  -100%  lapic_timer_broadcast
   512   -512     .    .  -100%  xen_smp_send_call_function_single_ipi
   512   -512     .    .  -100%  xen_smp_send_call_function_ipi
   512   -512     .    .  -100%  ioapic_retrigger_irq
   512   -512     .    .  -100%  flat_send_IPI_all
   512      .  -512    .  -100%  cpu_to_allnodes_group
   512   -512     .    .  -100%  assign_irq_vector
39064 -27192 -1576 10296  -73%  Totals

====== MemInfo ()
... files 0 vars 0 all 0 lim 0 unch 0

-- 
