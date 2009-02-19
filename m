Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZBSRCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZBSRCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZBSRCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:02:42 -0500
Received: from gw.goop.org ([64.81.55.164]:54497 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730AbZBSRCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:02:41 -0500
Message-ID: <499D90AE.7060102@goop.org>
Date: Thu, 19 Feb 2009 09:02:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
References: <49416494.6040009@goop.org> <200812301442.37654.nickpiggin@yahoo.com.au> <499B32E4.4080501@goop.org> <200902192254.31735.nickpiggin@yahoo.com.au>
In-Reply-To: <200902192254.31735.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 18 February 2009 08:57:56 Jeremy Fitzhardinge wrote:
>   
>> Nick Piggin wrote:
>>     
>>> I have patches to move the tlb flushing to an asynchronous process
>>> context... but all tweaks to that (including flushing at vmap) are just
>>> variations on the existing flushing scheme and don't solve your problem,
>>> so I don't think we really need to change that for the moment (my patches
>>> are mainly for latency improvement and to allow vunmap to be usable from
>>> interrupt context).
>>>       
>> Hi Nick,
>>
>> I'm very interested in being able to call vm_unmap_aliases() from
>> interrupt context.  Does the work you mention here encompass that?
>>     
>
> No, and it can't because we can't do the global kernel tlb flush
> from interrupt context.
>
> There is basically no point in doing the vm_unmap_aliases from
> interrupt context without doing the global TLB flush as well,
> because you still cannot reuse the virtual memory, you still have
> possible aliases to it, and you still need to schedule a TLB flush
> at some point anyway.
>   

But that's only an issue when you actually do want to reuse the virtual 
address space.  Couldn't you set a flag saying "tlb flush needed", so 
when cpu X is about to use some of that address space, it flushes 
first?  Avoids the need for synchronous cross-cpu tlb flushes.  It 
assumes they're not currently using that address space, but I think that 
would indicate a bug anyway.

(Xen does something like this internally to either defer or avoid many 
expensive tlb operations.)

>> For Xen dom0, when someone does something like dma_alloc_coherent, we
>> allocate the memory as normal, and then swizzle the underlying physical
>> pages to be machine physically contiguous (vs contiguous pseudo-physical
>> guest memory), and within the addressable range for the device.  In
>> order to do that, we need to make sure the pages are only mapped by the
>> linear mapping, and there are no other aliases.
>>     
>
> These are just stale aliases that will no longer be operated on
> unless there is a kernel bug -- so can you just live with them,
> or is it a security issue of memory access escaping its domain?
>   

The underlying physical page is being exchanged, so the old page is 
being returned to Xen's free page pool.  It will refuse to do the 
exchange if the guest still has pagetable references to the page.


>> And since drivers are free to allocate dma memory at interrupt time,
>> this needs to happen at interrupt time too.
>>
>> (The tlb flush issue that started this read should be a non-issue for
>> Xen, at least, because all cross-cpu tlb flushes should happen via  a
>> hypercall rather than kernel-initiated IPIs, so there's no possibility
>> of deadlock.  Though I'll happily admit that taking advantage of the
>> implementation properties of a particular implementation is not very
>> pretty...)
>>     
>
> If it is really no other way around it, it would be possible to
> allow arch code to take advantage of this if it knows its TLB
> flush is interrupt safe.
>   

It's almost safe.  I've got this patch in my tree to tie up the 
flush_tlb_all loose end, though I won't claim its pretty.

>From 5812263a50a27c697a2287b41d4f005804b6b34a Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, 17 Feb 2009 09:44:14 -0800
Subject: [PATCH] x86: implement flush_tlb_all in terms of flush_tlb_others

Modify flush_tlb_others to take a NULL mm, meaning "flush user
and kernel tlbs", and implement flush_tlb_all in terms of that.

The principle motivation for this is to make sure it goes via
paravirt_ops, which allows for more efficient cross-cpu tlb
flushes than a plain IPI.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 14c5af4..2d112f9 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -148,7 +148,13 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
+	if (f->flush_mm == NULL) {
+		/* No mm - flush all kernel and user tlbs */
+		__flush_tlb_all();
+		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
+			leave_mm(cpu);
+	} else if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
+		/* Flushing a specific user mm */
 		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
@@ -281,16 +287,15 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 	preempt_enable();
 }
 
-static void do_flush_tlb_all(void *info)
+void flush_tlb_all(void)
 {
-	unsigned long cpu = smp_processor_id();
+	preempt_disable();
+
+	flush_tlb_others(cpu_online_mask, NULL, TLB_FLUSH_ALL);
 
 	__flush_tlb_all();
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
+		leave_mm(smp_processor_id());
 
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1);
+	preempt_enable();
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 7cadab1..dc83b47 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1350,7 +1350,6 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	struct multicall_space mcs;
 
 	BUG_ON(cpumask_empty(cpus));
-	BUG_ON(!mm);
 
 	mcs = xen_mc_entry(sizeof(*args));
 	args = mcs.args;


    J
