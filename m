Return-Path: <linux-kernel-owner+w=401wt.eu-S1945985AbXDEGxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985AbXDEGxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946000AbXDEGxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:53:25 -0400
Received: from gw.goop.org ([64.81.55.164]:47081 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945985AbXDEGxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:53:22 -0400
Message-ID: <46149CC9.2070903@goop.org>
Date: Wed, 04 Apr 2007 23:52:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@waste.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 20/20] Add apply_to_page_range() which applies a function
 to a pte range.
References: <20070404191151.009821039@goop.org> <20070404191206.675793431@goop.org> <20070405044133.GE4892@waste.org>
In-Reply-To: <20070405044133.GE4892@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
>> +/*
>> + * Scan a region of virtual memory, filling in page tables as necessary
>> + * and calling a provided function on each leaf page table.
>> + */
>>     
>
> But I'm not sure what the use case is that wants filling in the page
> table..? If both modes really make sense, perhaps a flag could unify
> these differences.
>   

Well, two reasons:

One is the general one that if you're traversing ptes then they need to
exist to traverse them (for example, if you're creating new mappings). 
Obviously if you want to just visit existing mappings, then
instantiating new pagetable is not the right thing to do (and I could
make use of this too).

The other is that there are various places in the Xen hypervisor API
where you pass in a reference to pte entry for the hypervisor to put
mappings into, and the rest of the pagetable needs to exist.  The Xen
code uses the side-effect of apply_to_page_range() to create pagetable
for these calls.

>> +typedef int (*pte_fn_t)(pte_t *pte, struct page *pmd_page, unsigned long addr,
>> +			void *data);
>>     
>
> I'd gotten the impression that these sorts of typedefs were out of
> fashion.
>   

In general yes, but for function pointers the syntax is so clumsy that I
think typedefs are OK.

>> +static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>> +				     unsigned long addr, unsigned long end,
>> +				     pte_fn_t fn, void *data)
>> +{
>> +	pte_t *pte;
>> +	int err;
>> +	struct page *pmd_page;
>> +	spinlock_t *ptl;
>> +
>> +	pte = (mm == &init_mm) ?
>> +		pte_alloc_kernel(pmd, addr) :
>> +		pte_alloc_map_lock(mm, pmd, addr, &ptl);
>> +	if (!pte)
>> +		return -ENOMEM;
>>     
>
> Seems a bit awkward to pass mm all the way down the tree just for this
> quirk. Which is a bit awkward as it means that whether or not a lock
> is held in the callback is context dependent.
>   

Well, it would need mm for just pte_alloc_map_lock() anyway.

> smaps, clear_ref, and my pagemap code all use the callback at the
> pmd_range level, which a) localizes the pte-level locking concerns
> with the user b) amortizes the indirection overhead and c)
> (unfortunately) makes the user a bit more complex.
>
> We should try to measure whether (b) actually makes a difference.
>   

I'll need to look closely at your code again.  It would be nice to have
one pagewalker.

    J
