Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0BLMBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:01:53 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55595 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0BLMBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:01:07 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 12/12] mm: Check the anon_vma is still valid in rmap_walk_anon()
Date: Fri, 12 Feb 2010 12:00:59 +0000
Message-Id: <1265976059-7459-13-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite the additional locking added around rmap_walk_anon, bad
references still manage to trigger on ppc64. The most likely cause is a
use-after-free but it's not clear if it's due to a locking problem or
something ppc64 specific. This patch somewhat works around the problem
by checking the contents of the anon_vma make sense before using it but
it needs reviewing by eyes familiar with the page migration code to try
spot where the real problem lies.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/rmap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index fb695d3..462ac86 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1237,6 +1237,8 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
 	anon_vma = page_anon_vma(page);
 	if (!anon_vma)
 		goto out_rcu_unlock;
+	if (!anon_vma->head.next)
+		goto out_rcu_unlock;
 	spin_lock(&anon_vma->lock);
 
 	/*
-- 
1.6.5

