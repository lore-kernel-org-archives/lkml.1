Return-Path: <linux-kernel-owner+w=401wt.eu-S1945901AbXDLHj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945901AbXDLHj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945920AbXDLHj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:39:29 -0400
Received: from amsfep17-int.chello.nl ([62.179.120.12]:27767 "EHLO
	amsfep17-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945901AbXDLHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:39:28 -0400
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhao Forrest <forrest.zhao@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070411153040.a7e6c3b8.akpm@linux-foundation.org>
References: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
	 <20070411153040.a7e6c3b8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 09:39:25 +0200
Message-Id: <1176363565.6893.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 15:30 -0700, Andrew Morton wrote:

> There used to be a cond_resched() in invalidate_mapping_pages() which would
> have prevented this, but I rudely removed it to support
> /proc/sys/vm/drop_caches (which needs to call invalidate_inode_pages()
> under spinlock).
> 
> We could resurrect that cond_resched() by passing in some flag, I guess. 
> Or change the code to poke the softlockup detector.  The former would be
> better.

cond_resched() is conditional on __resched_legal(0), which should take
care of being called under a spinlock.

so I guess we can just reinstate the call in invalidate_mapping_pages()

(still waiting on the compile to finish...)
---
invalidate_mapping_pages() is called under locks (usually preemptable)
but can do a _lot_ of work, stick in a voluntary preemption point to
avoid excessive latencies (over 10 seconds was reported by softlockup).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/truncate.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-mm/mm/truncate.c
===================================================================
--- linux-2.6-mm.orig/mm/truncate.c
+++ linux-2.6-mm/mm/truncate.c
@@ -292,6 +292,8 @@ unsigned long invalidate_mapping_pages(s
 			pgoff_t index;
 			int lock_failed;
 
+			cond_resched();
+
 			lock_failed = TestSetPageLocked(page);
 
 			/*


