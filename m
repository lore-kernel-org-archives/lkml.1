Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbXIUSHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbXIUSHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbXIUSHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:07:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:52778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbXIUSHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:07:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,284,1186383600"; 
   d="scan'208";a="283777562"
Date: Fri, 21 Sep 2007 11:07:42 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: torvalds@linux-foundation.org, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: x86_64: potential critical issue with quicklists and page table pages
Message-ID: <20070921180742.GH20863@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

git commit 34feb2c83beb3bdf13535a36770f7e50b47ef299 started using quicklists
for freeing page table pages and removed the usage of tlb_remove_page()

And looking at quicklist_free() and quicklist_free_page(), on a NUMA platform,
this can potentially free the page before the corresponding TLB caches
are flushed.

Essentially quicklist free routines are doing something like
__quicklist_free()
	...
	if (unlikely(nid != numa_node_id())) {
		__free_page(page);
		...
	}

	....


Now this will potentially cause a problem, if a cpu in someother node starts
using this page, while the corresponding TLB entries are still alive
in the original cpu which is still freeing the page table pages.

This violates the guideline documented in
http://developer.intel.com/design/processor/applnots/317080.pdf

This potentially can cause SW failures and hard to debug issues like
http://www.ussg.iu.edu/hypermail/linux/kernel/0205.2/1254.html

Can we revert this commit for 2.6.23 and look at this code post 2.6.23?

thanks,
suresh
