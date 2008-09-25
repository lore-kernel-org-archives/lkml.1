Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYIYScx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYIYScx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYIYScp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:32:45 -0400
Received: from gw.goop.org ([64.81.55.164]:35135 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYIYScp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:32:45 -0400
Message-ID: <48DBD94A.50905@goop.org>
Date: Thu, 25 Sep 2008 11:32:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com> <48D1851B.70703@goop.org> <48D18919.9060808@redhat.com> <48D18C6B.5010407@goop.org> <48D2B970.7040903@redhat.com> <48D2D3B2.10503@goop.org> <48D2E65A.6020004@redhat.com> <48D2EBBB.205@goop.org> <48D2F05C.4040000@redhat.com> <48D2F571.4010504@goop.org> <48DA333C.2050900@redhat.com>
In-Reply-To: <48DA333C.2050900@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jeremy Fitzhardinge wrote:
>> Avi Kivity wrote:
>>  
>>>> The only direct use of pte_young() is in zap_pte_range, within a
>>>> mmu_lazy region.  So syncing the A bit state on entering lazy mmu mode
>>>> would work fine there.
>>>>
>>>>         
>>> Ugh, leaving lazy pte.a mode when entering lazy mmu mode?
>>>     
>>
>> Well, sort of but not quite.  The kernel's announcing its about to start
>> processing a batch of ptes, so the hypervisor can take the opportunity
>> to update their state before processing.  "Lazy-mode" is from the
>> perspective of the kernel lazily updating some state the hypervisor
>> might care about, and the sync happens when leaving mode.
>>
>> The flip-side is when the hypervisor is lazily updating some state the
>> kernel cares about, so it makes sense that the sync when the kernel
>> enters its lazy mode.  But the analogy isn't very good because we don't
>> really have an explicit notion of "hypervisor lazy mode", or a formal
>> handoff of shared state between the kernel and hypervisor.  But in this
>> case the behaviour isn't too bad.
>>
>>   
>
> Handwavy.  I think the two notions are separate <insert handwavy
> counter-arguments>.

Perhaps this helps:

Context switches between guest<->hypervisor are relatively expensive. 
The more work we can make each context switch perform the better,
because we can amortize the cost.  Rather than synchronously switching
between the two every time one wants to express a state change to the
other, we batch those changes up and only sync when its important. 
While there are batched outstanding changes in one, the other will have
a somewhat out of date view of the state.  At this level, the idea of
batching is completely symmetrical.

One of the ways we amortize the cost of guest->hypervisor transitions is
by batching multiple pagetable updates together.  This works at two
levels: within explicit arch_enter/leave_lazy_mmu lazy regions, and also
because it is analogous to the architectural requirement that you must
flush the tlb before updates "really" happen.

KVM - and other shadow pagetable implementations - have the additional
problem of transmitting A/D state updates from the shadow pagetable into
the guest pagetable.  Doing this synchronously has the costs we've been
discussing in this thread (namely, extra faults we would like to
avoid).  Doing this in a deferred or batched way is awkward because
there's no analogous architectural asynchrony in updating these pte
flags, and we don't have any existing mechanisms or hooks to support
this kind of deferred update.

However, given that we're talking about cleaning up the pagetable api
anyway, there's no reason we couldn't incorporate this kind of deferred
update in a more formal way.  It definitely makes sense when you have
shadow pagetables, and it probably makes sense on other architectures too.

Very few places actually care about the state of the A/D bits; would it
be expensive to make those places explicitly ask for synchronization
before testing the bits (or alternatively, have an explicit query
operation rather than just poking about in the ptes).  Martin, does this
help with s390's per-page (vs per-pte) A/D state?

    J
