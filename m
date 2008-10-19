Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbYJSODd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbYJSODd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 10:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYJSODK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 10:03:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:6165 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYJSODI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 10:03:08 -0400
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitri Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ocfs2: truncate outstanding block after direct io failure.
Date: Sun, 19 Oct 2008 18:03:01 +0400
Message-Id: <1224424981-5144-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224424981-5144-1-git-send-email-dmonakhov@openvz.org>
References: <>
 <1224424981-5144-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/ocfs2/file.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8d3225a..0b68b30 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1867,6 +1867,13 @@ relock:
 		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
 						    ppos, count, ocount);
 		if (written < 0) {
+			/*
+			 * direct write may have instantiated a few
+			 * blocks outside i_size. Trim these off again.
+			 * Don't need i_size_read because we hold i_mutex.
+			 */
+			if (*ppos + count > inode->i_size)
+				vmtruncate(inode, inode->i_size);
 			ret = written;
 			goto out_dio;
 		}
-- 
1.5.4.3

