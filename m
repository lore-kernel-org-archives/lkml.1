Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbYBFUVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbYBFUVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbYBFUVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:21:17 -0500
Received: from 210.161.159.67.colorbroadband.com ([67.159.161.210]:50753 "EHLO
	sc-software.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbYBFUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:21:16 -0500
Date: Wed, 6 Feb 2008 12:21:44 -0800 (PST)
From: kerndev@sc-software.com
To: Hugh Dickins <hugh@veritas.com>
cc: linux-kernel@vger.kernel.org, John Heil <kerndev@sc-software.com>
Subject: Re: Bug: 2.6.24-smp: Eeek! page_mapcount(page) went negative! (-1)
In-Reply-To: <Pine.LNX.4.64.0802061948380.32204@blonde.site>
Message-ID: <Pine.LNX.4.64.0802061214550.4601@sc-software.com>
References: <Pine.LNX.4.64.0802061003370.4601@sc-software.com>
 <Pine.LNX.4.64.0802061948380.32204@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Hugh Dickins wrote:

> Date: Wed, 6 Feb 2008 19:55:36 +0000 (GMT)
> From: Hugh Dickins <hugh@veritas.com>
> To: John Heil <kerndev@sc-software.com>
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Bug: 2.6.24-smp: Eeek! page_mapcount(page) went negative! (-1)
> 
> On Wed, 6 Feb 2008, kerndev@sc-software.com wrote:
>>
>> Before digging into this myself (don't really have enought time),
>> I thought I'd submit it here...
>
> Thanks for the report.
>
>> Feb  6 09:09:47 sc-software kernel: Eeek! page_mapcount(page) went negative!
>
> These very often turn out the be due to bad RAM or some such:
> worth running memtest86+ overnight when you can, though its
> success wouldn't be conclusive.
>
>> (-1)
>> Feb  6 09:09:47 sc-software kernel:   page pfn = 12b1b1
>> Feb  6 09:09:47 sc-software kernel:   page->flags = 80080014
>> Feb  6 09:09:47 sc-software kernel:   page->count = 0
>
> That's a free page which shouldn't have appeared in the pagetable.
> It could be that there's a bit error somewhere in that pfn of 12b1b1.
>
>> Feb  6 09:09:47 sc-software kernel:   page->mapping = 00000000
>> Feb  6 09:09:47 sc-software kernel:   vma->vm_ops = 0x0
>> Feb  6 09:09:47 sc-software kernel: ------------[ cut here ]------------
>> Feb  6 09:09:47 sc-software kernel: kernel BUG at mm/rmap.c:631!
>> Feb  6 09:09:47 sc-software kernel: invalid opcode: 0000 [#2] PREEMPT SMP
>> Feb  6 09:09:47 sc-software kernel: Modules linked in: shpchp pci_hotplug
>> ohci1394 ieee1394
>> Feb  6 09:09:47 sc-software kernel:
>> Feb  6 09:09:47 sc-software kernel: Pid: 3710, comm: X Tainted: G      D
>
> But that [#2] and that D taint both say there was already a problem
> before this: anything showing in the log for that?
>
> Hugh


>From reboot after last hang on 02/03/08, I found this...


Feb  5 23:26:26 sc-software kernel: ------------[ cut here ]------------
Feb  5 23:26:26 sc-software kernel: kernel BUG at mm/slab.c:591!
Feb  5 23:26:26 sc-software kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Feb  5 23:26:26 sc-software kernel: Modules linked in: shpchp pci_hotplug 
ohci1394 ieee1394
Feb  5 23:26:26 sc-software kernel:
Feb  5 23:26:26 sc-software kernel: Pid: 6040, comm: modprobe Not tainted 
(2.6.24 #1)
Feb  5 23:26:26 sc-software kernel: EIP: 0060:[<c017960f>] EFLAGS: 
00010046 CPU: 1
Feb  5 23:26:26 sc-software kernel: EIP is at kfree+0x8f/0xa0
Feb  5 23:26:26 sc-software kernel: EAX: 40000000 EBX: f5915380 ECX: 
c1bb4498 EDX: c1bb4498
Feb  5 23:26:26 sc-software kernel: ESI: eff354a0 EDI: f5815280 EBP: 
f0067e78 ESP: f0067e68
Feb  5 23:26:26 sc-software kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 
SS: 0068
Feb  5 23:26:26 sc-software kernel: Process modprobe (pid: 6040, 
ti=f0066000 task=f00b5550 task.ti=f0066000)
Feb  5 23:26:26 sc-software kernel: Stack: 00000282 f5915380 eff354a0 
b7fb87b0 f0067f1c c01ac9ac 00000003 00001812
Feb  5 23:26:26 sc-software kernel:        f0067e98 0805ba64 00000418 
0805ba64 f0067eb4 0805ba64 00001812 00000000
Feb  5 23:26:26 sc-software kernel:        f5815280 00000001 00000000 
0805be7c 0805ba64 0805aa64 08048000 00000000
Feb  5 23:26:26 sc-software kernel: Call Trace:
Feb  5 23:26:26 sc-software kernel:  [<c0103e5a>] 
show_trace_log_lvl+0x1a/0x30
Feb  5 23:26:26 sc-software kernel:  [<c0103f2a>] 
show_stack_log_lvl+0x9a/0xc0
Feb  5 23:26:26 sc-software kernel:  [<c01040d7>] 
show_registers+0xc7/0x250
Feb  5 23:26:26 sc-software kernel:  [<c010441f>] die+0x11f/0x220
Feb  5 23:26:26 sc-software kernel:  [<c01045b1>] do_trap+0x91/0xd0
Feb  5 23:26:26 sc-software kernel:  [<c0104859>] do_invalid_op+0x89/0xa0
Feb  5 23:26:26 sc-software kernel:  [<c0657c22>] error_code+0x72/0x78
Feb  5 23:26:26 sc-software kernel:  [<c01ac9ac>] 
load_elf_binary+0x8cc/0xcf0
Feb  5 23:26:26 sc-software kernel:  [<c0181864>] 
search_binary_handler+0xc4/0x250
Feb  5 23:26:26 sc-software kernel:  [<c0181b35>] do_execve+0x145/0x190
Feb  5 23:26:26 sc-software kernel:  [<c0101c82>] sys_execve+0x32/0xa0
Feb  5 23:26:26 sc-software kernel:  [<c0103102>] syscall_call+0x7/0xb
Feb  5 23:26:26 sc-software kernel:  =======================
Feb  5 23:26:26 sc-software kernel: Code: 47 1d 00 8b 1c 86 8b 03 3b 43 04 
73 11 89 7c 83 30 40 89 03 ff 75 f0 9d 58 5b 5e 5f 5d c3 89 f0 89 da e8 65 
fc ff ff 8b 03 eb e2 <0f> 0b eb fe 8b 51 0c eb b7 8b 4a 0c
eb a2 8d 76 00 55 89 e5 5d
Feb  5 23:26:26 sc-software kernel: EIP: [<c017960f>] kfree+0x8f/0xa0 
SS:ESP 0068:f0067e68
Feb  5 23:26:26 sc-software kernel: ---[ end trace 791c1b0a2eb87d50 ]---





> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

.
===========================================================
John Heil
South Coast Software
Custom firmware, device drivers and board bring up services
Ph: 1-714-774-6952
Fx: 1-714-774-7053
www.sc-software.com
email: johnhscs@sc-software.com
===========================================================

