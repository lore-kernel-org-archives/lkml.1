Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbZHGUQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbZHGUQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbZHGUQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:16:32 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9563 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbZHGUQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:16:32 -0400
Subject: [PATCH] Remove double removal of blktrace directory
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: lizf@cn.fujitsu.com, Jens Axboe <jens.axboe@oracle.com>, mingo@elte.hu,
       raspl@linux.vnet.ibm.com
Content-Type: multipart/mixed; boundary="=-knyGGx+RHbOpzByYNfD6"
Date: Fri, 07 Aug 2009 16:16:29 -0400
Message-Id: <1249676189.25874.4.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-knyGGx+RHbOpzByYNfD6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-knyGGx+RHbOpzByYNfD6
Content-Disposition: attachment; filename="patch.txt"
Content-Type: text/plain; name="patch.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Remove double removal of blktrace directory

commit fd51d251e4cdb21f68e9dbc4336514d64a105a79
Author: Stefan Raspl <raspl@linux.vnet.ibm.com>
Date:   Tue May 19 09:59:08 2009 +0200

    blktrace: remove debugfs entries on bad path

added in an explicit invocation of debugfs_remove for bt->dir, in
blk_remove_buf_file_callback we are also getting the directory removed. On
occasion I am seeing memory corruption that I have bisected down to
this commit. [The testing involves a (long) series of I/O benchmarks
with blktrace invoked around the actual runs.] I believe that this
committed patch is correct, but the problem actually lies in the code
in blk_remove_buf_file_callback.

With this patch I am able to consistently get complete runs whereas
previously I could not get a single run to complete.

The first part of the patch simply moves the debugfs_remove below the
relay_close: the relay_close call will remove files under bt->dir, and
so we should not remove the directory until all the files we created
have been removed. (Note: This is not sufficient to fix the problem -
the file system code has ref counts on the directoy, so our invocation
does not cause the directory to actually be removed. Nonetheless, we
should not rely upon that feature.)

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 kernel/trace/blktrace.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1090b0a..7a34cb5 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -267,8 +267,8 @@ static void blk_trace_free(struct blk_trace *bt)
 {
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
-	debugfs_remove(bt->dir);
 	relay_close(bt->rchan);
+	debugfs_remove(bt->dir);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
@@ -378,18 +378,8 @@ static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
-	struct dentry *parent = dentry->d_parent;
 	debugfs_remove(dentry);
 
-	/*
-	* this will fail for all but the last file, but that is ok. what we
-	* care about is the top level buts->name directory going away, when
-	* the last trace file is gone. Then we don't have to rmdir() that
-	* manually on trace stop, so it nicely solves the issue with
-	* force killing of running traces.
-	*/
-
-	debugfs_remove(parent);
 	return 0;
 }
 
-- 
1.6.0.4



--=-knyGGx+RHbOpzByYNfD6--

