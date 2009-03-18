Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZCRNak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZCRNak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZCRN07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbZCRN0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:51 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/18] GFS2: Add a "demote a glock" interface to sysfs
Date: Wed, 18 Mar 2009 12:23:46 +0000
Message-Id: <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This adds a sysfs file called demote_rq to GFS2's
per filesystem directory. Its possible to use this
file to demote arbitrary glocks in exactly the same
way as if a request had come in from a remote node.

This is intended for testing issues relating to caching
of data under glocks. Despite that, the interface is
generic enough to send requests to any type of glock,
but be careful as its not always safe to send an
arbitrary message to an arbitrary glock. For that reason
and to prevent DoS, this interface is restricted to root
only.

The messages look like this:

<type>:<glocknumber> <mode>

Example:

echo -n "2:13324 EX" >/sys/fs/gfs2/unity:myfs/demote_rq

Which means "please demote inode glock (type 2) number 13324 so that
I can get an EX (exclusive) lock". The lock modes are those which
would normally be sent by a remote node in its callback so if you
want to unlock a glock, you use EX, to demote to shared, use SH or PR
(depending on whether you like GFS2 or DLM lock modes better!).

If the glock doesn't exist, you'll get -ENOENT returned. If the
arguments don't make sense, you'll get -EINVAL returned.

The plan is that this interface will be used in combination with
the blktrace patch which I recently posted for comments although
it is, of course, still useful in its own right.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ad8e121..3984e47 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -684,10 +684,11 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl = search_bucket(hash, sdp, &name);
 	read_unlock(gl_lock_addr(hash));
 
-	if (gl || !create) {
-		*glp = gl;
+	*glp = gl;
+	if (gl)
 		return 0;
-	}
+	if (!create)
+		return -ENOENT;
 
 	gl = kmem_cache_alloc(gfs2_glock_cachep, GFP_KERNEL);
 	if (!gl)
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index a9b7d3a..f34bc70 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -447,3 +447,15 @@ const struct gfs2_glock_operations gfs2_journal_glops = {
 	.go_type = LM_TYPE_JOURNAL,
 };
 
+const struct gfs2_glock_operations *gfs2_glops_list[] = {
+	[LM_TYPE_META] = &gfs2_meta_glops,
+	[LM_TYPE_INODE] = &gfs2_inode_glops,
+	[LM_TYPE_RGRP] = &gfs2_rgrp_glops,
+	[LM_TYPE_NONDISK] = &gfs2_trans_glops,
+	[LM_TYPE_IOPEN] = &gfs2_iopen_glops,
+	[LM_TYPE_FLOCK] = &gfs2_flock_glops,
+	[LM_TYPE_NONDISK] = &gfs2_nondisk_glops,
+	[LM_TYPE_QUOTA] = &gfs2_quota_glops,
+	[LM_TYPE_JOURNAL] = &gfs2_journal_glops,
+};
+
diff --git a/fs/gfs2/glops.h b/fs/gfs2/glops.h
index a1d9b5b..b3aa2e3 100644
--- a/fs/gfs2/glops.h
+++ b/fs/gfs2/glops.h
@@ -21,5 +21,6 @@ extern const struct gfs2_glock_operations gfs2_flock_glops;
 extern const struct gfs2_glock_operations gfs2_nondisk_glops;
 extern const struct gfs2_glock_operations gfs2_quota_glops;
 extern const struct gfs2_glock_operations gfs2_journal_glops;
+extern const struct gfs2_glock_operations *gfs2_glops_list[];
 
 #endif /* __GLOPS_DOT_H__ */
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 789953a..a068ac9 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -839,7 +839,7 @@ static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 	const unsigned int sects_per_blk = sdp->sd_sb.sb_bsize /
 					   bdev_hardsect_size(sb->s_bdev);
 	u64 blk;
-	sector_t start;
+	sector_t start = 0;
 	sector_t nr_sects = 0;
 	int rv;
 	unsigned int x;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 4d284d1..7655f50 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -24,6 +24,7 @@
 #include "glock.h"
 #include "quota.h"
 #include "util.h"
+#include "glops.h"
 
 static ssize_t id_show(struct gfs2_sbd *sdp, char *buf)
 {
@@ -171,6 +172,46 @@ static ssize_t quota_refresh_group_store(struct gfs2_sbd *sdp, const char *buf,
 	return len;
 }
 
+static ssize_t demote_rq_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+{
+	struct gfs2_glock *gl;
+	const struct gfs2_glock_operations *glops;
+	unsigned int glmode;
+	unsigned int gltype;
+	unsigned long long glnum;
+	char mode[16];
+	int rv;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	rv = sscanf(buf, "%u:%llu %15s", &gltype, &glnum,
+		    mode);
+	if (rv != 3)
+		return -EINVAL;
+
+	if (strcmp(mode, "EX") == 0)
+		glmode = LM_ST_UNLOCKED;
+	else if ((strcmp(mode, "CW") == 0) || (strcmp(mode, "DF") == 0))
+		glmode = LM_ST_DEFERRED;
+	else if ((strcmp(mode, "PR") == 0) || (strcmp(mode, "SH") == 0))
+		glmode = LM_ST_SHARED;
+	else
+		return -EINVAL;
+
+	if (gltype > LM_TYPE_JOURNAL)
+		return -EINVAL;
+	glops = gfs2_glops_list[gltype];
+	if (glops == NULL)
+		return -EINVAL;
+	rv = gfs2_glock_get(sdp, glnum, glops, 0, &gl);
+	if (rv)
+		return rv;
+	gfs2_glock_cb(gl, glmode);
+	gfs2_glock_put(gl);
+	return len;
+}
+
 struct gfs2_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct gfs2_sbd *, char *);
@@ -189,6 +230,7 @@ GFS2_ATTR(statfs_sync,         0200, NULL,          statfs_sync_store);
 GFS2_ATTR(quota_sync,          0200, NULL,          quota_sync_store);
 GFS2_ATTR(quota_refresh_user,  0200, NULL,          quota_refresh_user_store);
 GFS2_ATTR(quota_refresh_group, 0200, NULL,          quota_refresh_group_store);
+GFS2_ATTR(demote_rq,           0200, NULL,	    demote_rq_store);
 
 static struct attribute *gfs2_attrs[] = {
 	&gfs2_attr_id.attr,
@@ -200,6 +242,7 @@ static struct attribute *gfs2_attrs[] = {
 	&gfs2_attr_quota_sync.attr,
 	&gfs2_attr_quota_refresh_user.attr,
 	&gfs2_attr_quota_refresh_group.attr,
+	&gfs2_attr_demote_rq.attr,
 	NULL,
 };
 
-- 
1.6.0.3

