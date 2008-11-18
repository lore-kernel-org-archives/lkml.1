Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYKRQHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYKRQHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYKRQHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:07:03 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:62339 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYKRQHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:07:00 -0500
Cc: linux-kernel Kernel <linux-kernel@vger.kernel.org>
Message-Id: <07E85AE1-3F9B-45A0-BBFF-22B8DAD54158@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <200811190303.00474.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: questions on how x86 uses IPI for tlb invalidates
Date: Tue, 18 Nov 2008 10:06:55 -0600
References: <6F2B69F5-7312-49AB-B86A-6AE6B753095B@freescale.com> <200811190244.52013.nickpiggin@yahoo.com.au> <7F4CB286-E739-4303-97FC-27AB7A202B25@freescale.com> <200811190303.00474.nickpiggin@yahoo.com.au>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 18, 2008, at 10:03 AM, Nick Piggin wrote:

> On Wednesday 19 November 2008 02:51, Kumar Gala wrote:
>> On Nov 18, 2008, at 9:44 AM, Nick Piggin wrote:
>>> On Wednesday 19 November 2008 02:20, Kumar Gala wrote:
>>>> I'm looking at adding some code into powerpc for doing tlb  
>>>> invalidate
>>>> broadcasts via IPI and am looking at the x86 code as a model.  I  
>>>> was
>>>> wondering how the x86 code ensures we aren't interrupted in the
>>>> process of doing something like flush_tlb_page().
>>>
>>> What's the problem with being interrupted?
>>
>> I'm in the middle of doing an invalidate, I get interrupted, in
>> processing the interrupt I cause another tlb invalidate while the
>> first one is still in progress and hasn't finished.
>>
>> For example I'm seeing in my code hacking:
>>
>> Freeing unused kernel memory: 208k init
>> BUG: soft lockup - CPU#1 stuck for 61s! [init:1]
>> Modules linked in:
>> NIP: c00649c4 LR: c00649a8 CTR: 00000000
>> REGS: ef82b750 TRAP: 0901   Not tainted  (2.6.28-rc5-00019-ge14c8bf-
>> dirty)
>> MSR: 00029000 <EE,ME>  CR: 44000428  XER: 00000000
>> TASK = ef830000[1] 'init' THREAD: ef82a000 CPU: 1
>> GPR00: 00000001 ef82b800 ef830000 c1002320 00029000 ef82b8f8 00000001
>> 00000000
>> GPR08: 00000002 00000001 00000000 00029000 84000422
>> NIP [c00649c4] generic_exec_single+0x84/0xb0
>> LR [c00649a8] generic_exec_single+0x68/0xb0
>> Call Trace:
>> [ef82b800] [c02f4084] dev_hard_start_xmit+0x324/0x3c0 (unreliable)
>> [ef82b830] [c0064afc] smp_call_function_single+0xdc/0x110
>> [ef82b870] [c0064ce8] smp_call_function_mask+0x1b8/0x250
>> [ef82b8f0] [c0015468] flush_tlb_page+0xa8/0xc0
>> [ef82b920] [c03a599c] xdr_partial_copy_from_skb+0x20c/0x2f0
>> [ef82b970] [c03a5ae8] csum_partial_copy_to_xdr+0x68/0x170
>> [ef82b990] [c03a8d60] xs_udp_data_ready+0x100/0x250
>> [ef82b9d0] [c02e8308] sock_queue_rcv_skb+0xf8/0x120
>> [ef82b9f0] [c033766c] __udp_queue_rcv_skb+0x1c/0x110
>> [ef82ba00] [c033897c] udp_queue_rcv_skb+0x28c/0x2e0
>> [ef82ba20] [c0338bf0] __udp4_lib_rcv+0x220/0x890
>> [ef82ba80] [c03136b0] ip_local_deliver+0xa0/0x240
>> [ef82baa0] [c03133ec] ip_rcv+0x3bc/0x5e0
>> [ef82bae0] [c02f3754] netif_receive_skb+0x284/0x310
>> [ef82bb10] [c0219c98] gfar_clean_rx_ring+0xd8/0x430
>> [ef82bb50] [c021a080] gfar_poll+0x90/0x170
>> [ef82bb70] [c02f1374] net_rx_action+0x104/0x200
>> [ef82bbc0] [c004166c] __do_softirq+0xbc/0x180
>> [ef82bc00] [c0004dc4] do_softirq+0x64/0x70
>> [ef82bc10] [c00410f4] irq_exit+0x54/0x70
>> [ef82bc20] [c0004f1c] do_IRQ+0x8c/0x140
>> [ef82bc40] [c00109cc] ret_from_except+0x0/0x18
>> [ef82bd00] [c0510e78] per_cpu____irq_regs+0x0/0x4
>> [ef82bd30] [c0064afc] smp_call_function_single+0xdc/0x110
>> [ef82bd70] [c0064ce8] smp_call_function_mask+0x1b8/0x250
>> [ef82bdf0] [c0015468] flush_tlb_page+0xa8/0xc0
>> [ef82be20] [c008c60c] handle_mm_fault+0x70c/0xa80
>> [ef82be80] [c0013df4] do_page_fault+0x274/0x510
>> [ef82bf40] [c00107b4] handle_page_fault+0xc/0x80
>> Instruction dump:
>> 913f0004 7c641b78 7f43d378 93e90000 4836226d 7c0004ac 7f9cc800  
>> 419e0030
>> 73c00001 40820008 48000010 a01f0010 <70090001> 4082fff8 80010034
>> bb010010
>
> You can't do the broadcast TLB invalidates in kunmap_atomic.
> All that's needed in that case is to just invalidate the local
> CPU.

Agreed, I was planning on fixing that.  I guess the high level  
question is if a broadcast invalidate can occur in soft or hard irq  
context.

- k
