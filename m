Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXBEOjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXBEOjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXBEOjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:39:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929AbXBEOjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:39:00 -0500
Subject: [GFS2] Put back semaphore to avoid umount proble
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:47:04 +0000
Message-Id: <1170686824.11001.371.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From eeca71338ea3b4b3bcd829b998b35c015316b134 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 29 Jan 2007 11:51:45 +0000
Subject: [PATCH] [GFS2] Put back semaphore to avoid umount problem

Dave Teigland fixed this bug a while back, but I managed to mistakenly
remove the semaphore during later development. It is required to avoid
the list of inodes changing during an invalidate_inodes call. I have
made it an rwsem since the read side will be taken frequently during
normal filesystem operation. The write site will only happen during
umount of the file system.

Also the bug only triggers when using the DLM lock manager and only then
under certain conditions as its timing related.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: David Teigland <teigland@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c070ede..6618c11 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/lm_interface.h>
 #include <linux/wait.h>
+#include <linux/rwsem.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
@@ -45,6 +46,7 @@ static int dump_glock(struct gfs2_glock *gl);
 static int dump_inode(struct gfs2_inode *ip);
 static void gfs2_glock_xmote_th(struct gfs2_holder *gh);
 static void gfs2_glock_drop_th(struct gfs2_glock *gl);
+static DECLARE_RWSEM(gfs2_umount_flush_sem);
 
 #define GFS2_GL_HASH_SHIFT      15
 #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)
@@ -1578,12 +1580,14 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
 		struct lm_async_cb *async = data;
 		struct gfs2_glock *gl;
 
+		down_read(&gfs2_umount_flush_sem);
 		gl = gfs2_glock_find(sdp, &async->lc_name);
 		if (gfs2_assert_warn(sdp, gl))
 			return;
 		if (!gfs2_assert_warn(sdp, gl->gl_req_bh))
 			gl->gl_req_bh(gl, async->lc_ret);
 		gfs2_glock_put(gl);
+		up_read(&gfs2_umount_flush_sem);
 		return;
 	}
 
@@ -1828,7 +1832,9 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait)
 			t = jiffies;
 		}
 
+		down_write(&gfs2_umount_flush_sem);
 		invalidate_inodes(sdp->sd_vfs);
+		up_write(&gfs2_umount_flush_sem);
 		msleep(10);
 	}
 }
-- 
1.4.4.2



