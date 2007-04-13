Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbXDMRyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbXDMRyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXDMRyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:54:05 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21044 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbXDMRyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:54:04 -0400
X-AuditID: d80ac287-9dcaebb000002c59-09-461fc3ba2ed1 
Date: Fri, 13 Apr 2007 18:54:01 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Zachary Amsden <zach@vmware.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
In-Reply-To: <46082BE6.30402@vmware.com>
Message-ID: <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
 <46082BE6.30402@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 13 Apr 2007 17:54:02.0132 (UTC) FILETIME=[B8537D40:01C77DF4]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Zachary Amsden wrote:
> David Rientjes wrote:
> >  Date: Sun, 25 Mar 2007 23:07:43 -0800
> >  From: Zachary Amsden <zach@vmware.com>
> >
> >  If you actually clear the bit, you need to:
> >
> >  +         pte_update_defer(vma->vm_mm, addr, ptep);
> >
> >  The reason is, when updating PTEs, the hypervisor must be notified.  Using
> >  atomic operations to do this is fine for all hypervisors I am aware of.
> >  However, for hypervisors which shadow page tables, if these PTE
> >  modifications are not trapped, you need a post-modification call to fulfill
> >  the update of the shadow page table.
> >
> > Cc: Zachary Amsden <zach@vmware.com>
> > Cc: Hugh Dickins <hugh@veritas.com>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> >   
> 
> Acked-by: Zachary Amsden <zach@vmware.com>
> 
> David, thanks for cleaning this up.

Zach, while looking at your recent patches, I ran across the comment
on pte_update_defer, and where it was being used, and now think that
David's patch is actually incorrect.  Previously pte_update_defer
was being used where a flush_tlb_page followed immediately after
within the same macro; with David's patch, mm's clear_refs_pte_range
is calling ptep_test_and_clear_young (including pte_update_defer) on
several ptes, then unlocking the page table, and later flushing TLB.
That's exactly wrong for pte_update_defer, isn't it?

I do find the name confusing (pte_update_defer is for use only when
the TLB update is not deferred, right?): indeed, its distinction from
pte_update very prone to errors of this kind.  I'm all for deferring
work, but is there some way the right thing could be done automatically?
Or, how much would be lost if we just replaced all the pte_update_defers
by pte_updates?

I'm not proposing any patch myself: just bringing to your attention.

Hugh
