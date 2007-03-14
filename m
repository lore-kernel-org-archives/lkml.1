Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXCNPzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXCNPzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXCNPzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:55:01 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:37997 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbXCNPzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:55:00 -0400
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [PATCH] splice: partial write handling fix
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Wed, 14 Mar 2007 18:55:20 +0300
Message-ID: <871wjrg6qf.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

currently if partial write has happened while ->commit_write() then page
wasn't marked as accessed and rebalanced. 

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>

diff --git a/fs/splice.c b/fs/splice.c
index 2fca6eb..bb1bf62 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -682,18 +682,25 @@ find_page:
 	}
 
 	ret = mapping->a_ops->commit_write(file, page, offset, offset+this_len);
-	if (!ret) {
+	if (ret) {
+		if(ret == AOP_TRUNCATED_PAGE) {
+			page_cache_release(page);
+			goto find_page;
+		}
+		if (ret < 0)
+			goto out;
 		/*
-		 * Return the number of bytes written and mark page as
-		 * accessed, we are now done!
+		 * Partial write has happened, so 'ret' already initialized by
+		 * number of bytes written, Where is nothing we have to do here.
 		 */
+	} else
 		ret = this_len;
-		mark_page_accessed(page);
-		balance_dirty_pages_ratelimited(mapping);
-	} else if (ret == AOP_TRUNCATED_PAGE) {
-		page_cache_release(page);
-		goto find_page;
-	}
+	/*
+	 * Return the number of bytes written and mark page as
+	 * accessed, we are now done!
+	 */
+	mark_page_accessed(page);
+	balance_dirty_pages_ratelimited(mapping);
 out:
 	page_cache_release(page);
 	unlock_page(page);

