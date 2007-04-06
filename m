Return-Path: <linux-kernel-owner+w=401wt.eu-S1767601AbXDFNDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767601AbXDFNDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767602AbXDFNDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:03:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:26680 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767601AbXDFNDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:03:20 -0400
X-AuditID: d80ac287-91523bb000000c42-32-461645179358 
Date: Fri, 6 Apr 2007 14:02:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org,
       "Pierre.Peiffer" <Pierre.Peiffer@bull.net>
Subject: Re: Shared futexes (was [PATCH] FUTEX : new PRIVATE futexes)
In-Reply-To: <1175862369.6483.173.camel@twins>
Message-ID: <Pine.LNX.4.64.0704061353330.18160@blonde.wat.veritas.com>
References: <20060808070708.GA3931@localhost.localdomain> 
 <200608090826.28249.dada1@cosmosbay.com>  <200608090843.52893.dada1@cosmosbay.com>
  <200703152010.35614.dada1@cosmosbay.com>  <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
  <20070405194942.1414c030.dada1@cosmosbay.com> <1175862369.6483.173.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 06 Apr 2007 13:02:53.0320 (UTC) FILETIME=[E3361080:01C7784B]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Peter Zijlstra wrote:
> 
> some thoughts on shared futexes;
> 
> Could we get rid of the mmap_sem on the shared futexes in the following
> manner:
> 
>  - do a page table walk to find the pte;

("walk" meaning descent down the levels, I presume, rather than across)

I've not had time to digest your proposal, and I'm about to go out:
let me sound a warning that springs to mind, maybe it's entirely
inapproriate, but better said than kept silent.

It looks as if you're supposing that mmap_sem is needed to find_vma,
but not for going down the pagetables.  It's not a simple as that:
you need to be careful that a concurrent munmap from another thread
isn't freeing pagetables from under you.

Holding (down_read) of mmap_sem is one way to protect against that.
try_to_unmap doesn't have that luxury: in its case, it's made safe
by the way free_pgtables does anon_vma_unlink and unlink_file_vma
before freeing any pagetables, so try_to_unmap etc. won't get there;
but you can't do that.

Hugh

>  - get a page using pfn_to_page (skipping VM_PFNMAP)
>  - get the futex key from page->mapping->host and page->index
>    and offset from addr % PAGE_SIZE.
> 
> or given a key:
> 
>  - lookup the page from key.shared.inode->i_mapping by key.shared.pgoff
>    possibly loading the page using mapping->a_ops->readpage().
> 
> then:
> 
>  - perform the futex operation on a kmap of the page
> 
> 
> This should all work except for VM_PFNMAP.
> 
> Since the address is passed from userspace we cannot trust it to not
> point into a VM_PFNMAP area.
> 
> However, with the RCU VMA lookup patches I'm working on we could do that
> check without holding locks and without exclusive cachelines; the
> question is, is that good enough?
> 
> Or is there an alternative way of determining a pfnmap given a
> pfn/struct page?
> 
