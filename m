Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbZDCIZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbZDCIZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZDCIZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:25:20 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:30326 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752934AbZDCIZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:25:18 -0400
X-YMail-OSG: 49TzX7cVM1mGcTh02KD4dXg7RhIZnhGq6OnG.NG.yC6Gj.v4YJoT.kMSPqdYb19iwp28oK4YwYTQf.KfsdhKE3HX8F9WgQC_S3WiPSEC5q_xiwXKeDN8Yl8O_mcu1vNq0TPRWuxdZWhBokD6csPiIXMVaZ0ORLq8OZi2YBgpldNZHIRaXgK56tVQV9_Y9hiKEWcygIYgi1_0ICqNAvf_lV3YlC4ob6TuHrAC6OW5JaJc.Z0XUcAPEp4HcTGv1KfbvMaOGsZPVAc2P4ieqMhDWVQUw_7k2hX5YHk.o6OhUeEKxXHdc8bndvX9G0w8_rJ9Gon1s0zG.N2kB23pV1GjjQpFEFqcXuZCYzo2fvyhrp4-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [ConfigFS]: Add struct
	configfs_item_operations->check_link()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 01:25:07 -0700
Message-Id: <1238747107.4250.448.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel and co,

This patch adds struct configfs_item_operations->check_link() and
changes fs/configfs/symlink.c:configfs_unlink() so that
when (*check_link) is present, an ConfigFS unlink will fail, based upon
input by said symlinked struct config_item *parent_item.

If a non zero return is returned from (*check_link), said non zero value is
expected to use include/asm-generic/errno* values, and the failure is returned
to userspace via the unlink(2) system call.

Please consider this patch for v2.6.30.  It requires no changes to existing consumers
of ConfigFS like fs/ocfs2, and I have tested it with running LIO-Target v3.0 code.

Many thanks for your most valuable of time,

--nab

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/configfs/symlink.c    |   13 +++++++++++++
 include/linux/configfs.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 932a92b..a5dede6 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -202,6 +202,19 @@ int configfs_unlink(struct inode *dir, struct dentry *dentry)
 	parent_item = configfs_get_config_item(dentry->d_parent);
 	type = parent_item->ci_type;
 
+	/*
+	 * See if the underlying struct config_item has dependent
+	 * symlinks, and should return -EACCES here.
+	 */
+	if (type && type->ct_item_ops &&
+	    type->ct_item_ops->check_link) {
+		ret = type->ct_item_ops->check_link(parent_item);
+		if (ret != 0) {
+			config_item_put(parent_item);
+			goto out;
+		}
+	}
+
 	spin_lock(&configfs_dirent_lock);
 	list_del_init(&sd->s_sibling);
 	spin_unlock(&configfs_dirent_lock);
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 7f62777..b026f16 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -226,6 +226,7 @@ struct configfs_item_operations {
 	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribute *,char *);
 	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribute *,const char *, size_t);
 	int (*allow_link)(struct config_item *src, struct config_item *target);
+	int (*check_link)(struct config_item *src);
 	int (*drop_link)(struct config_item *src, struct config_item *target);
 };
 
-- 
1.5.4.1



