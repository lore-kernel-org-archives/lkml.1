Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYGWUXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYGWUXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYGWUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:23:28 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:55775 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGWUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rz27NhJuBTpiEcyM9DgkDlvcDrjtG0+hY/n96CYjdngyuxazVAn8O10sODbFnHm/Rr
         pzpMZK1wHv+W03FOeIW5VqLADlX7HBsGx9y7n+8iJd5wLuMpxQhj28x2lqRTP1ytgS9X
         rWXRyOMACDdCBvA7mzAoD7AA6iHdIgg+sOnRE=
Message-ID: <19f34abd0807231323g2ad85760v2a289b6fd0602cb1@mail.gmail.com>
Date: Wed, 23 Jul 2008 22:23:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> I just got this on c010b2f76c3032e48097a6eef291d8593d5d79a6 (-git from
> yesterday):
>
> BUG: unable to handle kernel paging request at 00664381
> IP: [<c010b274>] free_thread_xstate+0x4/0x30
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 4, comm: ksoftirqd/0 Not tainted (2.6.26-06077-gc010b2f #100)
> EIP: 0060:[<c010b274>] EFLAGS: 00010246 CPU: 0
> EIP is at free_thread_xstate+0x4/0x30
> EAX: 00664001 EBX: f21e0000 ECX: 00000000 EDX: f7872fd0
> ESI: f221df38 EDI: c0833d00 EBP: f7889f4c ESP: f7889f48
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process ksoftirqd/0 (pid: 4, ti=f7888000 task=f7872fd0 task.ti=f7888000)
> Stack: f21e0000 f7889f58 c010b2ad f221cfb0 f7889f64 c01352c9 f221cfb0 f7889f70
>       c0136713 f2b506cc f7889f78 c0138ea7 f7889f90 c01790ff 00000282 c0785aa0
>       00000001 0000000a f7889fac c013cad2 c0838c00 c0838c00 c0838c00 00000246
> Call Trace:
>  [<c010b2ad>] ? free_thread_info+0xd/0x20
>  [<c01352c9>] ? free_task+0x19/0x30
>  [<c0136713>] ? __put_task_struct+0x53/0xb0
>  [<c0138ea7>] ? delayed_put_task_struct+0x27/0x30
>  [<c01790ff>] ? rcu_process_callbacks+0x6f/0xb0
>  [<c013cad2>] ? __do_softirq+0x92/0x110
>  [<c013cbf5>] ? do_softirq+0xa5/0xb0
>  [<c013cc76>] ? ksoftirqd+0x76/0x180
>  [<c013cc00>] ? ksoftirqd+0x0/0x180
>  [<c014befc>] ? kthread+0x3c/0x70
>  [<c014bec0>] ? kthread+0x0/0x70
>  [<c0104d8b>] ? kernel_thread_helper+0x7/0x1c
>  =======================
> Code: 04 00 00 00 00 c7 04 24 00 00 04 00 e8 46 84 09 00 a3 dc 07 84 c0 c9 c3 eb
>  0d 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 53 <8b> 90 80 03 00 00 89 c3
>  85 d2 74 14 a1 dc 07 84 c0 e8 c6 88 09
> EIP: [<c010b274>] free_thread_xstate+0x4/0x30 SS:ESP 0068:f7889f48
> Kernel panic - not syncing: Fatal exception in interrupt
>
> EIP is at arch/x86/kernel/process.c:36:
>
>        if (tsk->thread.xstate) {
>
> This looks related to the recent floating-point changes and maybe RCU,
> adding Ccs.
>
> It seems quite reproducible, so I'll give it a shot with the latest
> -git as well.

Don't know if it's related, but I got this on the same kernel:

BUG: unable to handle kernel paging request at c0817fac
IP: [<c0135bcc>] copy_process+0x8ec/0x1130
*pde = 3780e163 *pte = 00817162
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 1280, comm: udevd Not tainted (2.6.26-06077-gc010b2f #100)
EIP: 0060:[<c0135bcc>] EFLAGS: 00210086 CPU: 1
EIP is at copy_process+0x8ec/0x1130
EAX: ffffffff EBX: f799a224 ECX: 00000000 EDX: 00450008
ESI: f7999fe0 EDI: 00000000 EBP: f6f4bf44 ESP: f6f4bf08
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process udevd (pid: 1280, ti=f6f4a000 task=f6d41fe0 task.ti=f6f4a000)
Stack: 00000000 f7999fe0 f6f4bfb8 f7999fe0 f6f4bfb8 bf96c708 01200011 f799a1e4
       00000000 f7918400 00000000 00000000 00000000 f6f4bfb8 01200011 f6f4bf9c
       c013646d 00000000 b7e65938 f78b6900 bf96c708 00000000 f6c98900 f6f4bf9c
Call Trace:
 [<c013646d>] ? do_fork+0x5d/0x2b0
 [<c0191571>] ? do_munmap+0x1e1/0x240
 [<c01024af>] ? sys_clone+0x2f/0x40
 [<c010404f>] ? sysenter_past_esp+0x78/0xc5
 =======================
Code: 00 00 64 a1 00 70 7e c0 8b 80 70 01 00 00 89 86 70 01 00 00 8b 46 04 8b 50
 10 0f a3 96 8c 01 00 00 19 c0 85 c0 0f 84 db 07 00 00 <0f> a3 15 ac df 78 c0 19
 c0 85 c0 0f 84 ca 07 00 00 f7 45 dc 00
EIP: [<c0135bcc>] copy_process+0x8ec/0x1130 SS:ESP 0068:f6f4bf08
---[ end trace 11ce0863bd4ff64d ]---
note: udevd[1280] exited with preempt_count 1

$ addr2line -e vmlinux -i c0135bcc
include/asm/bitops.h:305
kernel/fork.c:1151

Seems to be this block (first line):

        if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
                        !cpu_online(task_cpu(p))))
                set_task_cpu(p, smp_processor_id());


My test is basically stressing the network and running CPU hotplug at
the same time.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
