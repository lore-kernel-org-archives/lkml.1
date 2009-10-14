Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZJNGa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZJNGa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZJNGa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:30:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:28699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbZJNGaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:30:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,555,1249282800"; 
   d="scan'208";a="559390069"
Subject: [RFC 2/2] Use unified UUID/GUID definition in gfs2
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 14:30:07 +0800
Message-Id: <1255501807.6047.1193.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace u8[16] UUID definition in gfs2.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 fs/gfs2/incore.h            |    3 ++-
 fs/gfs2/ops_fstype.c        |    2 +-
 fs/gfs2/sys.c               |   14 ++++----------
 include/linux/gfs2_ondisk.h |    3 ++-
 4 files changed, 9 insertions(+), 13 deletions(-)

--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -15,6 +15,7 @@
 #include <linux/slow-work.h>
 #include <linux/dlm.h>
 #include <linux/buffer_head.h>
+#include <linux/uuid.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -483,7 +484,7 @@ struct gfs2_sb_host {
 
 	char sb_lockproto[GFS2_LOCKNAME_LEN];
 	char sb_locktable[GFS2_LOCKNAME_LEN];
-	u8 sb_uuid[16];
+	uuid_be sb_uuid;
 };
 
 /*
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -68,20 +68,14 @@ static ssize_t fsname_show(struct gfs2_s
 	return snprintf(buf, PAGE_SIZE, "%s\n", sdp->sd_fsname);
 }
 
-static int gfs2_uuid_valid(const u8 *uuid)
+static int gfs2_uuid_valid(const uuid_be *uuid)
 {
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		if (uuid[i])
-			return 1;
-	}
-	return 0;
+	return uuid_be_cmp(*uuid, NULL_UUID_BE);
 }
 
 static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
 {
-	const u8 *uuid = sdp->sd_sb.sb_uuid;
+	const uuid_be *uuid = &sdp->sd_sb.sb_uuid;
 	buf[0] = '\0';
 	if (!gfs2_uuid_valid(uuid))
 		return 0;
@@ -563,7 +557,7 @@ static int gfs2_uevent(struct kset *kset
 		       struct kobj_uevent_env *env)
 {
 	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
-	const u8 *uuid = sdp->sd_sb.sb_uuid;
+	const uuid_be *uuid = &sdp->sd_sb.sb_uuid;
 
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -11,6 +11,7 @@
 #define __GFS2_ONDISK_DOT_H__
 
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 #define GFS2_MAGIC		0x01161970
 #define GFS2_BASIC_BLOCK	512
@@ -124,7 +125,7 @@ struct gfs2_sb {
 	struct gfs2_inum __pad3; /* Was quota inode in gfs1 */
 	struct gfs2_inum __pad4; /* Was licence inode in gfs1 */
 #define GFS2_HAS_UUID 1
-	__u8 sb_uuid[16]; /* The UUID, maybe 0 for backwards compat */
+	uuid_be sb_uuid; /* The UUID, maybe 0 for backwards compat */
 };
 
 /*
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -233,7 +233,7 @@ static void gfs2_sb_in(struct gfs2_sb_ho
 
 	memcpy(sb->sb_lockproto, str->sb_lockproto, GFS2_LOCKNAME_LEN);
 	memcpy(sb->sb_locktable, str->sb_locktable, GFS2_LOCKNAME_LEN);
-	memcpy(sb->sb_uuid, str->sb_uuid, 16);
+	sb->sb_uuid = str->sb_uuid;
 }
 
 /**


