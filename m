Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbYEILmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbYEILmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYEILmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:42:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:32723 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYEILmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:42:23 -0400
Date: Fri, 9 May 2008 13:42:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>,
       Steven Whitehouse <swhiteho@redhat.com>, Andries Brouwer <aeb@cwi.nl>
Subject: [PATCH] fs: Prefer strlcpy() over snprintf()
Message-ID: <20080509134211.02eb2058@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strlcpy is faster than snprintf when you don't use the returned value.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andries Brouwer <aeb@cwi.nl>
---
A quick grep suggests that there's about 80 more similar cases in the kernel
tree which could be fixed.

 fs/configfs/dir.c     |    2 +-
 fs/gfs2/ops_fstype.c  |    4 ++--
 fs/partitions/check.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.26-rc1.orig/fs/configfs/dir.c	2008-05-09 12:52:51.000000000 +0200
+++ linux-2.6.26-rc1/fs/configfs/dir.c	2008-05-09 13:20:24.000000000 +0200
@@ -1041,7 +1041,7 @@ static int configfs_mkdir(struct inode *
 		goto out_put;
 	}
 
-	snprintf(name, dentry->d_name.len + 1, "%s", dentry->d_name.name);
+	strlcpy(name, dentry->d_name.name, dentry->d_name.len + 1);
 
 	mutex_lock(&subsys->su_mutex);
 	group = NULL;
--- linux-2.6.26-rc1.orig/fs/gfs2/ops_fstype.c	2008-05-09 12:52:51.000000000 +0200
+++ linux-2.6.26-rc1/fs/gfs2/ops_fstype.c	2008-05-09 13:20:24.000000000 +0200
@@ -142,8 +142,8 @@ static int init_names(struct gfs2_sbd *s
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	snprintf(sdp->sd_proto_name, GFS2_FSNAME_LEN, "%s", proto);
-	snprintf(sdp->sd_table_name, GFS2_FSNAME_LEN, "%s", table);
+	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
+	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))
--- linux-2.6.26-rc1.orig/fs/partitions/check.c	2008-05-09 12:52:51.000000000 +0200
+++ linux-2.6.26-rc1/fs/partitions/check.c	2008-05-09 13:20:24.000000000 +0200
@@ -123,7 +123,7 @@ static int (*check_part[])(struct parsed
 char *disk_name(struct gendisk *hd, int part, char *buf)
 {
 	if (!part)
-		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
+		strlcpy(buf, hd->disk_name, BDEVNAME_SIZE);
 	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
 		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, part);
 	else


-- 
Jean Delvare
