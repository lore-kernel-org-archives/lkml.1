Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYGKLDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYGKLDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYGKLBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbYGKLBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:35 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/18] [GFS2] Revise readpage locking
Date: Fri, 11 Jul 2008 11:11:07 +0100
Message-Id: <12157710973601-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157710954145-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The previous attempt to fix the locking in readpage failed due
to the use of a "try lock" which resulted in occasional high
cpu usage during testing (due to repeated tries) and also it
did not resolve all the ordering problems wrt the transaction
lock (although it did solve all the inode lock ordering problems).

This patch avoids the problem by unlocking the page and getting the
locks in the correct order. This means that we have to retest the
page to ensure that it hasn't changed when we relock the page.

This now passes the tests which were previously failing.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 2b556dd..e64a1b0 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -499,31 +499,34 @@ static int __gfs2_readpage(void *file, struct page *page)
  * @file: The file to read
  * @page: The page of the file
  *
- * This deals with the locking required. We use a trylock in order to
- * avoid the page lock / glock ordering problems returning AOP_TRUNCATED_PAGE
- * in the event that we are unable to get the lock.
+ * This deals with the locking required. We have to unlock and
+ * relock the page in order to get the locking in the right
+ * order.
  */
 
 static int gfs2_readpage(struct file *file, struct page *page)
 {
-	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
+	struct address_space *mapping = page->mapping;
+	struct gfs2_inode *ip = GFS2_I(mapping->host);
 	struct gfs2_holder gh;
 	int error;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME|LM_FLAG_TRY_1CB, &gh);
+	unlock_page(page);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, &gh);
 	error = gfs2_glock_nq_atime(&gh);
-	if (unlikely(error)) {
-		unlock_page(page);
+	if (unlikely(error))
 		goto out;
-	}
-	error = __gfs2_readpage(file, page);
+	error = AOP_TRUNCATED_PAGE;
+	lock_page(page);
+	if (page->mapping == mapping && !PageUptodate(page))
+		error = __gfs2_readpage(file, page);
+	else
+		unlock_page(page);
 	gfs2_glock_dq(&gh);
 out:
 	gfs2_holder_uninit(&gh);
-	if (error == GLR_TRYFAILED) {
-		yield();
-		return AOP_TRUNCATED_PAGE;
-	}
+	if (error && error != AOP_TRUNCATED_PAGE)
+		lock_page(page);
 	return error;
 }
 
-- 
1.5.1.2

