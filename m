Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbZHNPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbZHNPFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbZHNPFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:05:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40120 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbZHNPFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:05:36 -0400
To: jens.axboe@oracle.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] splice: update mtime and atime on files
Message-Id: <E1MbyLM-0006Xd-OE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Aug 2009 17:05:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Splice should update the modification and access times on regular
files just like read and write.  Not updating mtime will confuse
backup tools, etc...

This patch only adds the time updates for regular files.  For pipes
and other special files that splice touches the need for updating the
times is less clear.  Let's discuss and fix that separately.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2009-07-03 13:12:06.000000000 +0200
+++ linux-2.6/fs/splice.c	2009-07-21 17:58:52.000000000 +0200
@@ -502,8 +502,10 @@ ssize_t generic_file_splice_read(struct
 		len = left;
 
 	ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
-	if (ret > 0)
+	if (ret > 0) {
 		*ppos += ret;
+		file_accessed(in);
+	}
 
 	return ret;
 }
@@ -963,8 +965,10 @@ generic_file_splice_write(struct pipe_in
 
 		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 		ret = file_remove_suid(out);
-		if (!ret)
+		if (!ret) {
+			file_update_time(out);
 			ret = splice_from_pipe_feed(pipe, &sd, pipe_to_file);
+		}
 		mutex_unlock(&inode->i_mutex);
 	} while (ret > 0);
 	splice_from_pipe_end(pipe, &sd);
