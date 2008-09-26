Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYIZMys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYIZMys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYIZMyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYIZMyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:21 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/12] GFS2: Fix debugfs glock file iterator
Date: Fri, 26 Sep 2008 13:00:44 +0100
Message-Id: <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to an incorrect iterator, some glocks were being missed from the
glock dumps obtained via debugfs. This patch fixes the problem and
ensures that we don't miss any glocks in future.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 13391e5..4cbb695 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1816,15 +1816,17 @@ restart:
 	if (gl) {
 		gi->gl = hlist_entry(gl->gl_list.next,
 				     struct gfs2_glock, gl_list);
-		if (gi->gl)
-			gfs2_glock_hold(gi->gl);
+	} else {
+		gi->gl = hlist_entry(gl_hash_table[gi->hash].hb_list.first,
+				     struct gfs2_glock, gl_list);
 	}
+	if (gi->gl)
+		gfs2_glock_hold(gi->gl);
 	read_unlock(gl_lock_addr(gi->hash));
 	if (gl)
 		gfs2_glock_put(gl);
-	if (gl && gi->gl == NULL)
-		gi->hash++;
 	while (gi->gl == NULL) {
+		gi->hash++;
 		if (gi->hash >= GFS2_GL_HASH_SIZE)
 			return 1;
 		read_lock(gl_lock_addr(gi->hash));
@@ -1833,7 +1835,6 @@ restart:
 		if (gi->gl)
 			gfs2_glock_hold(gi->gl);
 		read_unlock(gl_lock_addr(gi->hash));
-		gi->hash++;
 	}
 
 	if (gi->sdp != gi->gl->gl_sbd)
-- 
1.5.5.1

