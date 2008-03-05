Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbYCETYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbYCETYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbYCETYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:24:14 -0500
Received: from gw.goop.org ([64.81.55.164]:50926 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046AbYCETYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:24:13 -0500
Message-ID: <47CEF20D.5070608@goop.org>
Date: Wed, 05 Mar 2008 11:18:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu> <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu> <Pine.LNX.4.64.0803051407310.22243@blonde.site> <47CECEE9.3000801@goop.org> <Pine.LNX.4.64.0803051721200.13410@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0803051721200.13410@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 5 Mar 2008, Jeremy Fitzhardinge wrote:
>   
>> If a thread goes from processor A -> B -> A, where A is first preempted
>> between a pagetable update and a tlb flush, then the second time the thread
>> runs on A may run with a stale tlb (if in the meantime A has either been idle
>> or only running kernel threads).
>>     
>
> Right, thanks, because __flush_tlb_one opts out of the full active_mm
> checking which goes on for userspace mms (which covers, for example,
> the case of preemption before dup_mmap's flush_tlb_mm).
>
> But is there actually a case where there's a problem?  So far as I can see,
> set_pmd_pfn is there solely for discontig_32's __init remap_numa_kva; and
> set_pte_pfn is there solely for set_fixmap, which operates on a per-cpu
> area of pagetable, which would already be in bigger trouble if preemption
> to another cpu were possible.

Yes, I meant set_pte_pfn; set_pmd_pfn is a typo.

Fixmap slots are global, not percpu; you may be thinking of kmap_atomic, 
which reserves percpu fixmap slots for its use.  Most uses of set_fixmap 
are early in boot, where preemption (or other CPUs) isn't a factor.  The 
exception is mapping the compat vdso global mapping.   However, that is 
special-cased anyway, since the set_fixmap is followed by an explicit 
all-cpu tlb flush.

It seems to me that the correct fix is to just make __set_fixmap disable 
preemption for its duration; it probably doesn't make much difference 
for the native case, and it makes Xen happy.

    J
