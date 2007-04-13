Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXDMTay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXDMTay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXDMTay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:30:54 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33360 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139AbXDMTax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:30:53 -0400
Message-ID: <461FD9BF.90609@vmware.com>
Date: Fri, 13 Apr 2007 12:27:59 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com> <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Zach, while looking at your recent patches, I ran across the comment
> on pte_update_defer, and where it was being used, and now think that
> David's patch is actually incorrect.  Previously pte_update_defer
> was being used where a flush_tlb_page followed immediately after
> within the same macro; with David's patch, mm's clear_refs_pte_range
> is calling ptep_test_and_clear_young (including pte_update_defer) on
> several ptes, then unlocking the page table, and later flushing TLB.
> That's exactly wrong for pte_update_defer, isn't it?
>   

Ok, disregard most of my last e-mail.  It is fine to decouple the flush 
from the update, as long as they stay close enough that you can reason 
they happen together.  I guess I hadn't seen the other parts of the 
patch which release the page table spinlock in between the two, and 
somehow missed it again when responding to the above as I got too 
excited explaining why the decoupling is ok.  It is not ok to release 
the spinlock when using shadow page tables on SMP.  There are some 
rather complex races that can result.  Here's one case:

 CPU-0                    CPU-1
-----------------------  ---------------------------
test_and_clear_dirty(x)
spin_unlock(ptl)
                         write address mapped by X
                         (harware updates dirty bit)
                         spin_lock(ptl)
                         set_pte_wrprotect(x)
                         flush
flush

Now, the write protected pte which maps a dirty page gets broken in two 
ways; it is unclear if dirty bit or entiry PTE from CPU-0 is deferred 
until flush, so either write protected PTE for modified page loses the 
dirty bit (BAD!), or write protected PTE loses both dirty and write 
protect bits (VERY BAD!).

To prevent this, we need a flush before dropping the spinlock.  If that 
gets too complicated, we can drop the defer logic and just use 
pte_update instead, which notifies the hypervisor immediately of the 
mapping change.

Zach
