Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547Ab0AKShB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0AKShB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 13:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436Ab0AKShA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 13:37:00 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:41851 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0AKShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 13:37:00 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] gfs2: Fix refcnt leak on gfs2_follow_link() error path
Date: Tue, 12 Jan 2010 03:36:57 +0900
Message-ID: <87iqb8jxo6.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If ->follow_link handler return the error, it should decrement
nd->path refcnt.

This patch fix it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/gfs2/ops_inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/gfs2/ops_inode.c~namei-gfs2-follow_link-fix fs/gfs2/ops_inode.c
--- linux-2.6/fs/gfs2/ops_inode.c~namei-gfs2-follow_link-fix	2010-01-12 00:15:12.000000000 +0900
+++ linux-2.6-hirofumi/fs/gfs2/ops_inode.c	2010-01-12 00:15:12.000000000 +0900
@@ -1086,7 +1086,8 @@ static void *gfs2_follow_link(struct den
 		error = vfs_follow_link(nd, buf);
 		if (buf != array)
 			kfree(buf);
-	}
+	} else
+		path_put(&nd->path);
 
 	return ERR_PTR(error);
 }
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
