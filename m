Return-Path: <linux-kernel-owner+w=401wt.eu-S934141AbYDQBbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbYDQBbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761315AbYDQBKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:10:16 -0400
Received: from sous-sol.org ([216.99.217.87]:59040 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760846AbYDQBKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:10:13 -0400
Message-Id: <20080417010406.094519762@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Marc Eshel <eshel@almaden.ibm.com>
Subject: locks: fix possible infinite loop in fcntl(F_SETLKW) over nfs
Content-Disposition: inline; filename=locks-fix-possible-infinite-loop-in-fcntl-over-nfs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

upstream commit: 19e729a928172103e101ffd0829fd13e68c13f78

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/locks.c |   48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1805,17 +1805,21 @@ again:
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
@@ -1929,17 +1933,21 @@ again:
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
