Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYGWUHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYGWUHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYGWUHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:07:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:18123 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbYGWUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=efIjJWXIOwT5ZR9DjNyILNo3R+CKzy4UcGIO571Xdk4Kqxw0jPBDDA49bmD+VoSrcE
         qZmlsvQ8U7Guiu2xbr7ZeWRB+lQfA7BKosXmNgPjlAA+qEOe0GU1ZbV5NCXeK1+J2MX9
         qLchI/944+T9PjhlblLwH5Ai9QnEp6L6cU6l0=
Message-ID: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
Date: Wed, 23 Jul 2008 22:07:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>
Subject: recent -git: BUG in free_thread_xstate
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
yesterday):

BUG: unable to handle kernel paging request at 00664381
IP: [<c010b274>] free_thread_xstate+0x4/0x30
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 4, comm: ksoftirqd/0 Not tainted (2.6.26-06077-gc010b2f #100)
EIP: 0060:[<c010b274>] EFLAGS: 00010246 CPU: 0
EIP is at free_thread_xstate+0x4/0x30
EAX: 00664001 EBX: f21e0000 ECX: 00000000 EDX: f7872fd0
ESI: f221df38 EDI: c0833d00 EBP: f7889f4c ESP: f7889f48
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process ksoftirqd/0 (pid: 4, ti=f7888000 task=f7872fd0 task.ti=f7888000)
Stack: f21e0000 f7889f58 c010b2ad f221cfb0 f7889f64 c01352c9 f221cfb0 f7889f70
       c0136713 f2b506cc f7889f78 c0138ea7 f7889f90 c01790ff 00000282 c0785aa0
       00000001 0000000a f7889fac c013cad2 c0838c00 c0838c00 c0838c00 00000246
Call Trace:
 [<c010b2ad>] ? free_thread_info+0xd/0x20
 [<c01352c9>] ? free_task+0x19/0x30
 [<c0136713>] ? __put_task_struct+0x53/0xb0
 [<c0138ea7>] ? delayed_put_task_struct+0x27/0x30
 [<c01790ff>] ? rcu_process_callbacks+0x6f/0xb0
 [<c013cad2>] ? __do_softirq+0x92/0x110
 [<c013cbf5>] ? do_softirq+0xa5/0xb0
 [<c013cc76>] ? ksoftirqd+0x76/0x180
 [<c013cc00>] ? ksoftirqd+0x0/0x180
 [<c014befc>] ? kthread+0x3c/0x70
 [<c014bec0>] ? kthread+0x0/0x70
 [<c0104d8b>] ? kernel_thread_helper+0x7/0x1c
 =======================
Code: 04 00 00 00 00 c7 04 24 00 00 04 00 e8 46 84 09 00 a3 dc 07 84 c0 c9 c3 eb
 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 53 <8b> 90 80 03 00 00 89 c3
 85 d2 74 14 a1 dc 07 84 c0 e8 c6 88 09
EIP: [<c010b274>] free_thread_xstate+0x4/0x30 SS:ESP 0068:f7889f48
Kernel panic - not syncing: Fatal exception in interrupt

EIP is at arch/x86/kernel/process.c:36:

        if (tsk->thread.xstate) {

This looks related to the recent floating-point changes and maybe RCU,
adding Ccs.

It seems quite reproducible, so I'll give it a shot with the latest
-git as well.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
