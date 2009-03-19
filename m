Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZCSJrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZCSJrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZCSJqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:46:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZCSJqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:46:51 -0400
Message-ID: <49C21473.2000702@redhat.com>
Date: Thu, 19 Mar 2009 11:46:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
References: <49C148AF.5050601@goop.org> <49C16411.2040705@redhat.com> <49C1665A.4080707@goop.org> <49C16A48.4090303@redhat.com> <49C17230.20109@goop.org> <49C17880.7080109@redhat.com> <49C17BD8.6050609@goop.org> <49C17E22.9040807@redhat.com> <49C18487.1020703@goop.org>
In-Reply-To: <49C18487.1020703@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>>
>>> Well, no, not deferring.  Making xen_flush_tlb_others() spin waiting 
>>> for "doing_gup" to clear on the target cpu.  Or add an explicit 
>>> notion of a "pte update barrier" rather than implicitly relying on 
>>> the tlb IPI (which is extremely convenient when available...).
>>
>> Pick up a percpu flag from all cpus and spin on each?  Nasty.
>
> Yeah, not great.  Each of those flag fetches is likely to be cold, so 
> a bunch of cache misses.  The only mitigating factor is that cross-cpu 
> tlb flushes are expected to be expensive, but some workloads are 
> apparently very sensitive to extra latency in that path.  

Right, and they'll do a bunch more cache misses, so in comparison it 
isn't too bad.

> And the hypercall could result in no Xen-level IPIs at all, so it 
> could be very quick by comparison to an IPI-based Linux 
> implementation, in which case the flag polling would be particularly 
> harsh.

Maybe we could bring these optimizations into Linux as well.  The only 
thing Xen knows that Linux doesn't is if a vcpu is not scheduled; all 
other information is shared.

>
> Also, the straightforward implementation of "poll until all target 
> cpu's flags are clear" may never make progress, so you'd have to "scan 
> flags, remove busy cpus from set, repeat until all cpus done".
>
> All annoying because this race is pretty unlikely, and it seems a 
> shame to slow down all tlb flushes to deal with it.  Some kind of 
> global "doing gup_fast" counter would get flush_tlb_others bypass the 
> check, at the cost of putting a couple of atomic ops around the 
> outside of gup_fast.

The nice thing about local_irq_disable() is that it scales so well.

>
>> You could use the irq enabled flag; it's available and what native 
>> spins on (but also means I'll need to add one if I implement this).
>
> Yes, but then we'd end up spuriously polling on cpus which happened to 
> disable interrupts for any reason.  And if the vcpu is not running 
> then we could end up polling for a long time.  (Same applies for 
> things in gup_fast, but I'm assuming that's a lot less common than 
> disabling interrupts in general).

Right.

-- 
error compiling committee.c: too many arguments to function

