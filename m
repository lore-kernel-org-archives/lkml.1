Return-Path: <linux-kernel-owner+w=401wt.eu-S1767611AbXDFNPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767611AbXDFNPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767613AbXDFNPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:15:08 -0400
Received: from amsfep15-int.chello.nl ([62.179.120.10]:63729 "EHLO
	amsfep15-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbXDFNPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:15:06 -0400
Subject: Re: Shared futexes (was [PATCH] FUTEX : new PRIVATE futexes)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org,
       "Pierre.Peiffer" <Pierre.Peiffer@bull.net>
In-Reply-To: <Pine.LNX.4.64.0704061353330.18160@blonde.wat.veritas.com>
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	 <20070405194942.1414c030.dada1@cosmosbay.com>
	 <1175862369.6483.173.camel@twins>
	 <Pine.LNX.4.64.0704061353330.18160@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 15:15:00 +0200
Message-Id: <1175865300.6483.183.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 14:02 +0100, Hugh Dickins wrote:
> On Fri, 6 Apr 2007, Peter Zijlstra wrote:
> > 
> > some thoughts on shared futexes;
> > 
> > Could we get rid of the mmap_sem on the shared futexes in the following
> > manner:
> > 
> >  - do a page table walk to find the pte;
> 
> ("walk" meaning descent down the levels, I presume, rather than across)

indeed.

> I've not had time to digest your proposal, and I'm about to go out:
> let me sound a warning that springs to mind, maybe it's entirely
> inapproriate, but better said than kept silent.
> 
> It looks as if you're supposing that mmap_sem is needed to find_vma,
> but not for going down the pagetables.  It's not a simple as that:
> you need to be careful that a concurrent munmap from another thread
> isn't freeing pagetables from under you.
> 
> Holding (down_read) of mmap_sem is one way to protect against that.
> try_to_unmap doesn't have that luxury: in its case, it's made safe
> by the way free_pgtables does anon_vma_unlink and unlink_file_vma
> before freeing any pagetables, so try_to_unmap etc. won't get there;
> but you can't do that.

Ah, drad.

I had hoped that the pte_lock would solve that race, but that doesn't
cover the upper levels of the tree.

Back to the drawing board..

