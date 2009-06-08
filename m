Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZFHDZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZFHDZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 23:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZFHDZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 23:25:40 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:57118
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbZFHDZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 23:25:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAC8hLEp8qWf0/2dsb2JhbADJc4QKBQ
X-IronPort-AV: E=Sophos;i="4.41,322,1241366400"; 
   d="scan'208";a="526280000"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - remove hashed check in validate_wait()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 08 Jun 2009 11:25:37 +0800
Message-ID: <20090608032537.7088.1870.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent ->lookup() deadlock correction required the directory
inode mutex to be dropped while waiting for expire completion. We
were concerned about side effects from this change and one has
been identified.

When checking if a mount has already completed prior to adding a
new mount request to the wait queue we check if the dentry is hashed
and, if so, if it is a mount point. But, if a mount successfully
completed while we slept on the wait queue mutex the dentry must
exist for the mount to have completed so the test is not really
needed.

Mounts can also be done on top of a global root dentry, so for the
above case, where a mount request completes and the wait queue entry
has already been removed, the hashed test returning false can cause
an incorrect callback to the daemon. Also, d_mountpoint() is not
sufficient to check if a mount has completed for the multi-mount
case when we don't have a real mount at the base of the tree.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/waitq.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index eeb2468..2341375 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -297,20 +297,14 @@ static int validate_request(struct autofs_wait_queue **wait,
 	 */
 	if (notify == NFY_MOUNT) {
 		/*
-		 * If the dentry isn't hashed just go ahead and try the
-		 * mount again with a new wait (not much else we can do).
-		*/
-		if (!d_unhashed(dentry)) {
-			/*
-			 * But if the dentry is hashed, that means that we
-			 * got here through the revalidate path.  Thus, we
-			 * need to check if the dentry has been mounted
-			 * while we waited on the wq_mutex. If it has,
-			 * simply return success.
-			 */
-			if (d_mountpoint(dentry))
-				return 0;
-		}
+		 * If the dentry was successfully mounted while we slept
+		 * on the wait queue mutex we can return success. If it
+		 * isn't mounted (doesn't have submounts for the case of
+		 * a multi-mount with no mount at it's base) we can
+		 * continue on and create a new request.
+		 */
+		if (have_submounts(dentry))
+			return 0;
 	}
 
 	return 1;

