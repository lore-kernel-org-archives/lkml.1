Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbXJ1RcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbXJ1RcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXJ1Rbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:31:50 -0400
Received: from mail.fieldses.org ([66.93.2.214]:34172 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXJ1Rbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:31:49 -0400
Date: Sun, 28 Oct 2007 13:31:37 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] locks: fix possible infinite loop in posix deadlock
	detection
Message-ID: <20071028173136.GA16905@fieldses.org>
References: <20071017185157.GC3785@mvista.com> <20071018185759.GU3785@mvista.com> <20071026170750.GC13033@fieldses.org> <20071026224707.GO13033@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026224707.GO13033@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

I think the real solution is to remove deadlock detection completely;
it's hard to imaagine applications really depend on it anyway.

For now, though, just bail out after a few iterations.

Thanks to George Davis for reporting the problem.

Cc: "George G. Davis" <gdavis@mvista.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 fs/locks.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 0127a28..131aa88 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -696,17 +696,29 @@ EXPORT_SYMBOL(posix_test_lock);
  * Note: the above assumption may not be true when handling lock requests
  * from a broken NFS client. But broken NFS clients have a lot more to
  * worry about than proper deadlock detection anyway... --okir
+ *
+ * However, the failure of this assumption (also possible in the case of
+ * multiple tasks sharing the same open file table) also means there's no
+ * guarantee that the loop below will terminate.  As a hack, we give up
+ * after a few iterations.  We don't bother returning EDEADLK in that case;
+ * the deadlock has probably already happened anyway.
  */
+
+#define MAX_DEADLK_ITERATIONS 10
+
 static int posix_locks_deadlock(struct file_lock *caller_fl,
 				struct file_lock *block_fl)
 {
 	struct file_lock *fl;
+	int i = 0;
 
 next_task:
 	if (posix_same_owner(caller_fl, block_fl))
 		return 1;
 	list_for_each_entry(fl, &blocked_list, fl_link) {
 		if (posix_same_owner(fl, block_fl)) {
+			if (i++ > MAX_DEADLK_ITERATIONS)
+				return 0;
 			fl = fl->fl_next;
 			block_fl = fl;
 			goto next_task;
-- 
1.5.3.4.208.gc990

