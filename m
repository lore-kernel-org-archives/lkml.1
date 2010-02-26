Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877Ab0BZOcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:32:54 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:46706 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964839Ab0BZOcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:32:53 -0500
Date: Fri, 26 Feb 2010 15:32:32 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: mm: used-once mapped file page detection
Message-ID: <20100226143232.GA13001@cmpxchg.org>
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org> <20100224133946.a5092804.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224133946.a5092804.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 01:39:46PM -0800, Andrew Morton wrote:
> On Mon, 22 Feb 2010 20:49:07 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > This patch makes the VM be more careful about activating mapped file
> > pages in the first place.  The minimum granted lifetime without
> > another memory access becomes an inactive list cycle instead of the
> > full memory cycle, which is more natural given the mentioned loads.
> 
> iirc from a long time ago, the insta-activation of mapped pages was
> done because people were getting peeved about having their interactive
> applications (X, browser, etc) getting paged out, and bumping the pages
> immediately was found to help with this subjective problem.
> 
> So it was a latency issue more than a throughput issue.  I wouldn't be
> surprised if we get some complaints from people for the same reasons as
> a result of this patch.

Agreed.  Although we now have other things in place to protect them once
they are active (VM_EXEC protection, lazy active list scanning).

> I guess that during the evaluation period of this change, it would be
> useful to have a /proc knob which people can toggle to revert to the
> old behaviour.  So they can verify that this patchset was indeed the
> cause of the deterioration, and so they can easily quantify any
> deterioration?

Sounds like a good idea.  By evaluation period, do you mean -mm?  Or
would this knob make it upstream as well?

	Hannes

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: vmscan: add sysctl to revert mapped file heuristics

During the evaluation period of the used-once mapped file detection,
provide a sysctl to disable the heuristics at runtime, allowing users
to verify it as a source of problems.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/swap.h |    1 +
 kernel/sysctl.c      |    7 +++++++
 mm/vmscan.c          |    4 +++-
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a2602a8..0c1e724 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -254,6 +254,7 @@ extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern long vm_total_pages;
+extern int vm_rigid_filemap_protection;
 
 #ifdef CONFIG_NUMA
 extern int zone_reclaim_mode;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a68b24..9fa46fb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1050,6 +1050,13 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+	{
+		.procname	= "rigid_filemap_protection",
+		.data		= &vm_rigid_filemap_protection,
+		.maxlen		= sizeof(vm_rigid_filemap_protection),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #ifdef CONFIG_HUGETLB_PAGE
 	{
 		.procname	= "nr_hugepages",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 819fff7..d494153 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -565,6 +565,8 @@ enum page_references {
 	PAGEREF_ACTIVATE,
 };
 
+int vm_rigid_filemap_protection __read_mostly;
+
 static enum page_references page_check_references(struct page *page,
 						  struct scan_control *sc)
 {
@@ -586,7 +588,7 @@ static enum page_references page_check_references(struct page *page,
 		return PAGEREF_RECLAIM;
 
 	if (referenced_ptes) {
-		if (PageAnon(page))
+		if (PageAnon(page) || vm_rigid_filemap_protection)
 			return PAGEREF_ACTIVATE;
 		/*
 		 * All mapped pages start out with page table
-- 
1.6.6.1
