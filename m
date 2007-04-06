Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbXDFM0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbXDFM0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 08:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXDFM0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 08:26:14 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:40210 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbXDFM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 08:26:14 -0400
Subject: Shared futexes (was [PATCH] FUTEX : new PRIVATE futexes)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org, hugh <hugh@veritas.com>,
       "Pierre.Peiffer" <Pierre.Peiffer@bull.net>
In-Reply-To: <20070405194942.1414c030.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	 <20070405194942.1414c030.dada1@cosmosbay.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 14:26:09 +0200
Message-Id: <1175862369.6483.173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

some thoughts on shared futexes;

Could we get rid of the mmap_sem on the shared futexes in the following
manner:

 - do a page table walk to find the pte;
 - get a page using pfn_to_page (skipping VM_PFNMAP)
 - get the futex key from page->mapping->host and page->index
   and offset from addr % PAGE_SIZE.

or given a key:

 - lookup the page from key.shared.inode->i_mapping by key.shared.pgoff
   possibly loading the page using mapping->a_ops->readpage().

then:

 - perform the futex operation on a kmap of the page


This should all work except for VM_PFNMAP.

Since the address is passed from userspace we cannot trust it to not
point into a VM_PFNMAP area.

However, with the RCU VMA lookup patches I'm working on we could do that
check without holding locks and without exclusive cachelines; the
question is, is that good enough?

Or is there an alternative way of determining a pfnmap given a
pfn/struct page?

