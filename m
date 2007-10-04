Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbXJDJSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbXJDJSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbXJDJRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759273AbXJDJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:22 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/51] [GFS2] Fix an oops in glock dumping
Date: Thu,  4 Oct 2007 09:48:58 +0100
Message-Id: <11914877993073-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914877971413-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This fixes an oops which was occurring during glock dumping due to the
seq file code not taking a reference to the glock. Also this fixes a
memory leak which occurred in certain cases, in turn preventing the
filesystem from unmounting.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index d403fd7..e4bc8ae 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -46,7 +46,6 @@ struct glock_iter {
 	int hash;                     /* hash bucket index         */
 	struct gfs2_sbd *sdp;         /* incore superblock         */
 	struct gfs2_glock *gl;        /* current glock struct      */
-	struct hlist_head *hb_list;   /* current hash bucket ptr   */
 	struct seq_file *seq;         /* sequence file for debugfs */
 	char string[512];             /* scratch space             */
 };
@@ -1990,47 +1989,38 @@ int __init gfs2_glock_init(void)
 
 static int gfs2_glock_iter_next(struct glock_iter *gi)
 {
+	struct gfs2_glock *gl;
+
 	read_lock(gl_lock_addr(gi->hash));
-	while (1) {
-		if (!gi->hb_list) {  /* If we don't have a hash bucket yet */
-			gi->hb_list = &gl_hash_table[gi->hash].hb_list;
-			if (hlist_empty(gi->hb_list)) {
-				read_unlock(gl_lock_addr(gi->hash));
-				gi->hash++;
-				read_lock(gl_lock_addr(gi->hash));
-				gi->hb_list = NULL;
-				if (gi->hash >= GFS2_GL_HASH_SIZE) {
-					read_unlock(gl_lock_addr(gi->hash));
-					return 1;
-				}
-				else
-					continue;
-			}
-			if (!hlist_empty(gi->hb_list)) {
-				gi->gl = list_entry(gi->hb_list->first,
-						    struct gfs2_glock,
-						    gl_list);
-			}
-		} else {
-			if (gi->gl->gl_list.next == NULL) {
-				read_unlock(gl_lock_addr(gi->hash));
-				gi->hash++;
-				read_lock(gl_lock_addr(gi->hash));
-				gi->hb_list = NULL;
-				continue;
-			}
-			gi->gl = list_entry(gi->gl->gl_list.next,
-					    struct gfs2_glock, gl_list);
-		}
+	gl = gi->gl;
+	if (gl) {
+		gi->gl = hlist_entry(gl->gl_list.next, struct gfs2_glock,
+				     gl_list);
 		if (gi->gl)
-			break;
+			gfs2_glock_hold(gi->gl);
 	}
 	read_unlock(gl_lock_addr(gi->hash));
+	if (gl)
+		gfs2_glock_put(gl);
+
+	while(gi->gl == NULL) {
+		gi->hash++;
+		if (gi->hash >= GFS2_GL_HASH_SIZE)
+			return 1;
+		read_lock(gl_lock_addr(gi->hash));
+		gi->gl = hlist_entry(gl_hash_table[gi->hash].hb_list.first,
+				     struct gfs2_glock, gl_list);
+		if (gi->gl)
+			gfs2_glock_hold(gi->gl);
+		read_unlock(gl_lock_addr(gi->hash));
+	}
 	return 0;
 }
 
 static void gfs2_glock_iter_free(struct glock_iter *gi)
 {
+	if (gi->gl)
+		gfs2_glock_put(gi->gl);
 	kfree(gi);
 }
 
@@ -2044,12 +2034,17 @@ static struct glock_iter *gfs2_glock_iter_init(struct gfs2_sbd *sdp)
 
 	gi->sdp = sdp;
 	gi->hash = 0;
-	gi->gl = NULL;
-	gi->hb_list = NULL;
 	gi->seq = NULL;
 	memset(gi->string, 0, sizeof(gi->string));
 
-	if (gfs2_glock_iter_next(gi)) {
+	read_lock(gl_lock_addr(gi->hash));
+	gi->gl = hlist_entry(gl_hash_table[gi->hash].hb_list.first,
+			     struct gfs2_glock, gl_list);
+	if (gi->gl)
+		gfs2_glock_hold(gi->gl);
+	read_unlock(gl_lock_addr(gi->hash));
+
+	if (!gi->gl && gfs2_glock_iter_next(gi)) {
 		gfs2_glock_iter_free(gi);
 		return NULL;
 	}
@@ -2066,7 +2061,7 @@ static void *gfs2_glock_seq_start(struct seq_file *file, loff_t *pos)
 	if (!gi)
 		return NULL;
 
-	while (n--) {
+	while(n--) {
 		if (gfs2_glock_iter_next(gi)) {
 			gfs2_glock_iter_free(gi);
 			return NULL;
@@ -2093,7 +2088,9 @@ static void *gfs2_glock_seq_next(struct seq_file *file, void *iter_ptr,
 
 static void gfs2_glock_seq_stop(struct seq_file *file, void *iter_ptr)
 {
-	/* nothing for now */
+	struct glock_iter *gi = iter_ptr;
+	if (gi)
+		gfs2_glock_iter_free(gi);
 }
 
 static int gfs2_glock_seq_show(struct seq_file *file, void *iter_ptr)
-- 
1.5.1.2

