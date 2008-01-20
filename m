Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYATTJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYATTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYATTJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:09:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34657 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbYATTJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:09:18 -0500
Date: Sun, 20 Jan 2008 20:12:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] Fix early_ioremap on x86-64
Message-ID: <20080120191247.GA28190@one.firstfloor.org>
References: <20080120172840.GA24608@basil.nowhere.org> <20080120175955.GA4993@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120175955.GA4993@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 06:59:55PM +0100, Ingo Molnar wrote:
> 
> Jeremy did suspect something about this change, as indicated in the 
> changelog. But because the change was so finegrained, the bisection 
> almost directly led to the fix. _That_ i think clearly demonstrates the 
> power of bisection and finegrained changes.

Actually it is pretty hard to do bisects in current git-x86 currently because
you don't ammend original buggy changes but just stuff the fixes 
at the end. This means there are large windows of breakage inbetween
that make it hard to pinpoint other bugs during bisection.

This is why I cannot easily bisect this new breakage.
Ok I suspect I can cook up some script later that always create a new branch 
and reapplies the bug fixes. Or ammend the patch locally. But frankly it is 
very unpleasant.

> 
> but note what the fundamental problem is - we've turned a previously 
> safe flushing API into an unsafe one - __flush_tlb() will only be safe 

It works for user space which is by far the most common case.

> in the rarest of circumstances. There are some other matches:
> 
>  ./mm/init_64.c: __flush_tlb();
>  ./kernel/head64.c:      __flush_tlb();

You're right I missed some. I tried to just redefine it in tlbflush.h
(which covers user space fork() too so it's too much as a real fix, but
reasonable for debugging) but it unfortunately still results in the same 
crash during NUMA node discovery:

There is some garbage in the stack trace; i don't think it's actually
in bootmem. [My kingdom for Jan's unwinder!]

RAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-d0000000
SRAT: Node 0 PXM 0 0-130000000
SRAT: Node 1 PXM 1 130000000-330000000
early_iounmap(ffffffff828e08d9, 00000150)
Bootmem setup node 0 0000000000000000-00000000d0000000
PANIC: early exception 06 rip 10:ffffffff8082df35 error 0 cr2 0
Pid: 0, comm: swapper Not tainted 2.6.24-rc8-dirty #47

Call Trace:
 [<ffffffff8082df35>] free_bootmem_core+0x1a/0x6b
 [<ffffffff8082f14b>] free_bootmem_with_active_regions+0x51/0x67
 [<ffffffff8082a0fb>] setup_node_bootmem+0x16b/0x1b3
 [<ffffffff8082b3ac>] acpi_scan_nodes+0x136/0x230
 [<ffffffff8082a6c3>] numa_initmem_init+0x331/0x459
 [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
 [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
 [<ffffffff80355726>] number+0x10e/0x1f9
 [<ffffffff802354d8>] printk+0x4e/0x56
 [<ffffffff80355726>] number+0x10e/0x1f9
 [<ffffffff803563f8>] vsnprintf+0x53f/0x583
 [<ffffffff80355726>] number+0x10e/0x1f9
 [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
 [<ffffffff803563f8>] vsnprintf+0x53f/0x583
 [<ffffffff8022468a>] early_serial_write+0x22/0x32
 [<ffffffff80234b32>] __call_console_drivers+0x5e/0x6c
 [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
 [<ffffffff802354d8>] printk+0x4e/0x56
 [<ffffffff802354d8>] printk+0x4e/0x56
 [<ffffffff802354d8>] printk+0x4e/0x56
 [<ffffffff8082b164>] acpi_numa_memory_affinity_init+0x228/0x33a
 [<ffffffff8022635c>] early_iounmap+0x20/0x70
 [<ffffffff80836045>] acpi_parse_memory_affinity+0x0/0x1f
 [<ffffffff8083470c>] acpi_table_parse_entries+0x115/0x126
 [<ffffffff80836011>] acpi_parse_slit+0x0/0x17
 [<ffffffff808345d0>] acpi_table_parse+0x4c/0x73
 [<ffffffff808215af>] setup_arch+0x266/0x414
 [<ffffffff8081b8b7>] start_kernel+0x6f/0x2bd
 [<ffffffff8081b1ce>] _sinittext+0x1ce/0x1d5

RIP 0x10

-Andi (seemingly chief QA officer of git-x86 currently) 

