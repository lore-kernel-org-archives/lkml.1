Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYCEQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYCEQyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYCEQyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:54:07 -0500
Received: from gw.goop.org ([64.81.55.164]:44771 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbYCEQyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:54:05 -0500
Message-ID: <47CECEE9.3000801@goop.org>
Date: Wed, 05 Mar 2008 08:48:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu> <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu> <Pine.LNX.4.64.0803051407310.22243@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0803051407310.22243@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Please, Ingo, could you give an example of where such additional locking
> is actually necessary?
>
> I ask because I went over those places when splitting the page_table_lock
> for userspace in 2.6.15.  Some things took init_mm.page_table_lock and
> some things didn't, and I concluded that actually none of them needed it.
>
> With the userspace pagetables, we need to guard against racing threads
> and vmscan/rmap.  But with the kernel pagetables, we'd already be in
> serious trouble if two cpus could be modifying the same pte at the
> same time - there needs to be other serialization already e.g. vmalloc
> has its own locking for parcelling out areas to different uses, so down
> at the page table level there should be no conflict.
>
> Allocation of new page tables, yes, that needs locking, and does use
> the page_table_lock for kernel space just as for user space.
>
> That was all two years ago, I may have been wrong then, or a lot may
> have changed since.  But I've heard of a grand total of 0 problems
> from not having such locking.
>   

It's not obvious to me what problems might arise, but the Xen set_pte 
operations do currently rely on preemption being inhibited.  At worst I 
can add preempt_disable/enable calls to them.

> And on the original topic of flush TLB without preemption disabled:
> again I'm not sure there's a bug there, but it's less clear.  Aren't
> some of those __flush_tlb_ones just unnecessary, we're simply filling
> a previously empty slot?  And if there's a guarantee that preemption
> will itself involve a TLB flush (maybe there's no such guarantee for
> these kernel entries, it's quite a different case from the userspace
> one, and you'll be worrying about the global bit), if, then it'd be
> okay to __flush_tlb_one without disabling preemption.

If a thread goes from processor A -> B -> A, where A is first preempted 
between a pagetable update and a tlb flush, then the second time the 
thread runs on A may run with a stale tlb (if in the meantime A has 
either been idle or only running kernel threads).

    J
