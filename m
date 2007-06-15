Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXFOJHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXFOJHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbXFOJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:06:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:58120 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbXFOJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:06:54 -0400
Message-ID: <467256AA.1040001@qumranet.com>
Date: Fri, 15 Jun 2007 12:06:50 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <46651069.5040003@qumranet.com> <466BED18.5040708@qumranet.com>	 <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com>	 <466CFD6D.2080201@qumranet.com>	 <20070612175246.GA5864@dreamland.darkstar.lan>	 <466FB1ED.3090905@qumranet.com>	 <20070613204948.GA14710@dreamland.darkstar.lan>	 <4670FBB5.70707@qumranet.com>	 <20070614225324.GA4088@dreamland.darkstar.lan>	 <20070614231359.GA5705@dreamland.darkstar.lan> <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com>
In-Reply-To: <68676e00706141627s3cb87391sa0ee6711d2f7933f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 15 Jun 2007 12:06:50 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca wrote:
>>
>> Got it!
>> The emulator skips the writeback if the old value is unchanged, so the
>> apic doesn't see the write.
>>
>> Forcing the writeback:
>>
>> -      if ((d & Mov) || (dst.orig_val != dst.val)) {
>> -      if ((d & Mov) || (dst.orig_val != dst.val) || isxchg) {
>>
>> seems to fix the issue :D I'm not sure that fix is correct though.
>

Good detective work!


> After a bit of thinking: it's correct but removes an optimization;
> furthermore it may miss other instructions that write to memory mapped
> areas.
> A more proper fix should be "force the writeback if dst.ptr is in some
> kind of mmio area".
>

I think we can just disable the optimization, and (in a separate patch)
add it back in emulator_write_phys(), where we know we're modifying
memory and not hitting mmio.

Incidentally, in Xen, where this code originated from, this emulator is
used only for page table updates (which are always to memory).  A
separate emulator is used for mmio.  I guess the optimization targets
the vm scanner doing test_and_clear_bit() type of operations against the
page tables' dirty bits.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

