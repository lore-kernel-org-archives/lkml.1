Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbXDFNWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbXDFNWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXDFNWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:22:48 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:39204 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbXDFNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:22:48 -0400
Subject: Re: Shared futexes (was [PATCH] FUTEX : new PRIVATE futexes)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org,
       "Pierre.Peiffer" <Pierre.Peiffer@bull.net>
In-Reply-To: <461647F5.5040206@yahoo.com.au>
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	 <20070405194942.1414c030.dada1@cosmosbay.com>
	 <1175862369.6483.173.camel@twins>
	 <Pine.LNX.4.64.0704061353330.18160@blonde.wat.veritas.com>
	 <461647F5.5040206@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 15:22:44 +0200
Message-Id: <1175865764.6483.190.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 23:15 +1000, Nick Piggin wrote:
> Hugh Dickins wrote:
> > On Fri, 6 Apr 2007, Peter Zijlstra wrote:
> > 
> >>some thoughts on shared futexes;
> >>
> >>Could we get rid of the mmap_sem on the shared futexes in the following
> >>manner:
> 
> I'd imagine shared futexes would be much less common than private for
> threaded programs... I'd say we should reevaluate things once we have
> private futexes, and malloc/free stop hammering mmap_sem so hard...

Indeed, private futexes are by far the most common.

> >> - get a page using pfn_to_page (skipping VM_PFNMAP)
> >> - get the futex key from page->mapping->host and page->index
> >>   and offset from addr % PAGE_SIZE.
> >>
> >>or given a key:
> >>
> >> - lookup the page from key.shared.inode->i_mapping by key.shared.pgoff
> >>   possibly loading the page using mapping->a_ops->readpage().
> 
> For shared futexes, wouldn't i_mapping be worse, because you'd be
> ping-ponging the tree_lock between processes, rather than have each
> use their own mmap_sem?

Your lockless pagecache work would solve most of that, no?

> That also only helps for the wakeup case too, doesn't it? You have
> to use the vmas to find out which inode to use to do the wait, I think?
> (unless you introduce a new shared futex API).

one could do something like this:

 struct address_space *mapping = page_mapping(page);
 if (!mapping || mapping == &swapper_space)
   do_private_futex();
 else
   do_shared_futex(mapping->host, page->index, addr % PAGE_SIZE);


But alas, it seems I overlooked that the mmap_sem also protects the page
tables as pointed out by Hugh, so this is all in fain it seems.

A well.

