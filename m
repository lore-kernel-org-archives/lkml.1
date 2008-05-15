Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbYEOKTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbYEOKTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYEOKTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:19:39 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39721
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbYEOKTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:19:38 -0400
Message-ID: <482C0E35.9000708@qumranet.com>
Date: Thu, 15 May 2008 13:19:33 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [BUG] cpu hotplug vs scheduler
References: <4829A6A0.5040208@qumranet.com>	 <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com>	 <482ADB69.8010305@qumranet.com> <b647ffbd0805140605j5ed43b73t557983ece879c552@mail.gmail.com>
In-Reply-To: <b647ffbd0805140605j5ed43b73t557983ece879c552@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2008/5/14 Avi Kivity <avi@qumranet.com>:
>
>   
>> [ ... ]
>>
>>  [4302727.900184] Call Trace:
>>  [4302727.900184]  [<ffffffff803249de>] spin_bug+0x9e/0xe9
>>  [4302727.900184]  [<ffffffff80324af4>] _raw_spin_lock+0x41/0x123
>>  [4302727.900184]  [<ffffffff80439638>] _spin_lock_irqsave+0x2f/0x37
>>  [4302727.900184]  [<ffffffff8022ef7c>] print_cfs_rq+0xca/0x46a
>>  [4302727.900184]  [<ffffffff80231f97>] sched_debug_show+0x7a3/0xb8c
>>  [4302727.900184]  [<ffffffff8023238d>] sysrq_sched_debug_show+0xd/0xf
>>  [4302727.900184]  [<ffffffff802323ee>] pick_next_task_fair+0x5f/0x86
>>     
>
>
> Err... sorry for the broken patch. The patch below on top of the
> previous one should address this issue (ugly, but should be ok for
> debugging).
> 'tasklist_lock' shouldn't cause a double lock, I guess.
>
> Sorry for rather 'blind' attempts. If no, then I'll
> prepare/test/take-a-closer-look at it later today when I'm at home.
>
>   

Now it died when allocating the pda:

[4301986.526627] Booting processor 1/6 ip 6000
[4301986.537195] swapper: page allocation failure. order:2, mode:0x20
[4301986.537195] Pid: 0, comm: swapper Not tainted 2.6.26-rc2 #728
[4301986.537195]
[4301986.537195] Call Trace:
[4301986.537195]  [<ffffffff802388ae>] ? __printk_ratelimit+0x9/0xb
[4301986.537195]  [<ffffffff80272e07>] __alloc_pages_internal+0x387/0x39f
[4301986.537195]  [<ffffffff80272e35>] __alloc_pages+0xb/0xd
[4301986.537195]  [<ffffffff80272e4c>] __get_free_pages+0x15/0x46
[4301986.537195]  [<ffffffff80210cdf>] pda_init+0x87/0xac
[4301986.537195]  [<ffffffff8042fed1>] cpu_init+0x5e/0x34a
[4301986.537195]  [<ffffffff8026b437>] ? rcu_needs_cpu+0x36/0x47
[4301986.537195]  [<ffffffff802311a7>] ? idle_task_exit+0x71/0xad
[4301986.537195]  [<ffffffff804331aa>] start_secondary+0xc/0x178
[4301986.537195]
[4301986.537195] Mem-info:
[4301986.537195] DMA per-cpu:
[4301986.537195] CPU    0: hi:    0, btch:   1 usd:   0
[4301986.537195] CPU    2: hi:    0, btch:   1 usd:   0
[4301986.537195] DMA32 per-cpu:
[4301986.537195] CPU    0: hi:  186, btch:  31 usd: 153
[4301986.537195] CPU    2: hi:  186, btch:  31 usd: 135
[4301986.537195] Active:347879 inactive:109278 dirty:107 writeback:0 
unstable:0
[4301986.537195]  free:5311 slab:10186 mapped:30496 pagetables:1587 bounce:0
[4301986.537195] DMA free:8012kB min:24kB low:28kB high:36kB active:60kB 
inactive:0kB present:8644kB pages_scanned:0 all_unreclaimable? no
[4301986.537195] lowmem_reserve[]: 0 1999 1999 1999
[4301986.537195] DMA32 free:13232kB min:5704kB low:7128kB high:8556kB 
active:1391456kB inactive:437112kB present:2047248kB pages_scanned:0 
all_unreclaimable? no
[4301986.537195] lowmem_reserve[]: 0 0 0 0
[4301986.537195] DMA: 19*4kB 16*8kB 10*16kB 11*32kB 6*64kB 4*128kB 
1*256kB 2*512kB 3*1024kB 1*2048kB 0*4096kB = 8012kB
[4301986.537195] DMA32: 2034*4kB 570*8kB 1*16kB 0*32kB 0*64kB 0*128kB 
0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 13224kB
[4301986.537195] 212750 total pagecache pages
[4301986.537195] Swap cache: add 73, delete 18, find 0/0
[4301986.537195] Free swap  = 3210964kB
[4301986.537195] Total swap = 3211256kB

There seem to be some order-2 allocations available, though.  And in any 
case, cpu hotplug should't crash on such failures, only fail.

-- 
error compiling committee.c: too many arguments to function

