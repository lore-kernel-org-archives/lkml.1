Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbYESIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbYESIXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbYESIW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:22:58 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43146 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbYESIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:22:55 -0400
Message-ID: <483138EC.6090600@bull.net>
Date: Mon, 19 May 2008 10:23:08 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>, kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than
 120 seconds
References: <4821AD2D.8020001@linux.vnet.ibm.com> <20080507134057.GA30637@cs181133002.pp.htv.fi> <48227AAB.9000309@linux.vnet.ibm.com> <482C1ED8.3030508@bull.net> <482D999D.5090408@linux.vnet.ibm.com>
In-Reply-To: <482D999D.5090408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Nadia Derbey wrote:
> 
>>Kamalesh Babulal wrote:
>>
>>>Adrian Bunk wrote:
>>>
>>>
>>>>On Wed, May 07, 2008 at 06:52:53PM +0530, Kamalesh Babulal wrote:
>>>>
>>>>
>>>>>While running the ltp over the powerpc with the 2.6.26-rc1-git4 kernel,
>>>>>task get blocked for more 120 seconds and does not proceeds future.
>>>>>
>>>>>The task msgctl08 is a ipc testcase, which test the msgget(2) msgctl(2)
>>>>>syscalls.
>>>>
>>>>Thanks for your report.
>>>>
>>>>I assume this is reproducible?
>>>>
>>>>If yes, what was the last kernel that worked for you?
>>>
>>>This is reproducible on 2.6.26-rc1 and 2.6.26-rc1-git(s). 2.6.25 is the last know kernel
>>>to work.
>>>
>>>
>>>
>>>>I've also added Pierre Peiffer and Nadia Derbey to the Cc since their 
>>>>recent ipc commits are my first suspects.
>>>>
>>>>
>>>>
>>>>>Machine is stuck in the task, printing the following call trace
>>>>>more than 5000 times. The oom-killer invoked once in-between.
>>>>>
>>>>>INFO: task msgctl08:16248 blocked for more than 120 seconds.
>>>>>"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>>Call Trace:
>>>>>[c0000000762435a0] [0000000000000001] 0x1 (unreliable)
>>>>>[c000000076243770] [c000000000010acc] .__switch_to+0x128/0x16c
>>>>>[c000000076243800] [c0000000004b07a4] .schedule+0x7ac/0x890
>>>>>[c0000000762438f0] [c0000000004b2ba4] .rwsem_down_failed_common+0x260/0x2b0
>>>>>[c0000000762439b0] [c0000000004b2c60] .rwsem_down_read_failed+0x2c/0x44
>>>>>[c000000076243a60] [c0000000004b1b84] .down_read+0x44/0x5c
>>>>>[c000000076243af0] [c000000000295e10] .ipc_lock+0x34/0xe0
>>>>>[c000000076243b90] [c00000000029690c] .ipc_lock_check+0x24/0x78
>>>>>[c000000076243c20] [c0000000002972c0] .do_msgsnd+0xb0/0x3f8
>>>>>[c000000076243d10] [c000000000293ce8] .compat_sys_msgsnd+0x94/0xc0
>>>>>[c000000076243db0] [c000000000014418] .compat_sys_ipc+0x130/0x1f4
>>>>>[c000000076243e30] [c000000000008734] syscall_exit+0x0/0x40
>>>>>msgctl08 invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
>>>>>Call Trace:
>>>>>[c00000001e1c7640] [c0000000000101bc] .show_stack+0x70/0x1bc (unreliable)
>>>>>[c00000001e1c76f0] [c0000000000c2c78] .oom_kill_process+0x78/0x230
>>>>>[c00000001e1c77a0] [c0000000000c3390] .out_of_memory+0x28c/0x320
>>>>>[c00000001e1c7870] [c0000000000c70ac] .__alloc_pages_internal+0x364/0x468
>>>>>[c00000001e1c7980] [c0000000000e83cc] .alloc_page_vma+0x120/0x14c
>>>>>[c00000001e1c7a20] [c0000000000e0224] .read_swap_cache_async+0x7c/0x160
>>>>>[c00000001e1c7ae0] [c0000000000e035c] .swapin_readahead+0x54/0xd4
>>>>>[c00000001e1c7ba0] [c0000000000d47e8] .handle_mm_fault+0x520/0x9d8
>>>>>[c00000001e1c7c80] [c0000000004b5054] .do_page_fault+0x440/0x624
>>>>>[c00000001e1c7e30] [c0000000000053fc] handle_page_fault+0x20/0x5c
>>>>>Mem-info:
>>>>>Node 0 DMA per-cpu:
>>>>>CPU    0: hi:    6, btch:   1 usd:   1
>>>>>CPU    1: hi:    6, btch:   1 usd:   1
>>>>>Node 1 DMA per-cpu:
>>>>>CPU    0: hi:    6, btch:   1 usd:   5
>>>>>CPU    1: hi:    6, btch:   1 usd:   5
>>>>>Active:31 inactive:2628 dirty:1 writeback:6 unstable:0
>>>>>free:156 slab:13071 mapped:548 pagetables:41109 bounce:0
>>>>>Node 0 DMA free:5312kB min:5760kB low:7168kB high:8640kB active:1024kB inactive:768kB present:3928832kB pages_scanned:3912 all_unreclaimable? no
>>>>>lowmem_reserve[]: 0 0 0
>>>>>Node 1 DMA free:4672kB min:4992kB low:6208kB high:7488kB active:960kB inactive:169792kB present:3404992kB pages_scanned:140140 all_unreclaimable? no
>>>>>lowmem_reserve[]: 0 0 0
>>>>>Node 0 DMA: 5*64kB 15*128kB 2*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB 0*8192kB 0*16384kB = 5312kB
>>>>>Node 1 DMA: 8*64kB 5*128kB 6*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB 0*8192kB 0*16384kB = 4736kB
>>>>>8185 total pagecache pages
>>>>>Swap cache: add 29545, delete 21888, find 5602/10373
>>>>>Free swap  = 803712kB
>>>>>Total swap = 2048128kB
>>>>>114688 pages of RAM
>>>>>766 reserved pages
>>>>>231218 pages shared
>>>>>7657 pages swap cached
>>>>>Out of memory: kill process 15371 (msgctl08) score 39223 or a child
>>>>>Killed process 15373 (msgctl08)
>>>>>INFO: task msgctl08:15385 blocked for more than 120 seconds.
>>>>>"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>>Call Trace:
>>>>>[c0000000e9a43290] [0000000000000001] 0x1 (unreliable)
>>>>>[c0000000e9a43460] [c000000000010acc] .__switch_to+0x128/0x16c
>>>>>[c0000000e9a434f0] [c0000000004b07a4] .schedule+0x7ac/0x890
>>>>>[c0000000e9a435e0] [c0000000004b0d90] .io_schedule+0x7c/0xe8
>>>>>[c0000000e9a43670] [c0000000002d7f44] .get_request_wait+0x15c/0x1e0
>>>>>[c0000000e9a43750] [c0000000002d8950] .__make_request+0x3ec/0x4d8
>>>>>[c0000000e9a43800] [c0000000002d6624] .generic_make_request+0x35c/0x3b0
>>>>>[c0000000e9a438e0] [c0000000002d81b0] .submit_bio+0x118/0x140
>>>>>[c0000000e9a439a0] [c0000000000dfa88] .swap_readpage+0x94/0xb4
>>>>>[c0000000e9a43a20] [c0000000000e02b8] .read_swap_cache_async+0x110/0x160
>>>>>[c0000000e9a43ae0] [c0000000000e035c] .swapin_readahead+0x54/0xd4
>>>>>[c0000000e9a43ba0] [c0000000000d47e8] .handle_mm_fault+0x520/0x9d8
>>>>>[c0000000e9a43c80] [c0000000004b5054] .do_page_fault+0x440/0x624
>>>>>[c0000000e9a43e30] [c0000000000053fc] handle_page_fault+0x20/0x5c
>>>>>INFO: task msgctl08:15405 blocked for more than 120 seconds.
>>>>>"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>>Call Trace:
>>>>>[c0000000b1757290] [0000000000000001] 0x1 (unreliable)
>>>>>[c0000000b1757460] [c000000000010acc] .__switch_to+0x128/0x16c
>>>>>[c0000000b17574f0] [c0000000004b07a4] .schedule+0x7ac/0x890
>>>>>[c0000000b17575e0] [c0000000004b0d90] .io_schedule+0x7c/0xe8
>>>>>[c0000000b1757670] [c0000000002d7f44] .get_request_wait+0x15c/0x1e0
>>>>>[c0000000b1757750] [c0000000002d8950] .__make_request+0x3ec/0x4d8
>>>>>[c0000000b1757800] [c0000000002d6624] .generic_make_request+0x35c/0x3b0
>>>>>[c0000000b17578e0] [c0000000002d81b0] .submit_bio+0x118/0x140
>>>>>[c0000000b17579a0] [c0000000000dfa88] .swap_readpage+0x94/0xb4
>>>>>[c0000000b1757a20] [c0000000000e02b8] .read_swap_cache_async+0x110/0x160
>>>>>[c0000000b1757ae0] [c0000000000e035c] .swapin_readahead+0x54/0xd4
>>>>>[c0000000b1757ba0] [c0000000000d47e8] .handle_mm_fault+0x520/0x9d8
>>>>>[c0000000b1757c80] [c0000000004b5054] .do_page_fault+0x440/0x624
>>>>>[c0000000b1757e30] [c0000000000053fc] handle_page_fault+0x20/0x5c
>>>>>INFO: task msgctl08:15406 blocked for more than 120 seconds.
>>>>>"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>>Call Trace:
>>>>>[c0000000eec53290] [0000000000000001] 0x1 (unreliable)
>>>>>[c0000000eec53460] [c000000000010acc] .__switch_to+0x128/0x16c
>>>>>[c0000000eec534f0] [c0000000004b07a4] .schedule+0x7ac/0x890
>>>>>[c0000000eec535e0] [c0000000004b0d90] .io_schedule+0x7c/0xe8
>>>>>[c0000000eec53670] [c0000000002d7f44] .get_request_wait+0x15c/0x1e0
>>>>>[c0000000eec53750] [c0000000002d8950] .__make_request+0x3ec/0x4d8
>>>>>[c0000000eec53800] [c0000000002d6624] .generic_make_request+0x35c/0x3b0
>>>>>[c0000000eec538e0] [c0000000002d81b0] .submit_bio+0x118/0x140
>>>>>[c0000000eec539a0] [c0000000000dfa88] .swap_readpage+0x94/0xb4
>>>>>[c0000000eec53a20] [c0000000000e02b8] .read_swap_cache_async+0x110/0x160
>>>>>[c0000000eec53ae0] [c0000000000e035c] .swapin_readahead+0x54/0xd4
>>>>>[c0000000eec53ba0] [c0000000000d47e8] .handle_mm_fault+0x520/0x9d8
>>>>>[c0000000eec53c80] [c0000000004b5054] .do_page_fault+0x440/0x624
>>>>>[c0000000eec53e30] [c0000000000053fc] handle_page_fault+0x20/0x5c
>>
>>Kamalesh,
>>
>>I'm wondering whether this is not related to a problem found in LTP 
>>after msgmni had been changed from 16 to a computed value.
>>
>>Does your ltp test suite contain the patch I had sent in thread 
>>http://lkml.org/lkml/2008/2/21/123?
>>
>>If you want to have a look at it, discussion started in thread 
>>http://lkml.org/lkml/2008/2/16/6
>>
>>Regards,
>>Nadia
>>
> 
> Hi Nadia,
> Thanks, I am using the LTP-20080430 and tried it with the 2.6.26-rc2-git4 kernel.
> but the call trace remains the same.
> 

Ok, I'll try to find a ppc machine: could not reproduce it on my Xeon 
machine (but actually it was with a 2.6.26-rc1 kernel).

Regards,
Nadia

