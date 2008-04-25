Return-Path: <linux-kernel-owner+w=401wt.eu-S1765200AbYDYR7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765200AbYDYR7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbYDYR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55838 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764786AbYDYR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:02 -0400
Message-Id: <20080425175700.352606530@szeredi.hu>
References: <20080425175520.735386844@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 25 Apr 2008 19:55:25 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 5/5] fuse: fix sparse warnings
Content-Disposition: inline; filename=fuse_sparse_fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

fs/fuse/dev.c:306:2: warning: context imbalance in 'wait_answer_interruptible' - unexpected unlock
fs/fuse/dev.c:361:2: warning: context imbalance in 'request_wait_answer' - unexpected unlock
fs/fuse/dev.c:1002:4: warning: context imbalance in 'end_io_requests' - unexpected unlock

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c	2008-04-25 18:48:08.000000000 +0200
+++ linux/fs/fuse/dev.c	2008-04-25 18:48:28.000000000 +0200
@@ -299,6 +299,7 @@ static void request_end(struct fuse_conn
 
 static void wait_answer_interruptible(struct fuse_conn *fc,
 				      struct fuse_req *req)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	if (signal_pending(current))
 		return;
@@ -315,8 +316,8 @@ static void queue_interrupt(struct fuse_
 	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
 }
 
-/* Called with fc->lock held.  Releases, and then reacquires it. */
 static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	if (!fc->no_interrupt) {
 		/* Any signal may interrupt this */
@@ -987,6 +988,7 @@ static void end_requests(struct fuse_con
  * locked).
  */
 static void end_io_requests(struct fuse_conn *fc)
+	__releases(fc->lock) __acquires(fc->lock)
 {
 	while (!list_empty(&fc->io)) {
 		struct fuse_req *req =

--
