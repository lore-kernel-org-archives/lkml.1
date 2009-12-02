Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZLBOP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZLBOP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZLBOP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:15:58 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47989 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbZLBOPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:15:03 -0500
Date: Wed, 2 Dec 2009 14:15:05 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] hugetlb: Abort a hugepage pool resize if a signal is
	pending
Message-ID: <20091202141504.GE1457@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user asks for a hugepage pool resize but specified a large number, the
machine can begin trashing. In response, they might hit ctrl-c but signals
are ignored and the pool resize continues until it fails an allocation. This
can take a considerable amount of time so this patch aborts a pool resize
if a signal is pending.

[dave@linux.vnet.ibm.com: His idea]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/hugetlb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index af02ee8..a952cb8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1238,6 +1238,9 @@ static unsigned long set_max_huge_pages(struct hstate *h, unsigned long count)
 		if (!ret)
 			goto out;
 
+		/* Bail for signals. Probably ctrl-c from user */
+		if (signal_pending(current))
+			goto out;
 	}
 
 	/*
