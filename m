Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYISAmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYISAmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYISAmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:42:25 -0400
Received: from gw.goop.org ([64.81.55.164]:54526 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623AbYISAmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:42:24 -0400
Message-ID: <48D2F571.4010504@goop.org>
Date: Thu, 18 Sep 2008 17:42:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com> <48D1851B.70703@goop.org> <48D18919.9060808@redhat.com> <48D18C6B.5010407@goop.org> <48D2B970.7040903@redhat.com> <48D2D3B2.10503@goop.org> <48D2E65A.6020004@redhat.com> <48D2EBBB.205@goop.org> <48D2F05C.4040000@redhat.com>
In-Reply-To: <48D2F05C.4040000@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>
>> The only direct use of pte_young() is in zap_pte_range, within a
>> mmu_lazy region.  So syncing the A bit state on entering lazy mmu mode
>> would work fine there.
>>
>>   
>
> Ugh, leaving lazy pte.a mode when entering lazy mmu mode?

Well, sort of but not quite.  The kernel's announcing its about to start
processing a batch of ptes, so the hypervisor can take the opportunity
to update their state before processing.  "Lazy-mode" is from the
perspective of the kernel lazily updating some state the hypervisor
might care about, and the sync happens when leaving mode.

The flip-side is when the hypervisor is lazily updating some state the
kernel cares about, so it makes sense that the sync when the kernel
enters its lazy mode.  But the analogy isn't very good because we don't
really have an explicit notion of "hypervisor lazy mode", or a formal
handoff of shared state between the kernel and hypervisor.  But in this
case the behaviour isn't too bad.

>> The call via page_referenced_one() doesn't seem to have a very
>> convenient hook though.  Perhaps putting something in
>> page_check_address() would do the job.
>>
>>   
>
> Why there?
>
> Why not explicitly in the callers?  We need more than to exit lazy
> pte.a mode, we also need to enter it again later.
>

Because that's the code that actually walks the pagetable and has the
address of the pte; it just returns a pte_t, not a pte_t *.  It depends
on whether you want fetch the A bit via ptep or vaddr (in general we
pass mm, ptep and vaddr to ops which operate on the current pagetable).

    J
