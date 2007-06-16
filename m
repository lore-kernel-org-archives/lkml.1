Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXFPHnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXFPHnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXFPHnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:43:32 -0400
Received: from il.qumranet.com ([82.166.9.18]:49602 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXFPHnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:43:32 -0400
Message-ID: <4673949B.1070505@qumranet.com>
Date: Sat, 16 Jun 2007 10:43:23 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com> <466CFD6D.2080201@qumranet.com> <20070612175246.GA5864@dreamland.darkstar.lan> <466FB1ED.3090905@qumranet.com> <20070613204948.GA14710@dreamland.darkstar.lan> <4670FBB5.70707@qumranet.com> <20070614225324.GA4088@dreamland.darkstar.lan> <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com> <467256AA.1040001@qumranet.com> <20070615214915.GA10536@dreamland.darkstar.lan>
In-Reply-To: <20070615214915.GA10536@dreamland.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 16 Jun 2007 10:43:23 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> Il Fri, Jun 15, 2007 at 12:06:50PM +0300, Avi Kivity ha scritto: 
>   
>>> After a bit of thinking: it's correct but removes an optimization;
>>> furthermore it may miss other instructions that write to memory mapped
>>> areas.
>>> A more proper fix should be "force the writeback if dst.ptr is in some
>>> kind of mmio area".
>>>
>>>       
>> I think we can just disable the optimization, and (in a separate patch)
>> add it back in emulator_write_phys(), where we know we're modifying
>> memory and not hitting mmio.
>>     
>
> Problem is that in emulator_write_phys() we've already lost track of the
> previous (dst.orig_val) value. I moved up the decision in
>   

Actually we haven't; just before the memcpy(), we can put a memcmp() to
guard the kvm_mmu_pte_write(), which is the really expensive operation,
especially with guest smp.

> cmpxchg_emulated; unfortunately this means that the non-locked write
> path (write_emulated) can't do this optimization, unless I change its
> signature to include the old value.
>
> The first patch makes the writeback step uncoditional whenever we have a
> destination operand (the mov check (d & Mov) may be superfluous, yes?).
> The write-to-registry path still has the optimization that skips the
> write if possible.
>   

The mov check is in done since the destination is not read for moves; so
the check for change would read uninitialized memory.

I think we can simply remove the if ().  For the register case, the
check is more expensive that the write; for mmio, we don't want it; and
for memory writes, we can put it in emulator_write_phys().

> Next one: I've splitted emulator_write_phys into emulator_write_phys_mem
> (for normal RAM) and emulator_write_phys_mmio (for the rest). The
>   

This is in order to properly emulate cmpxchg(), right?  I don't think
it's necessary since all that memory is write protected and the
modifications happen under kvm->lock.

>
> I'm a bit confused about this test, found in emulator_write_phys
> (original code):
>
> if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
>         return 0;
>
> AFAICT is makes the emulator skip the write if the modified area spans
> across two different (physical) pages. When this happens write_emulated
> does a MMIO write. I'd expect the function to load the 2 pages and do the
> memory write on both instead.
>   

This isn't skipping the write; instead it uses the mmio path to update
memory instead of the direct path, as I was too lazy to code split page
writes.  It's also wrong in case someone uses nonaligned writes to
update page tables, but no-one does that.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

