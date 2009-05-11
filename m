Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZEKLwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZEKLwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZEKLvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:51:53 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39190 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZEKLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:51:52 -0400
Date: Mon, 11 May 2009 17:21:42 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090511115142.GA25673@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
	Please find the new set of patches with the changes mentioned below.
Kindly let me know your comments with respect to the same.

Hi Frederic/Steven,
	Please find a few changes in the ftrace plugin code w.r.t.
synchronisation primitives (prefixed in the changelog with FTRACE). Kindly let
me know your comments.

Changelog
-----------

- on_each_cpu() call will now return only after all functions calls made through
  IPI have finished (@wait parameter is set to 1). This is required since
  changes made in code following on_each_cpu() [such as incrementing
  hbp_kernel_pos] have side-effects on the execution of the functions invoked
  through IPIs. It is also safe to make them wait inside spin_lock() context as
  it does a busy wait using cpu_relax().

- Introduced a new per-cpu array of pointers to 'struct hw_breakpoint'
  called 'this_hbp_kernel'. This per-cpu variable helps overcome any
  side-effects in  hbp_handler() due to parallel execution of
  (un)register_kernel_hw_breakpoint()  on other CPUs causing 'hbp_kernel' value
  to change.

- Hardware Breakpoint exceptions due to lazy debug register switching is
  now identified through the absence of TIF_DEBUG task flag in the current
  process. This eliminates the  need to store the process that last set the
  debug register in  'last_debugged_task'.

- Converted spin_lock() in kernel/hw_breakpoint.c to spin_lock_bh(). This is
  to ward-off potential circular dependancy over 'hw_breakpoint_lock' when
  flush_thread_hw_breakpoint() is invoked in softIRQ context.

- Ptrace code now directly uses the exported interfaces
  (un)register_user_hw_breakpoint() thereby addressing some of the issues
  pointed out in code-review here:http://lkml.org/lkml/2009/5/4/367.

- An optimisation in arch_update_kernel_hw_breakpoints() code resulting in a
  few modifications to the function and removal of kdr7_masks[] global array (as
  pointed out by Alan Stern).

- [FTRACE] Implementation of RCU based locking mechanism in the ftrace plugin
  code (kernel/trace/trace_ksym.c), specially to avoid the potential circular
  dependancy through ksym_collect_stats() invoked in exception context (while
  attempting to acquite a spin_lock() already used in control-plane). All
  add/delete operations to the hlist pointed by 'ksym_filter_head' are now
  protected by RCU.

- [FTRACE] Revert the spin_lock() based implementation in kernel/trace/trace_ksym.c
  to mutex based one, as a result of the above change. These locks are no longer
  required in preempt_disable() code due to RCU implementation in
  ksym_collect_stats() and hence the change.

- The patches are now based on commit 5863f0756c57cc0ce23701138bfc88ab3d1f3721
  of -tip tree.

Thanks,
K.Prasad

