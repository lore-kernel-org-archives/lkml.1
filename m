Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZBLBPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZBLBPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZBLBNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:13:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZBLBNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:13:47 -0500
Message-Id: <20090212011051.265346435@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Feb 2009 20:10:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 0/7][RFC] function graph tracer port to PowerPC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following set of patches are RFC and not for inclusion
(unless everyone is fine with them as is).

This is the port to PowerPC of the function graph tracer that was written
by Frederic Weisbecker for the x86 architecture.  It is broken up
into a series of logical steps.

1) get generic code ready for other archs
2) get PowerPC 64-bit working with just static function tracing
3) get PowerPC 64-bit working with dynamic function tracing
4) get PowerPC 32-bit working with just static function tracing
5) get PowerPC 32-bit working with dynamic function tracing

(with some clean ups in between)


The function graph tracer not only traces the start of a function
(uses the function tracer part for that) but also uses the kprobes
trick to replace the return address with a hook to trace the exit
of the function. These hooks are generic in that other tracers
can also use them. But the function graph tracer itself is very
powerful. Simply doing the following:

# echo function_graph > /debug/tracing/current_tracer
# cat /debug/tracing/trace

# tracer: function_graph
#
# CPU OVERHEAD/DURATION            FUNCTION CALLS
# |   |        |                   |   |   |   |
 ------------------------------------------
 0)   less-2228    =>    cat-2229   
 ------------------------------------------

 0)               |    .__do_fault() {
 0)               |      .filemap_fault() {
 0)               |        .find_lock_page() {
 0)               |          .find_get_page() {
 0)   3.168 us    |            .__rcu_read_lock();
 0)   2.704 us    |            .__rcu_read_unlock();
 0) + 14.640 us   |          }
 0) + 20.112 us   |        }
 0) + 26.464 us   |      }
 0)   2.912 us    |      ._spin_lock();
 0)   2.656 us    |      .page_add_file_rmap();
 0)               |      .update_mmu_cache() {
 0)               |        .hash_preload() {
 0)   2.368 us    |          .get_slice_psize();
 0)   2.752 us    |          .hash_page_do_lazy_icache();
 0)   3.568 us    |          .native_hpte_insert();
 0) + 19.680 us   |        }
 0) + 24.960 us   |      }
 0)   2.336 us    |      ._spin_unlock();
 0)               |      .unlock_page() {
 0)   2.688 us    |        .page_waitqueue();
 0)   2.608 us    |        .__wake_up_bit();
 0) + 12.912 us   |      }
 0) ! 351.776 us  |    }
 0) ! 357.392 us  |  }
 0)   3.040 us    |  .up_read();
 0)               |  .compat_sys_ioctl() {
 0)   3.024 us    |    .fget_light();
 0)               |    .tty_compat_ioctl() {
 0)   2.704 us    |      .tty_paranoia_check();
 0)               |      .tty_ldisc_ref_wait() {
 0)               |        .tty_ldisc_try() {
 0)   2.880 us    |          ._spin_lock_irqsave();
 0)   2.928 us    |          ._spin_unlock_irqrestore();
 0) + 13.776 us   |        }
 0) + 19.424 us   |      }

[...]

As you can see, it gives a nice call trace of the functions being called
at run time, as well as a time stamp of how much time the function
took to execute.

Adding dynamic tracing to the mix, we can trace a single function:

# echo .do_fork > /debug/tracing/set_graph_function
# echo function_graph > /debug/tracing/current_tracer
# cat /debug/tracing/trace

# tracer: function_graph
#
# CPU OVERHEAD/DURATION            FUNCTION CALLS
# |   |        |                   |   |   |   |
 1)               |  .do_fork() {
 1)               |    .copy_process() {
 1)               |      .prepare_to_copy() {
 1)   2.944 us    |        .flush_fp_to_thread();
 1)   2.800 us    |        .flush_altivec_to_thread();
 1)   2.608 us    |        .flush_vsx_to_thread();
 1) + 19.184 us   |      }
 1)               |      .kmem_cache_alloc() {
 1)   2.464 us    |        .slab_should_failslab();
 1)   8.304 us    |      }
 1)               |      .alloc_thread_info() {
 1)               |        .kmem_cache_alloc() {
 1)   2.512 us    |          .slab_should_failslab();
 1)   8.224 us    |        }
 1) + 13.344 us   |      }
 1)   7.584 us    |      .arch_dup_task_struct();
 1)               |      .copy_creds() {
 1)   2.736 us    |        .__mutex_init();
 1)               |        .prepare_creds() {
 1)               |          .kmem_cache_alloc() {
 1)   2.640 us    |            .slab_should_failslab();
 1)   8.368 us    |          }

[...]


Note, the '.' in the '.do_fork' is a PowerPC64 thing. PowerPC32 and
other archs just need to do 'do_fork', without the dot.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/ppc/ftrace


Steven Rostedt (7):
      tracing/function-graph-tracer: make arch generic push pop functions
      powerpc64: port of the function graph tracer
      powerpc64, tracing: add function graph tracer with dynamic tracing
      powerpc64, ftrace: save toc only on modules for function graph
      powerpc32, ftrace: save and restore mcount regs with macro
      powerpc32, ftrace: port function graph tracer to ppc32, static only
      powerpc32, ftrace: dynamic function graph tracer

----
 arch/powerpc/Kconfig                 |    1 +
 arch/powerpc/include/asm/ftrace.h    |   39 ++++++++++-
 arch/powerpc/kernel/Makefile         |    9 +-
 arch/powerpc/kernel/entry_32.S       |  115 ++++++++++++++---------------
 arch/powerpc/kernel/entry_64.S       |   89 +++++++++++++++++++++-
 arch/powerpc/kernel/ftrace.c         |  135 ++++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/process.c        |   16 ++++
 arch/powerpc/kernel/vmlinux.lds.S    |    1 +
 arch/x86/include/asm/ftrace.h        |   25 ------
 arch/x86/kernel/ftrace.c             |   75 +------------------
 include/linux/ftrace.h               |   24 ++++++
 kernel/trace/trace_functions_graph.c |   75 +++++++++++++++++++
 12 files changed, 428 insertions(+), 176 deletions(-)
-- 
