Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbXIUStQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbXIUStQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760110AbXIUStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:49:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36719 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759454AbXIUSs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:48:59 -0400
Date: Fri, 21 Sep 2007 11:48:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, ak@suse.de,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <20070921180742.GH20863@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0709211145520.17160@schroedinger.engr.sgi.com>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Siddha, Suresh B wrote:

> Essentially quicklist free routines are doing something like
> __quicklist_free()
> 	...
> 	if (unlikely(nid != numa_node_id())) {
> 		__free_page(page);
> 		...
> 	}
> 
> 	....
> 
> 
> Now this will potentially cause a problem, if a cpu in someother node starts
> using this page, while the corresponding TLB entries are still alive
> in the original cpu which is still freeing the page table pages.

Hmmm... Yes could be.

> This potentially can cause SW failures and hard to debug issues like
> http://www.ussg.iu.edu/hypermail/linux/kernel/0205.2/1254.html

Cannot get to this page:

Not Found

The requested URL /hypermail/linux/kernel/0205.2/1254.htm was not found on 
this server.


> Can we revert this commit for 2.6.23 and look at this code post 2.6.23?

We can remove this piece alone since it was an optimization.

---
 include/linux/quicklist.h |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6/include/linux/quicklist.h
===================================================================
--- linux-2.6.orig/include/linux/quicklist.h	2007-09-21 11:46:44.000000000 -0700
+++ linux-2.6/include/linux/quicklist.h	2007-09-21 11:47:01.000000000 -0700
@@ -58,13 +58,6 @@ static inline void __quicklist_free(int 
 	struct quicklist *q;
 	int nid = page_to_nid(page);
 
-	if (unlikely(nid != numa_node_id())) {
-		if (dtor)
-			dtor(p);
-		__free_page(page);
-		return;
-	}
-
 	q = &get_cpu_var(quicklist)[nr];
 	*(void **)p = q->page;
 	q->page = p;
