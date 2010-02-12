Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0BLMCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:02:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55587 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab0BLMBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:01:06 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 11/12] mm: Take the RCU read lock in rmap_walk_anon
Date: Fri, 12 Feb 2010 12:00:58 +0000
Message-Id: <1265976059-7459-12-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rmap_walk_anon() does not use page_lock_anon_vma() for looking up and
locking an anon_vma. One important difference between page_lock_anon_vma()
and rmap_walk_anon() is that the page_lock_anon_vma() takes the RCU lock
before the lookup so that the anon_vma does not disappear. There does not
appear to be locking in place that prevents the anon_vma disappearing before
the spinlock is taken.

This patch puts a rcu_read_lock() around the anon_vma lookup similar to
what page_lock_anon_vma() does to prevent an accidental use-after-free.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/rmap.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index b468d5f..fb695d3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1233,9 +1233,10 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
 	 * This needs to be reviewed later: avoiding page_lock_anon_vma()
 	 * is risky, and currently limits the usefulness of rmap_walk().
 	 */
+	rcu_read_lock();
 	anon_vma = page_anon_vma(page);
 	if (!anon_vma)
-		return ret;
+		goto out_rcu_unlock;
 	spin_lock(&anon_vma->lock);
 
 	/*
@@ -1256,6 +1257,10 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
 
 out_anon_unlock:
 	spin_unlock(&anon_vma->lock);
+
+out_rcu_unlock:
+	rcu_read_unlock();
+
 	return ret;
 }
 
-- 
1.6.5

