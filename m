Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYHYUKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYHYUKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYHYUKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:10:11 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:64933 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYHYUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JYdNcIuCzI3Gnf9oBRFadyLwQGpHbVb1qKd+TsaXod2u8DuAkTbu40YNRBblHl7gWq
         aPNzW1kqTn32wfyp2zz00TAxKyhD2rhewO0zlWX6pFNusRt4ceLfYhleHdZfVMEDBHfv
         418Rle50oN31BypEXHV34S2DauwhrnABvpFSA=
Message-ID: <19f34abd0808251310s43e94ce1ga6810bfe419e65c1@mail.gmail.com>
Date: Mon, 25 Aug 2008 22:10:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: v2.6.27-rc4: lockdep warning in ftrace
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some very superficial searching of lkml didn't reveal existing reports
of this problem, so I report anyway. Please accept my apologies if
this has been reported, discussed, fixed, etc. already. Here goes:

calling  rcu_torture_init+0x0/0x680
rcu-torture:--- Start of test: nreaders=4 nfakewriters=4
stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3
stutter=5 irqreader=1
initcall rcu_torture_init+0x0/0x680 returned 0 after 13 msecs
calling  rcupreempt_trace_init+0x0/0x120
initcall rcupreempt_trace_init+0x0/0x120 returned 0 after 0 msecs
calling  utsname_sysctl_init+0x0/0x20
initcall utsname_sysctl_init+0x0/0x20 returned 0 after 0 msecs
calling  init_sched_switch_trace+0x0/0x40
Testing tracer sched_switch: PASSED
initcall init_sched_switch_trace+0x0/0x40 returned 0 after 217 msecs
calling  init_stack_trace+0x0/0x10
Testing tracer sysprof: PASSED
initcall init_stack_trace+0x0/0x10 returned 0 after 104 msecs
calling  init_function_trace+0x0/0x10
Testing tracer ftrace: PASSED
Testing dynamic ftrace: PASSED
initcall init_function_trace+0x0/0x10 returned 0 after 563 msecs
calling  init_irqsoff_tracer+0x0/0x30
Testing tracer irqsoff: PASSED
Testing tracer preemptoff: PASSED
Testing tracer preemptirqsoff: <4>------------[ cut here ]------------
WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/lockdep.c:2884
check_flags+0x13c/0x160()
Pid: 261, comm: rcu_torture_wri Not tainted 2.6.27-rc4-00131-g83097ac-dirty #53
 [<c013d8a4>] warn_on_slowpath+0x54/0x80
 [<c015fd4b>] ? trace_hardirqs_off+0xb/0x10
 [<c010b615>] ? native_sched_clock+0xb5/0x110
 [<c015788c>] ? sched_clock_cpu+0xdc/0x170
 [<c015fd4b>] ? trace_hardirqs_off+0xb/0x10
 [<c01579ff>] ? cpu_clock+0x4f/0x80
 [<c018fb48>] ? ftrace_now+0x8/0x10
 [<c01423f4>] ? __local_bh_disable+0x44/0xa0
 [<c0142460>] ? local_bh_disable+0x10/0x20
 [<c01423f4>] ? __local_bh_disable+0x44/0xa0
 [<c0192606>] ? trace_preempt_off+0xc6/0xf0
 [<c015f17c>] check_flags+0x13c/0x160
 [<c0142460>] ? local_bh_disable+0x10/0x20
 [<c0164683>] lock_acquire+0x43/0xc0
 [<c01375f2>] ? add_preempt_count+0x52/0xd0
 [<c01862f0>] ? rcu_torture_writer+0x0/0x180
 [<c05d54ea>] _spin_lock_bh+0x4a/0x80
 [<c018635f>] ? rcu_torture_writer+0x6f/0x180
 [<c018635f>] rcu_torture_writer+0x6f/0x180
 [<c01519c7>] kthread+0x47/0x80
 [<c0151980>] ? kthread+0x0/0x80
 [<c0105da3>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace a7919e7f17c0a725 ]---
possible reason: unannotated irqs-on.
irq event stamp: 2719
hardirqs last  enabled at (2717): [<c01626eb>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (2718): [<c015fd4b>] trace_hardirqs_off+0xb/0x10
softirqs last  enabled at (2688): [<c018638d>] rcu_torture_writer+0x9d/0x180
softirqs last disabled at (2719): [<c05d54b4>] _spin_lock_bh+0x14/0x80
PASSED
initcall init_irqsoff_tracer+0x0/0x30 returned 0 after 362 msecs
calling  init_wakeup_tracer+0x0/0x10
Testing tracer wakeup: PASSED
initcall init_wakeup_tracer+0x0/0x10 returned 0 after 333 msecs
calling  init_mmio_trace+0x0/0x10
initcall init_mmio_trace+0x0/0x10 returned 0 after 0 msecs


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
