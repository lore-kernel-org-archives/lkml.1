Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810Ab0AXXZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0AXXZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642Ab0AXXZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:25:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39668 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab0AXXZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:25:12 -0500
Date: Sun, 24 Jan 2010 15:25:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: menage@google.com
Cc: linux-kernel@vger.kernel.org
Subject: locking design for task_subsys_state()?
Message-ID: <20100124232512.GA12383@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul!

The "git blame" tool tells me that I should ask you about
task_subsys_state(), which contains an rcu_dereference() that I am trying
to instrument for lockdep-enabled RCU.  I currently have it marked as
needing to either be within an RCU read-side critical section or having
the cgroup lock held.  But the following splat from my lockdep enablement
leads me to believe that I also need to check for a task that is in the
process of being created.

Is there some flag in the task structure that I should check in order to
suppress this splat, and, more important, to document the locking
design?  Here is what I currently have in my local tree:

	static inline struct cgroup_subsys_state *task_subsys_state(
		struct task_struct *task, int subsys_id)
	{
		return rcu_dereference_check(task->cgroups->subsys[subsys_id],
					     rcu_read_lock_held() ||
					     cgroup_lock_is_held());
	}

My guess is that I should be able to add a check of one of the task
structure's flags or pointers, but thought I should ask the expert
instead of inflicting my subtly wrong guesses on you all.  ;-)

							Thanx, Paul

------------[ cut here ]------------
Badness at include/linux/cgroup.h:492
NIP: c0000000000c9804 LR: c0000000000c97ec CTR: c0000000000a241c
REGS: c000000000a174a0 TRAP: 0700   Not tainted  (2.6.33-rc4-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 84000022  XER: 00000004
TASK = c0000000008cecc0[0] 'swapper' THREAD: c000000000a14000 CPU: 0
GPR00: 0000000000000001 c000000000a17720 c000000000a15378 0000000000000000 
GPR04: c0000000008edc88 0000000000000006 0000000000000001 c000000001406e70 
GPR08: 0000000000000002 c000000001275171 c0000000008cf5a0 c0000000008cecc0 
GPR12: 8000000000009032 c000000000a33480 0000000002100000 c000000000776300 
GPR16: c000000000774a00 0000000000000000 0000000000000000 0000000000000000 
GPR20: c000000000a17b60 c000000000a17de0 c0000002d3ff8140 0000000000000000 
GPR24: 0000000000800b00 0000000000000000 c0000000e6668000 0000000000000000 
GPR28: c0000000e6003000 fffffffffffffff4 c000000000968a68 c0000000008cecc0 
NIP [c0000000000c9804] .current_cpuset_is_being_rebound+0x5c/0xa8
LR [c0000000000c97ec] .current_cpuset_is_being_rebound+0x44/0xa8
Call Trace:
[c000000000a17720] [c0000000000c97ec] .current_cpuset_is_being_rebound+0x44/0xa8 (unreliable)
[c000000000a177a0] [c0000000001453ac] .__mpol_dup+0x48/0xb8
[c000000000a17850] [c00000000006ae2c] .copy_process+0x5f4/0x1248
[c000000000a17950] [c00000000006bf20] .do_fork+0x198/0x444
[c000000000a17a80] [c000000000012ce8] .sys_clone+0x5c/0x74
[c000000000a17af0] [c000000000008788] .ppc_clone+0x8/0xc
--- Exception: c00 at .kernel_thread+0x28/0x70
    LR = .rest_init+0x34/0x120
[c000000000a17de0] [c000000000875a34] .proc_sys_init+0x20/0x64 (unreliable)
[c000000000a17e50] [c000000000009a68] .rest_init+0x20/0x120
[c000000000a17ee0] [c000000000854a8c] .start_kernel+0x480/0x4a4
[c000000000a17f90] [c0000000000083ac] .start_here_common+0x1c/0x70
Instruction dump:
e87e8028 4bfddbed 60000000 2fa30000 409e0038 4bff7a29 60000000 2fa30000 
409e0028 e93e8040 88090000 68000001 <0b000000> 2fa00000 41be0010 e93e8040 
