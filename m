Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbYDNTD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbYDNTD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYDNTDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:03:40 -0400
Received: from mail.fieldses.org ([66.93.2.214]:59050 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbYDNTDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:03:38 -0400
Date: Mon, 14 Apr 2008 15:03:02 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: trond.myklebust@fys.uio.no, eshel@almaden.ibm.com, neilb@suse.de,
       akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, stable@kernel.org
Subject: [PATCH] locks: fix possible infinite loop in fcntl(F_SETLKW) over
	nfs
Message-ID: <20080414190302.GM15950@fieldses.org>
References: <E1JjcgO-0004q2-VJ@pomaz-ex.szeredi.hu> <E1Jk2oI-0007UX-MS@pomaz-ex.szeredi.hu> <1207861339.8180.14.camel@heimdal.trondhjem.org> <1207861661.8180.18.camel@heimdal.trondhjem.org> <1207862436.8180.30.camel@heimdal.trondhjem.org> <20080410215410.GF22324@fieldses.org> <E1JkOff-0000pS-A7@pomaz-ex.szeredi.hu> <20080413000830.GF31789@fieldses.org> <E1JkxKz-0003A8-9V@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JkxKz-0003A8-9V@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Miklos Szeredi found the bug:

	"Basically what happens is that on the server nlm_fopen() calls
	nfsd_open() which returns -EACCES, to which nlm_fopen() returns
	NLM_LCK_DENIED.

	"On the client this will turn into a -EAGAIN (nlm_stat_to_errno()),
	which in will cause fcntl_setlk() to retry forever."

So, for example, opening a file on an nfs filesystem, changing
permissions to forbid further access, then trying to lock the file,
could result in an infinite loop.

And Trond Myklebust identified the culprit, from Marc Eshel and I:

	7723ec9777d9832849b76475b1a21a2872a40d20 "locks: factor out
	generic/filesystem switch from setlock code"

That commit claimed to just be reshuffling code, but actually introduced
a behavioral change by calling the lock method repeatedly as long as it
returned -EAGAIN.

We assumed this would be safe, since we assumed a lock of type SETLKW
would only return with either success or an error other than -EAGAIN.
However, nfs does can in fact return -EAGAIN in this situation, and
independently of whether that behavior is correct or not, we don't
actually need this change, and it seems far safer not to depend on such
assumptions about the filesystem's ->lock method.

Therefore, revert the problematic part of the original commit.  This
leaves vfs_lock_file() and its other callers unchanged, while returning
fcntl_setlk and fcntl_setlk64 to their former behavior.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Tested-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Marc Eshel <eshel@almaden.ibm.com>
---
 fs/locks.c |   48 ++++++++++++++++++++++++++++--------------------
 1 files changed, 28 insertions(+), 20 deletions(-)

This is appropriate for 2.6.25 (as well as older stable kernels--the bug
was introduced in 2.6.22).

--b.

diff --git a/fs/locks.c b/fs/locks.c
index d83fab1..43c0af2 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1801,17 +1801,21 @@ again:
 	if (error)
 		goto out;
 
-	for (;;) {
-		error = vfs_lock_file(filp, cmd, file_lock, NULL);
-		if (error != -EAGAIN || cmd == F_SETLK)
-			break;
-		error = wait_event_interruptible(file_lock->fl_wait,
-				!file_lock->fl_next);
-		if (!error)
-			continue;
+	if (filp->f_op && filp->f_op->lock != NULL)
+		error = filp->f_op->lock(filp, cmd, file_lock);
+	else {
+		for (;;) {
+			error = posix_lock_file(filp, file_lock, NULL);
+			if (error != -EAGAIN || cmd == F_SETLK)
+				break;
+			error = wait_event_interruptible(file_lock->fl_wait,
+					!file_lock->fl_next);
+			if (!error)
+				continue;
 
-		locks_delete_block(file_lock);
-		break;
+			locks_delete_block(file_lock);
+			break;
+		}
 	}
 
 	/*
@@ -1925,17 +1929,21 @@ again:
 	if (error)
 		goto out;
 
-	for (;;) {
-		error = vfs_lock_file(filp, cmd, file_lock, NULL);
-		if (error != -EAGAIN || cmd == F_SETLK64)
-			break;
-		error = wait_event_interruptible(file_lock->fl_wait,
-				!file_lock->fl_next);
-		if (!error)
-			continue;
+	if (filp->f_op && filp->f_op->lock != NULL)
+		error = filp->f_op->lock(filp, cmd, file_lock);
+	else {
+		for (;;) {
+			error = posix_lock_file(filp, file_lock, NULL);
+			if (error != -EAGAIN || cmd == F_SETLK64)
+				break;
+			error = wait_event_interruptible(file_lock->fl_wait,
+					!file_lock->fl_next);
+			if (!error)
+				continue;
 
-		locks_delete_block(file_lock);
-		break;
+			locks_delete_block(file_lock);
+			break;
+		}
 	}
 
 	/*
-- 
1.5.5.rc1

