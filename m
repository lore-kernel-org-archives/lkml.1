Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbZDNRvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbZDNRvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbZDNRte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:49:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56539 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090AbZDNRtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:49:32 -0400
Message-Id: <20090414174856.453351169@szeredi.hu>
References: <20090414174835.487031939@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 14 Apr 2009 19:48:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: jens.axboe@oracle.com, mfasheh@suse.com
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 3/6] splice: fix i_mutex locking in generic_splice_write()
Content-Disposition: inline; filename=splice_i_mutex_locking_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange locking of i_mutex on destination so it's only held while
buffers are copied with the pipe_to_file() actor, and not while
waiting for more data on the pipe.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-04-14 18:22:53.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-04-14 18:25:13.000000000 +0200
@@ -895,17 +895,29 @@ generic_file_splice_write(struct pipe_in
 	};
 	ssize_t ret;
 
-	WARN_ON(S_ISFIFO(inode->i_mode));
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-	ret = file_remove_suid(out);
-	if (likely(!ret)) {
-		if (pipe->inode)
-			mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_CHILD);
-		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
-		if (pipe->inode)
-			mutex_unlock(&pipe->inode->i_mutex);
-	}
-	mutex_unlock(&inode->i_mutex);
+	if (pipe->inode)
+		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
+
+	splice_from_pipe_begin(&sd);
+	do {
+		ret = splice_from_pipe_next(pipe, &sd);
+		if (ret <= 0)
+			break;
+
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		ret = file_remove_suid(out);
+		if (!ret)
+			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
+		mutex_unlock(&inode->i_mutex);
+	} while (ret > 0);
+	splice_from_pipe_end(pipe, &sd);
+
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+
+	if (sd.num_spliced)
+		ret = sd.num_spliced;
+
 	if (ret > 0) {
 		unsigned long nr_pages;
 

--
