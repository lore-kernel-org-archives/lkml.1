Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYGJNdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYGJNdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbYGJNdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:33:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:27815 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbYGJNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p349DTy5yoaxFeISSWbWcPPzOUiFFnw4PuYq5PBhPZj11fztTbP7eutLAlJX2jLd8/
         7M+aZWingsuu0f6Y6iEDdfL46W73oo+gEoiCFQuzoTAWPR5UC3DmR+z5zChr28U97cBX
         0jNiF5P+u1Oh6G/yUDxSu0Iaty4aB7ojSpJnw=
Message-ID: <19f34abd0807100633q632095b7k7635032d5fd21bc5@mail.gmail.com>
Date: Thu, 10 Jul 2008 15:33:30 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <19f34abd0807100617m10338f97ic6fa7e74ddf2ac80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <19f34abd0807100617m10338f97ic6fa7e74ddf2ac80@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 3:17 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Jul 10, 2008 at 3:04 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> Does a patch from Miao Xie available via the link below makes this
>>> problem disappear? Both bugs are likely to have the same cause.
>>>
>>> http://lkml.org/lkml/2008/7/7/75
>>
>> Yep, it does, nice, thanks!
>
> I got something else now though:
>
> Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 19762, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
> EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
> EIP is at kmem_cache_alloc+0xc7/0xe0

$ addr2line -e vmlinux -i c01991c7
include/asm/string_32.h:183
mm/slub.c:1646

For reference, the disassembly:
c01991c7:       f3 ab                   rep stos %eax,%es:(%edi)

and registers in question:

ESI: 00200282 EDI: f6c44000 EBP: e7c2befc ESP: e7c2bedc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068


...though yet another run gets me this:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<00000000>]
*pde = 00000000
Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 3883, comm: cat Tainted: G      D   (2.6.26-rc9-00059-gb190333 #5)
EIP: 0060:[<00000000>] EFLAGS: 00210286 CPU: 0
EIP is at 0x0
EAX: f7890400 EBX: 00000000 ECX: 00000102 EDX: 0175d000
ESI: f7890400 EDI: c07feda0 EBP: f0461e6c ESP: f0461e58
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 3883, ti=f0460000 task=f1891fe0 task.ti=f0460000)
Stack: c0172d0c 00200296 c0752b40 00000001 0000000a f0461e88 c0139e03 c0803d00
       c0803d00 c0803d00 00200046 c0298720 f0461e98 c0139f25 c0803d00 00000000
       f0461ea4 c013a0c5 c1f12140 f0461ebc c011a4a8 c1f60f00 f0461f0c 00000000
Call Trace:
 [<c0172d0c>] ? rcu_process_callbacks+0x6c/0xb0
 [<c0139e03>] ? __do_softirq+0x83/0x100
 [<c0298720>] ? __rdmsr_safe_on_cpu+0x0/0x60
 [<c0139f25>] ? do_softirq+0xa5/0xb0
 [<c013a0c5>] ? irq_exit+0x95/0xa0
 [<c011a4a8>] ? smp_apic_timer_interrupt+0x58/0x90
 [<c01058a3>] ? apic_timer_interrupt+0x33/0x38
 [<c0298720>] ? __rdmsr_safe_on_cpu+0x0/0x60
 [<c01196e1>] ? smp_call_function_single+0x91/0xc0
 [<c029888f>] ? _rdmsr_on_cpu+0x2f/0x70
 [<c02988ea>] ? rdmsr_safe_on_cpu+0x1a/0x20
 [<c01179fe>] ? msr_read+0x6e/0xa0
 [<c019eec4>] ? vfs_read+0x94/0x130
 [<c0117990>] ? msr_read+0x0/0xa0
 [<c019f3ed>] ? sys_read+0x3d/0x70
 [<c0104ceb>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:f0461e58
Kernel panic - not syncing: Fatal exception in interrupt


:-)

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
