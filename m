Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXELGLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXELGLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXELGLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:11:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXELGLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:11:00 -0400
Message-ID: <46455A67.8040203@redhat.com>
Date: Fri, 11 May 2007 23:10:47 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pierre Peiffer <pierre.peiffer@bull.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: FUTEX_CMP_REQUEUE_PI is not quite there
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I hooked up FUTEX_CMP_REQUEUE_PI here and got a kernel crash.  No serial 
console so this is the output of the screen after the machine stopped.

This is of course on x86-64.  Compiled from a rawhide-ified upstream 
kernel from two days ago.

The situation is the we requeue from a non-PI futex to a PI futex.  We 
might now actually want to change the condvar implementation to use
internally a PI futex if the mutex in use is PI, too, but this kind of 
mismatch can still happen.  I can provide binaries if necessary.


There is quite a lot of output from the kernel:

BUG: at kernel/futex.c:1665 set_pi_futex_owner()

Call Trace:
  [<ffffffff80249eee>] futex_lock_pi+0x351/0x685
  [<ffffffff8043b3cb>] _spin_lock_irqsave+0x9/0xe
  [<ffffffff803089ac>] __up_read+0x19/0x7f
  [<ffffffff8022ca81>] default_wake_function+0x0/0xe
  [<ffffffff8024b475>] do_futex+0xa68/0x10e8
  [<ffffffff8024bbe3>] sys_futex+0xee/0x10c
  [<ffffffff8043b399>] _spin_unlock_irq+0x9/0xc
  [<ffffffff80209b9e>] system_call+0x7e/0x83

BUG: at lib/plist.c:78 plist_add()

Call Trace:
  [<ffffffff8030c812>] plist_add+0x3a/0x90
  [<ffffffff80249f24>] futex_lock_pi+0x387/0x685
  [<ffffffff8043b3cb>] _spin_lock_irqsave+0x9/0xe
  [<ffffffff803089ac>] __up_read+0x19/0x7f
  [<ffffffff8022ca81>] default_wake_function+0x0/0xe
  [<ffffffff8024b475>] do_futex+0xa68/0x10e8
  [<ffffffff8024bbe3>] sys_futex+0xee/0x10c
  [<ffffffff8043b399>] _spin_unlock_irq+0x9/0xc
  [<ffffffff80209b9e>] system_call+0x7e/0x83

BUG: at kernel/futex.c:483 exit_pi_state_list()

Call Trace:
  [<ffffffff8024be47>] exit_pi_state_list+0xbe/0x11e
  [<ffffffff80235aad>] do_exit+0x801/0x84e
  [<ffffffff80235b97>] complete_and_exit+0x0/0x16
  [<ffffffff80209b9e>] system_call+0x7e/0x83

list_add corruption. prev->next should be next (ffff81001dda1cb8), but 
was ffff81006c 6e06c8. (prev=ffff81006c6e06c8).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:33!
invalid opcode: 0000 [1] SMP
CPU 0
Pid: 15097, comm: ld-linux-x86-64 Not tainted 2.6.21-1.3145.fc7 #1
RIP: 0010:[<ffffffff8030c90a>]  [<ffffffff8030c90a>] __list_add+0x47/0x5b
RSP: 0018:ffff81003cc01e78  EFLAGS: 00010092
RAX: 0000000000000079 RBX: ffff81001dda1cb8 RCX: fffffffffffffca9
RDX: 00000000ffffffff RSI: 0000000000000282 RDI: ffffffff80559a50
RBP: ffff81001dda1cb0 R08: 00000000000000a0 R09: 0000000000000010
R10: ffff81000305dd00 R11: 0000000000000000 R12: ffff81001dda1c88
R13: 0000000000000282 R14: ffff81006c6e0080 R15: ffff810075edac78
FS:  0000000000000000(0000) GS:ffffffff8059e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000040400eb8 CR3: 000000001c40f000 CR4: 00000000000026e0
Process ld-linux-x86-64 (pid: 15097, threadinfo ffff81003cc00000, task 
ffff81006c6e00

Stack:  ffff81006c6e06b0 ffffffff8030c7a2 ffff81006c6e07b0 ffff810075edac50
  ffff81006c6e06b0 ffffffff8043ac19 ffff81006c6e06b0 ffff810075edac40
  ffff81006c6e06b0 ffffffff8070f9f0 ffff81006c6e07b0 ffff81006c6e0080
Call Trace:
  [<ffffffff8030c7a2>] plist_del+0x3a/0x70
  [<ffffffff8043ac19>] rt_mutex_slowunlock+0x8c/0x1cd
  [<ffffffff8024be75>] exit_pi_state_list+0xec/0x11e
  [<ffffffff80235aad>] do_exit+0x801/0x84e
  [<ffffffff80235b97>] complete_and_exit+0x0/0x16
  [<ffffffff80209b9e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 48 89 7e 08 48 89 37 48 89 57 08 48 89 3a 5a c3
RIP  [<ffffffff8030c90a>] __list_add+0x47/0x5b
  RSP <ffff81003cc01e78>

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
