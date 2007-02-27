Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbXB0Tf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbXB0Tf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXB0Tf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:35:28 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60998 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXB0Tf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:35:26 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/5] lumpy: ensure that we compare PageActive and active safely
References: <exportbomb.1172604830@kernel>
InReply-To: <exportbomb.1172604830@kernel>
Message-ID: <e64dea44318a03a559d7a230d9b14e42@kernel>
Date: Tue, 27 Feb 2007 11:35:23 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we are passing in a boolean active flag we need to
ensure that the result of PageActive(page) is comparible
to that boolean.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b878d54..2bfad79 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -632,7 +632,12 @@ static int __isolate_lru_page(struct page *page, int active)
 {
 	int ret = -EINVAL;
 
-	if (PageLRU(page) && (PageActive(page) == active)) {
+	/*
+	 * When checking the active state, we need to be sure we are
+	 * dealing with comparible boolean values.  Take the logical not
+	 * of each.
+	 */
+	if (PageLRU(page) && (!PageActive(page) == !active)) {
 		ret = -EBUSY;
 		if (likely(get_page_unless_zero(page))) {
 			/*
