Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbXJDJ1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbXJDJ1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbXJDJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759521AbXJDJSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:05 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>,
       "S. Wendy Cheng" <wcheng@redhat.com>
Subject: [PATCH 27/51] [GFS2] Wendy's dump lockname in hex & fix glock dump
Date: Thu,  4 Oct 2007 09:49:20 +0100
Message-Id: <11914878401428-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878383633-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

With this patch, gfs2 glockdump through the debugfs filesystem will only
dump glocks for the specified filesystem instead of all glocks. Also, to
aid debugging, the glock number is dumped in hex instead of decimal.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 559937c..3d94918 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1844,7 +1844,7 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 
 	spin_lock(&gl->gl_spin);
 
-	print_dbg(gi, "Glock 0x%p (%u, %llu)\n", gl, gl->gl_name.ln_type,
+	print_dbg(gi, "Glock 0x%p (%u, 0x%llx)\n", gl, gl->gl_name.ln_type,
 		   (unsigned long long)gl->gl_name.ln_number);
 	print_dbg(gi, "  gl_flags =");
 	for (x = 0; x < 32; x++) {
@@ -2024,20 +2024,21 @@ static int gfs2_glock_iter_next(struct glock_iter *gi)
 {
 	struct gfs2_glock *gl;
 
+restart:
 	read_lock(gl_lock_addr(gi->hash));
 	gl = gi->gl;
 	if (gl) {
-		gi->gl = hlist_entry(gl->gl_list.next, struct gfs2_glock,
-				     gl_list);
+		gi->gl = hlist_entry(gl->gl_list.next,
+				     struct gfs2_glock, gl_list);
 		if (gi->gl)
 			gfs2_glock_hold(gi->gl);
 	}
 	read_unlock(gl_lock_addr(gi->hash));
 	if (gl)
 		gfs2_glock_put(gl);
-
-	while(gi->gl == NULL) {
+	if (gl && gi->gl == NULL)
 		gi->hash++;
+	while(gi->gl == NULL) {
 		if (gi->hash >= GFS2_GL_HASH_SIZE)
 			return 1;
 		read_lock(gl_lock_addr(gi->hash));
@@ -2046,7 +2047,12 @@ static int gfs2_glock_iter_next(struct glock_iter *gi)
 		if (gi->gl)
 			gfs2_glock_hold(gi->gl);
 		read_unlock(gl_lock_addr(gi->hash));
+		gi->hash++;
 	}
+
+	if (gi->sdp != gi->gl->gl_sbd)
+		goto restart;
+
 	return 0;
 }
 
@@ -2068,16 +2074,10 @@ static struct glock_iter *gfs2_glock_iter_init(struct gfs2_sbd *sdp)
 	gi->sdp = sdp;
 	gi->hash = 0;
 	gi->seq = NULL;
+	gi->gl = NULL;
 	memset(gi->string, 0, sizeof(gi->string));
 
-	read_lock(gl_lock_addr(gi->hash));
-	gi->gl = hlist_entry(gl_hash_table[gi->hash].hb_list.first,
-			     struct gfs2_glock, gl_list);
-	if (gi->gl)
-		gfs2_glock_hold(gi->gl);
-	read_unlock(gl_lock_addr(gi->hash));
-
-	if (!gi->gl && gfs2_glock_iter_next(gi)) {
+	if (gfs2_glock_iter_next(gi)) {
 		gfs2_glock_iter_free(gi);
 		return NULL;
 	}
-- 
1.5.1.2

