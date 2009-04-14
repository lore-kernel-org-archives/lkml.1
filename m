Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZDNRti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZDNRti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbZDNRtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:49:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56522 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbZDNRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:49:15 -0400
Message-Id: <20090414174855.048970682@szeredi.hu>
References: <20090414174835.487031939@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 14 Apr 2009 19:48:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com, mfasheh@suse.com
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 2/6] splice: remove i_mutex locking in splice_from_pipe()
Content-Disposition: inline; filename=splice_from_pipe_no_i_mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

splice_from_pipe() is only called from two places:

  - generic_splice_sendpage()
  - splice_write_null()

Neither of these require i_mutex to be taken on the destination inode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-04-14 18:08:03.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-04-14 18:22:53.000000000 +0200
@@ -784,7 +784,7 @@ EXPORT_SYMBOL(__splice_from_pipe);
  * @actor:	handler that splices the data
  *
  * Description:
- *    See __splice_from_pipe. This function locks the input and output inodes,
+ *    See __splice_from_pipe. This function locks the pipe inode,
  *    otherwise it's identical to __splice_from_pipe().
  *
  */
@@ -793,7 +793,6 @@ ssize_t splice_from_pipe(struct pipe_ino
 			 splice_actor *actor)
 {
 	ssize_t ret;
-	struct inode *inode = out->f_mapping->host;
 	struct splice_desc sd = {
 		.total_len = len,
 		.flags = flags,
@@ -801,24 +800,11 @@ ssize_t splice_from_pipe(struct pipe_ino
 		.u.file = out,
 	};
 
-	/*
-	 * The actor worker might be calling ->write_begin and
-	 * ->write_end. Most of the time, these expect i_mutex to
-	 * be held. Since this may result in an ABBA deadlock with
-	 * pipe->inode, we have to order lock acquiry here.
-	 *
-	 * Outer lock must be inode->i_mutex, as pipe_wait() will
-	 * release and reacquire pipe->inode->i_mutex, AND inode must
-	 * never be a pipe.
-	 */
-	WARN_ON(S_ISFIFO(inode->i_mode));
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
 	if (pipe->inode)
-		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
+		mutex_lock(&pipe->inode->i_mutex);
 	ret = __splice_from_pipe(pipe, &sd, actor);
 	if (pipe->inode)
 		mutex_unlock(&pipe->inode->i_mutex);
-	mutex_unlock(&inode->i_mutex);
 
 	return ret;
 }

--
