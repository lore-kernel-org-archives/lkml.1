Return-Path: <linux-kernel-owner+w=401wt.eu-S965055AbXDMUY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbXDMUY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965052AbXDMUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:24:58 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57238 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965051AbXDMUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:24:57 -0400
X-AuditID: d80ac287-9c8acbb000002c59-ac-461fe71953bb 
Date: Fri, 13 Apr 2007 21:24:55 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Zachary Amsden <zach@vmware.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
In-Reply-To: <461FD9BF.90609@vmware.com>
Message-ID: <Pine.LNX.4.64.0704132108430.14740@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
 <46082BE6.30402@vmware.com> <Pine.LNX.4.64.0704131838310.8399@blonde.wat.veritas.com>
 <461FD9BF.90609@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 13 Apr 2007 20:24:56.0508 (UTC) FILETIME=[CD279FC0:01C77E09]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Zachary Amsden wrote:
> Hugh Dickins wrote:
> > Zach, while looking at your recent patches, I ran across the comment
> > on pte_update_defer, and where it was being used, and now think that
> > David's patch is actually incorrect.  Previously pte_update_defer
> > was being used where a flush_tlb_page followed immediately after
> > within the same macro; with David's patch, mm's clear_refs_pte_range
> > is calling ptep_test_and_clear_young (including pte_update_defer) on
> > several ptes, then unlocking the page table, and later flushing TLB.
> > That's exactly wrong for pte_update_defer, isn't it?
> >   
> 
> Ok, disregard most of my last e-mail.

Phew!  That's a lot quicker than digesting it ;)
But thanks for going to so much trouble.

> It is fine to decouple the flush from
> the update, as long as they stay close enough that you can reason they happen
> together.  I guess I hadn't seen the other parts of the patch which release
> the page table spinlock in between the two, and somehow missed it again when
> responding to the above as I got too excited explaining why the decoupling is
> ok.  It is not ok to release the spinlock when using shadow page tables on
> SMP.  There are some rather complex races that can result.  Here's one case:
> 
> CPU-0                    CPU-1
> -----------------------  ---------------------------
> test_and_clear_dirty(x)
> spin_unlock(ptl)
>                         write address mapped by X
>                         (harware updates dirty bit)
>                         spin_lock(ptl)
>                         set_pte_wrprotect(x)
>                         flush
> flush
> 
> Now, the write protected pte which maps a dirty page gets broken in two ways;
> it is unclear if dirty bit or entiry PTE from CPU-0 is deferred until flush,
> so either write protected PTE for modified page loses the dirty bit (BAD!), or
> write protected PTE loses both dirty and write protect bits (VERY BAD!).
> 
> To prevent this, we need a flush before dropping the spinlock.  If that gets
> too complicated, we can drop the defer logic and just use pte_update instead,
> which notifies the hypervisor immediately of the mapping change.

David (clear_refs_pte_range) is only using ptep_test_and_clear_young,
though he did change the ptep_test_and_clear_dirty definition to be
consistent with it.  old/young is never so serious as clean/dirty, so
it may be that there's very little problem with what's in there now;
it just becomes a shame if the wrong decision gets made too often e.g.
if the misflushing is such that his clear_youngs never really take
effect.  I simply cannot tell whether or not that's the case myself.

But once the pte_update_defers get moved away from their flush_tlb_pages,
as is the case now, it feels like we're on thin ice.

Actually, I don't really get pte_update_defer at all: I can understand
wanting to defer a call down, but it appears to be a call down to say
we're deferring the shadow update?  Why not just do it with pte_update?
I'd be happier without it until this could be restructured more safely
(but my incomprehension is not necessarily the best guiding principle).

Hugh
