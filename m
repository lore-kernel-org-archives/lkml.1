Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbZDCIzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbZDCIzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZDCIzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:55:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:9729 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbZDCIzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:55:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="127452424"
Date: Fri, 3 Apr 2009 16:55:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mikew@google.com,
       rientjes@google.com, rohitseth@google.com, hugh@veritas.com,
       a.p.zijlstra@chello.nl, hpa@zytor.com, edwintorok@gmail.com,
       lee.schermerhorn@hp.com, npiggin@suse.de
Subject: [PATCH] vfs: reduce page fault retry code
Message-ID: <20090403085503.GC6084@localhost>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com> <20090331150046.16539218.akpm@linux-foundation.org> <20090403082230.GA6084@localhost> <20090403083559.GB6084@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403083559.GB6084@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_lock_page_retry() works the same way as find_lock_page()
when retry_flag=0. And their return value handling shall work
(almost) in the same way, or it will already be a bug.

So the !retry_flag special casing can be eliminated.

Cc: Ying Han <yinghan@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    7 -------
 1 file changed, 7 deletions(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1663,13 +1663,6 @@ no_cached_page:
 	 * meantime, we'll just come back here and read it again.
 	 */
 	if (error >= 0) {
-		/*
-		 * If caller cannot tolerate a retry in the ->fault path
-		 * go back to check the page again.
-		 */
-		if (!retry_flag)
-			goto retry_find;
-
 		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 					vma, &page, retry_flag);
 		if (retry_ret == VM_FAULT_RETRY)
