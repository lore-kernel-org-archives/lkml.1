Return-Path: <linux-kernel-owner+w=401wt.eu-S932540AbXGUUih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbXGUUih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762338AbXGUUi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:38:29 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59310 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762360AbXGUUi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:38:27 -0400
Subject: Re: [PATCH 1/3] readahead: drop behind
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <1185049747.27915.8.camel@perkele>
References: <20070721210005.000228000@chello.nl>
	 <20070721210051.975382000@chello.nl>  <1185049747.27915.8.camel@perkele>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 22:37:56 +0200
Message-Id: <1185050276.5652.23.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 16:29 -0400, Eric St-Laurent wrote:
> On Sat, 2007-21-07 at 23:00 +0200, Peter Zijlstra wrote:
> > plain text document attachment (readahead-useonce.patch)
> > Use the read-ahead code to provide hints to page reclaim.
> > 
> > This patch has the potential to solve the streaming-IO trashes my
> > desktop problem.
> > 
> > It tries to aggressively reclaim pages that were loaded in a strong
> > sequential pattern and have been consumed. Thereby limiting the damage
> > to the current resident set.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> With the fadvise change, it looks like the right solution to me.
> 
> The patches are for which kernel? They doesn't apply cleanly to
> 2.6.22.1.

They are against git of a few hours ago and the latest readahead patches
from Wu (which don't apply cleanly either, but the rejects are trivial).

> It would be useful to have a temporary /proc tunable to enable/disable
> the heuristic to help test the effects.

Right, I had such a patch somewhere,.. won't apply cleanly but should be
obvious..

---
 kernel/sysctl.c |    9 +++++++++
 mm/readahead.c  |    6 ++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -168,6 +168,7 @@ extern int dirty_ratio_handler(ctl_table
 
 extern int prove_locking;
 extern int lock_stat;
+extern int sysctl_dropbehind;
 
 /* The default sysctl tables: */
 
@@ -1075,6 +1076,14 @@ static ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "drop_behind",
+		.data		= &sysctl_dropbehind,
+		.maxlen		= sizeof(sysctl_dropbehind),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
Index: linux-2.6/mm/readahead.c
===================================================================
--- linux-2.6.orig/mm/readahead.c
+++ linux-2.6/mm/readahead.c
@@ -429,6 +429,8 @@ void page_cache_sync_readahead(struct ad
 }
 EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
 
+int sysctl_dropbehind = 2;
+
 /**
  * page_cache_async_readahead - file readahead for marked pages
  * @mapping: address_space which holds the pagecache and I/O vectors
@@ -473,7 +475,7 @@ page_cache_async_readahead(struct addres
 	 * hint that there is sequential IO, which implies that the pages that
 	 * have been used thus far can be reclaimed
 	 */
-	if (ra->size == ra->ra_pages) {
+	if (sysctl_dropbehind && ra->size == ra->ra_pages) {
 		unsigned long demote_idx = offset - min(offset, ra->size);
 
 		read_lock_irq(&mapping->tree_lock);
@@ -489,7 +491,7 @@ page_cache_async_readahead(struct addres
 			 * users. We should not take away somebody else's
 			 * pages, so do not drop behind beyond this point.
 			 */
-			if (PageActive(page))
+			if (sysctl_dropbehind > 1 && PageActive(page))
 				break;
 
 			lru_demote(page);


