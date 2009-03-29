Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbZC2OhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbZC2OhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbZC2Og5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:36:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59061 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZC2Og5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:36:57 -0400
Message-ID: <49CF8733.7060309@redhat.com>
Date: Sun, 29 Mar 2009 10:35:31 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 1/6] Guest page hinting: core + volatile page cache.
References: <20090327150905.819861420@de.ibm.com>	<20090327151011.534224968@de.ibm.com>	<49CD59DB.3070906@redhat.com> <20090329155640.31472c61@skybase>
In-Reply-To: <20090329155640.31472c61@skybase>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Fri, 27 Mar 2009 18:57:31 -0400
> Rik van Riel <riel@redhat.com> wrote:
>> Martin Schwidefsky wrote:

>>>   There are some alternatives how this can be done, e.g. a global
>>>   lock, or lock per segment in the kernel page table, or the per page
>>>   bit PG_arch_1 if it is still free.
>> Can this be taken care of by memory barriers and
>> careful ordering of operations?
> 
> I don't see how this could be done with memory barries, the sequence is
> 1) check conditions
> 2) do state change to volatile
> 
> another cpus can do
> i) change one of the conditions
> 
> The operation i) needs to be postponed while the first cpu has done 1)
> but not done 2) yet. 1+2 needs to be atomic but consists of several
> instructions. Ergo we need a lock, no ?

You are right.

Hashed locks may be a space saving option, with a
set of (cache line aligned?) locks in each zone
and the page state lock chosen by taking a hash
of the page number or address.

Not ideal, but at least we can get some NUMA
locality.

>>> +	if (page->index != linear_page_index(vma, addr))
>>> +		/* If nonlinear, store the file page offset in the pte. */
>>> +		set_pte_at(dst_mm, addr, dst_pte, pgoff_to_pte(page->index));
>>> +	else
>>> +		pte_clear(dst_mm, addr, dst_pte);
>>>  }
>> It would be good to document that PG_discarded can only happen for
>> file pages and NOT for eg. clean swap cache pages.
> 
> PG_discarded can happen for swap cache pages as well. If a clean swap
> cache page gets remove and subsequently access again the discard fault
> handler will set the bit (see __page_discard). The code necessary for
> volatile swap cache is introduced with patch #2. So I would rather not
> add a comment in patch #1 only to remove it again with patch #2 ..

I discovered that once I opened the next email :)

>>> @@ -1390,6 +1391,7 @@ int test_clear_page_writeback(struct pag
>>>  			radix_tree_tag_clear(&mapping->page_tree,
>>>  						page_index(page),
>>>  						PAGECACHE_TAG_WRITEBACK);
>>> +			page_make_volatile(page, 1);
>>>  			if (bdi_cap_account_writeback(bdi)) {
>>>  				__dec_bdi_stat(bdi, BDI_WRITEBACK);
>>>  				__bdi_writeout_inc(bdi);
>> Does this mark the page volatile before the IO writing the
>> dirty data back to disk has even started?  Is that OK?
>  
> Hmm, it could be that the page_make_volatile is just superflouos here.
> The logic here is that whenever one of the conditions that prevent a
> page from becoming volatile is cleared a try with page_make_volatile
> is done. The condition in question here is PageWriteback(page). If we
> can prove that one of the other conditions is true this particular call
> is a waste of effort.

Actually, test_clear_page_writeback is probably called
on IO completion and it was just me being confused after
a few hundred lines of very new (to me) VM code :)

I guess the patch is correct.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
