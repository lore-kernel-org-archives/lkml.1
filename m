Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZCRNaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZCRNaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbZCRN06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbZCRN0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:50 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/18] GFS2: Expose UUID via sysfs/uevent
Date: Wed, 18 Mar 2009 12:23:45 +0000
Message-Id: <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Since we have a UUID, we ought to expose it to the user via sysfs
and uevents. We already have the fs name in both of these places
(a combination of the lock proto and lock table name) so if we add
the UUID as well, we have a full set.

For older filesystems (i.e. those created before mkfs.gfs2 was writing
UUIDs by default) the sysfs file will appear zero length, and no UUID
env var will be added to the uevents.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 3f29bd2..980a086 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -470,6 +470,7 @@ struct gfs2_sb_host {
 
 	char sb_lockproto[GFS2_LOCKNAME_LEN];
 	char sb_locktable[GFS2_LOCKNAME_LEN];
+	u8 sb_uuid[16];
 };
 
 /*
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index e502b37..804ca72 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -234,6 +234,7 @@ static void gfs2_sb_in(struct gfs2_sb_host *sb, const void *buf)
 
 	memcpy(sb->sb_lockproto, str->sb_lockproto, GFS2_LOCKNAME_LEN);
 	memcpy(sb->sb_locktable, str->sb_locktable, GFS2_LOCKNAME_LEN);
+	memcpy(sb->sb_uuid, str->sb_uuid, 16);
 }
 
 /**
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index a78997e..4d284d1 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -36,6 +36,30 @@ static ssize_t fsname_show(struct gfs2_sbd *sdp, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%s\n", sdp->sd_fsname);
 }
 
+static int gfs2_uuid_valid(const u8 *uuid)
+{
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		if (uuid[i])
+			return 1;
+	}
+	return 0;
+}
+
+static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
+{
+	const u8 *uuid = sdp->sd_sb.sb_uuid;
+	buf[0] = '\0';
+	if (!gfs2_uuid_valid(uuid))
+		return 0;
+	return snprintf(buf, PAGE_SIZE, "%02X%02X%02X%02X-%02X%02X-"
+			"%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X\n",
+			uuid[0], uuid[1], uuid[2], uuid[3], uuid[4], uuid[5],
+			uuid[6], uuid[7], uuid[8], uuid[9], uuid[10], uuid[11],
+			uuid[12], uuid[13], uuid[14], uuid[15]);
+}
+
 static ssize_t freeze_show(struct gfs2_sbd *sdp, char *buf)
 {
 	unsigned int count;
@@ -158,6 +182,7 @@ static struct gfs2_attr gfs2_attr_##name = __ATTR(name, mode, show, store)
 
 GFS2_ATTR(id,                  0444, id_show,       NULL);
 GFS2_ATTR(fsname,              0444, fsname_show,   NULL);
+GFS2_ATTR(uuid,                0444, uuid_show,     NULL);
 GFS2_ATTR(freeze,              0644, freeze_show,   freeze_store);
 GFS2_ATTR(withdraw,            0644, withdraw_show, withdraw_store);
 GFS2_ATTR(statfs_sync,         0200, NULL,          statfs_sync_store);
@@ -168,6 +193,7 @@ GFS2_ATTR(quota_refresh_group, 0200, NULL,          quota_refresh_group_store);
 static struct attribute *gfs2_attrs[] = {
 	&gfs2_attr_id.attr,
 	&gfs2_attr_fsname.attr,
+	&gfs2_attr_uuid.attr,
 	&gfs2_attr_freeze.attr,
 	&gfs2_attr_withdraw.attr,
 	&gfs2_attr_statfs_sync.attr,
@@ -598,12 +624,23 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 	kobject_put(&sdp->sd_kobj);
 }
 
+
 static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 		       struct kobj_uevent_env *env)
 {
 	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
+	const u8 *uuid = sdp->sd_sb.sb_uuid;
+
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
+	if (gfs2_uuid_valid(uuid)) {
+		add_uevent_var(env, "UUID=%02X%02X%02X%02X-%02X%02X-%02X%02X-"
+			       "%02X%02X-%02X%02X%02X%02X%02X%02X",
+			       uuid[0], uuid[1], uuid[2], uuid[3], uuid[4],
+			       uuid[5], uuid[6], uuid[7], uuid[8], uuid[9],
+			       uuid[10], uuid[11], uuid[12], uuid[13],
+			       uuid[14], uuid[15]);
+	}
 	return 0;
 }
 
-- 
1.6.0.3

