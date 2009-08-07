Return-Path: <linux-kernel-owner+w=401wt.eu-S932971AbZHGS6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbZHGS6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbZHGS6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:58:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912AbZHGS6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:58:37 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: [PATCH 4/4] vfs: remove redundant checks in do_sendfile
Date: Fri,  7 Aug 2009 14:57:41 -0400
Message-Id: <1249671461-9071-5-git-send-email-jlayton@redhat.com>
In-Reply-To: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Johannes Weiner pointed out, a couple of the range checks in do_sendfile
are redundant and are already checked in rw_verify_area.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/read_write.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6c8c55d..9c3d98b 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -792,7 +792,6 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 {
 	struct file * in_file, * out_file;
 	struct inode * in_inode, * out_inode;
-	loff_t pos;
 	ssize_t retval;
 	int fput_needed_in, fput_needed_out, fl;
 
@@ -838,17 +837,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	if (!max)
 		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
 
-	pos = *ppos;
 	retval = -EINVAL;
-	if (unlikely(pos < 0))
-		goto fput_out;
-	if (unlikely(pos + count > max)) {
-		retval = -EOVERFLOW;
-		if (pos >= max)
-			goto fput_out;
-		count = max - pos;
-	}
-
 	fl = 0;
 #if 0
 	/*
-- 
1.6.0.6

