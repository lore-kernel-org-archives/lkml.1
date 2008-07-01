Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYGAJY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYGAJY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYGAJYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:24:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59442 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbYGAJYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:24:49 -0400
Message-ID: <4869F770.6050103@cn.fujitsu.com>
Date: Tue, 01 Jul 2008 17:22:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
References: <20080619161949.GA11062@osiris.ibm.com> <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com> <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com> <20080630090744.GB6598@osiris.boeblingen.de.ibm.com> <20080630091711.GA26637@elte.hu>
In-Reply-To: <20080630091711.GA26637@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
>> On Sun, Jun 29, 2008 at 12:16:56AM +0200, Dmitry Adamushko wrote:
>>> Hello,
>>>
>>>
>>> it seems to be related to migrate_dead_tasks().
>>>
>>> Firstly I added traces to see all tasks being migrated with
>>> migrate_live_tasks() and migrate_dead_tasks(). On my setup the problem
>>> pops up (the one with "se == NULL" in the loop of
>>> pick_next_task_fair()) shortly after the traces indicate that some has
>>> been migrated with migrate_dead_tasks()). btw., I can reproduce it
>>> much faster now with just a plain cpu down/up loop.
>>>
>>> [disclaimer] Well, unless I'm really missing something important in
>>> this late hour [/desclaimer] pick_next_task() is not something
>>> appropriate for migrate_dead_tasks() :-)
>>>
>>> the following change seems to eliminate the problem on my setup
>>> (although, I kept it running only for a few minutes to get a few
>>> messages indicating migrate_dead_tasks() does move tasks and the
>>> system is still ok)
>>>
>>> [ quick hack ]
>>>
>>> @@ -5887,6 +5907,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
>>>                 next = pick_next_task(rq, rq->curr);
>>>                 if (!next)
>>>                         break;
>>> +               next->sched_class->put_prev_task(rq, next);
>>>                 migrate_dead(dead_cpu, next);
>>>
>>>         }
>> Thanks Dmitry! With your patch I cannot reproduce the bug anymore.
> 
> thanks - it passed my testing too. It's lined up for v2.6.26 merge, in 
> tip/sched/urgent.
> 
> Avi, does this patch fix your CPU hotplug problems too?
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 

Hi, Ingo

The following oops still occurred whether this patch is applied or not.

Lai Jiangshan


------------[ cut here ]------------
kernel BUG at kernel/sched.c:6133!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 4744, comm: cpu_online.sh Not tainted 2.6.26-rc8 #1
RIP: 0010:[<ffffffff8058d0a9>]  [<ffffffff8058d0a9>] migration_call+0x3eb/0x494
RSP: 0018:ffff81007115fd28  EFLAGS: 00010202
RAX: ffffffffffffffe3 RBX: ffff810001017580 RCX: 000000801b7c6e42
RDX: ffff81007115fcf8 RSI: 0000009388d2771c RDI: ffff810001017e00
RBP: ffff81007115fd78 R08: ffff81007115e000 R09: ffff8100807d6000
R10: ffff81007fb6d050 R11: 00000000ffffffff R12: 0000000000000283
R13: ffff810001029580 R14: ffff810001029580 R15: 0000000000000002
FS:  00007fbb153d36f0(0000) GS:ffffffff807a3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fabafe2b0a8 CR3: 0000000076901000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cpu_online.sh (pid: 4744, threadinfo ffff81007115e000, task ffff810071447200)
Stack:  ffff81007115e000 000000007115fbd8 00000000ffffffff 0000000000000002
 ffff81007115fd78 0000000000000000 00000000ffffffff ffffffff807a1d40
 0000000000000002 0000000000000007 ffff81007115fdb8 ffffffff8059372c
Call Trace:
 [<ffffffff8059372c>] notifier_call_chain+0x33/0x5b
 [<ffffffff802476a9>] __raw_notifier_call_chain+0x9/0xb
 [<ffffffff802476ba>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff805736d6>] _cpu_down+0x191/0x256
 [<ffffffff805737c1>] cpu_down+0x26/0x36
 [<ffffffff805749c1>] store_online+0x32/0x75
 [<ffffffff803d1982>] sysdev_store+0x24/0x26
 [<ffffffff802d2551>] sysfs_write_file+0xe0/0x11c
 [<ffffffff80290e6b>] vfs_write+0xae/0x137
 [<ffffffff802913d3>] sys_write+0x47/0x70
 [<ffffffff8020b1eb>] system_call_after_swapgs+0x7b/0x80


Code: 80 07 00 00 48 01 83 80 07 00 00 49 c7 85 80 07 00 00 00 00 00 00 41 fe 45 00 49 39 dd 74 02 fe 03 41 54 9d 49 83 7d 08 00 74 04 <0f> 0b eb fe 4c 89 ef e8 b8 40 00 00 eb 1e 48 8b 11 48 8b 41 08
RIP  [<ffffffff8058d0a9>] migration_call+0x3eb/0x494
 RSP <ffff81007115fd28>
---[ end trace f22fd757d4f07850 ]---

platform: x86_64 2cores*2cpus fedora9
# cat cpu_online.sh
#!/bin/sh

cpu1=1
cpu2=1
cpu3=1
while ((1))
do
        no=$(($RANDOM % 3 + 1))
        if ((!cpu$no))
        then
                echo 1 > /sys/devices/system/cpu/cpu$no/online
                ((cpu$no=1))
        else
                echo 0 > /sys/devices/system/cpu/cpu$no/online
                ((cpu$no=0))
        fi
        echo 1 $cpu1 $cpu2 $cpu3
        sleep 2
done


