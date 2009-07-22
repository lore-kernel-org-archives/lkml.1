Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZGVL2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZGVL2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZGVL2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:28:23 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:45959 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZGVL2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:28:22 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: smfrench@gmail.com, hch@infradead.org
Subject: [PATCH] fix offset checks in do_sendfile to use unsigned values
Date: Wed, 22 Jul 2009 07:28:19 -0400
Message-Id: <1248262099-12514-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1248262099-12514-1-git-send-email-jlayton@redhat.com>
References: <1248262099-12514-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If do_sendfile is called with a "max" value of 0, it grabs the lesser
s_maxbytes value of the two superblocks to use instead. There's a
problem here however. s_maxbytes is an unsigned long long and it gets
cast to a signed value. If both s_maxbytes values are large enough, max
will end up being negative and the comparisons in this code won't work
correctly.

Change do_sendfile to use unsigned values internally for the offset
checks.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/read_write.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6c8c55d..36899ff 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -788,11 +788,11 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 }
 
 static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
-			   size_t count, loff_t max)
+			   size_t count, unsigned long long max)
 {
 	struct file * in_file, * out_file;
 	struct inode * in_inode, * out_inode;
-	loff_t pos;
+	unsigned long long pos;
 	ssize_t retval;
 	int fput_needed_in, fput_needed_out, fl;
 
@@ -838,7 +838,7 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	if (!max)
 		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
 
-	pos = *ppos;
+	pos = (unsigned long long) *ppos;
 	retval = -EINVAL;
 	if (unlikely(pos < 0))
 		goto fput_out;
-- 
1.6.0.6

