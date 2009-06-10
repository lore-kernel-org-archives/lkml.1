Return-Path: <linux-kernel-owner+w=401wt.eu-S1761681AbZFJVCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761681AbZFJVCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761545AbZFJVB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:01:59 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38013 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189AbZFJVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:01:58 -0400
Message-ID: <4A301E3A.8020603@cs.helsinki.fi>
Date: Wed, 10 Jun 2009 23:57:30 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org, hannes@cmpxchg.org,
       mpm@selenic.com, npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <20090610210026.GA2346@elte.hu>
In-Reply-To: <20090610210026.GA2346@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> Hi Linus,
>>
>> Here are the core patches for enabling slab before the scheduler initializes
>> itself in the boot sequence. I added slab fallback support to the bootmem
>> allocator so that we don't need a flag day for switching to early slab.
>>
>> I have tested this series on x86-64 with SLAB, SLUB, and SLOB. Note: the
>> following harmless warning appears at boot:
>>
>>   [    0.000000] ------------[ cut here ]------------
>>   [    0.000000] WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem+0x31/0x56()
>>   [    0.000000] Hardware name: 
>>   [    0.000000] Modules linked in:
>>   [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30 #472
>>   [    0.000000] Call Trace:
>>   [    0.000000]  [<ffffffff809d62c3>] ? alloc_arch_preferred_bootmem+0x31/0x56
>>   [    0.000000]  [<ffffffff8025c304>] warn_slowpath_common+0x7c/0xa9
>>   [    0.000000]  [<ffffffff8025c345>] warn_slowpath_null+0x14/0x16
>>   [    0.000000]  [<ffffffff809d62c3>] alloc_arch_preferred_bootmem+0x31/0x56
>>   [    0.000000]  [<ffffffff809d6833>] ___alloc_bootmem_nopanic+0x3f/0xc9
>>   [    0.000000]  [<ffffffff809d68ce>] ___alloc_bootmem+0x11/0x3a
>>   [    0.000000]  [<ffffffff809d69a0>] __alloc_bootmem+0xb/0xd
>>   [    0.000000]  [<ffffffff809d21f9>] sched_init+0x43/0x4ee
>>   [    0.000000]  [<ffffffff809c0aae>] start_kernel+0x1cc/0x3aa
>>   [    0.000000]  [<ffffffff809c029a>] x86_64_start_reservations+0xaa/0xae
>>   [    0.000000]  [<ffffffff809c037f>] x86_64_start_kernel+0xe1/0xe8
>>   [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> Yeah, i got this too:
> 
> [    0.004000] spurious 8259A interrupt: IRQ7.
> [    0.004000] ------------[ cut here ]------------
> [    0.004000] WARNING: at mm/bootmem.c:537 alloc_arch_preferred_bootmem+0x40/0x7e()
> [    0.004000] Hardware name: System Product Name
> [    0.004000] Modules linked in:
> [    0.004000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02102-g994fdea-dirty #52083
> [    0.004000] Call Trace:
> [    0.004000]  [<ffffffff81d699bb>] ? alloc_arch_preferred_bootmem+0x40/0x7e
> [    0.004000]  [<ffffffff81078931>] warn_slowpath_common+0x8d/0xd0
> [    0.004000]  [<ffffffff8107899b>] warn_slowpath_null+0x27/0x3d
> [    0.004000]  [<ffffffff81d699bb>] alloc_arch_preferred_bootmem+0x40/0x7e
> [    0.004000]  [<ffffffff81079992>] ? vprintk+0x2d6/0x31b
> [    0.004000]  [<ffffffff81d6a036>] ___alloc_bootmem_nopanic+0x4e/0xec
> [    0.004000]  [<ffffffff81d6a0f4>] ___alloc_bootmem+0x20/0x61
> [    0.004000]  [<ffffffff81053dc8>] ? default_spin_lock_flags+0x1e/0x36
> [    0.004000]  [<ffffffff81d6a28b>] __alloc_bootmem+0x1e/0x34
> [    0.004000]  [<ffffffff817971cf>] vgacon_scrollback_startup+0x3d/0xa4
> [    0.004000]  [<ffffffff8103ad11>] ? native_io_delay+0xd/0x58
> [    0.004000]  [<ffffffff813d3545>] vgacon_startup+0x38f/0x3be
> [    0.004000]  [<ffffffff81d4e140>] ? early_idt_handler+0x0/0x71
> [    0.004000]  [<ffffffff81d79275>] con_init+0x2e/0x246
> [    0.004000]  [<ffffffff81d4e140>] ? early_idt_handler+0x0/0x71
> [    0.004000]  [<ffffffff81d789aa>] console_init+0x28/0x50
> [    0.004000]  [<ffffffff810530f5>] ? native_irq_enable+0xb/0xc
> [    0.004000]  [<ffffffff81d4eead>] start_kernel+0x20e/0x35b
> [    0.004000]  [<ffffffff81d4e140>] ? early_idt_handler+0x0/0x71
> [    0.004000]  [<ffffffff81d4e140>] ? early_idt_handler+0x0/0x71
> [    0.004000]  [<ffffffff81d4e2b2>] x86_64_start_reservations+0xb9/0xd4
> [    0.004000]  [<ffffffff81d4e000>] ? __init_begin+0x0/0x140
> [    0.004000]  [<ffffffff81d4e3d1>] x86_64_start_kernel+0x104/0x127
> [    0.004000] ---[ end trace a7919e7f17c0a725 ]---
> [    0.004000] Console: colour VGA+ 80x25
> [    0.004000] console handover: boot [earlyser0] -> real [ttyS0]
> 
> box booted up fine otherwise.

Heh, Andrew did complain that the warning is cryptic! It's just an 
indication that someone tried to do a bootmem allocation after slab was 
set up and we switched to kzalloc() under the hood. In the scheduler 
case, it's completely harmless.

I sent some patches out to fix that and the init_console() one.

			Pekka
