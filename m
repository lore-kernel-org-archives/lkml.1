Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZI1ORs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZI1ORs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZI1ORr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:17:47 -0400
Received: from fogou.chygwyn.com ([195.171.2.24]:57963 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZI1ORq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:17:46 -0400
X-Greylist: delayed 1901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2009 10:17:46 EDT
Subject: Re: [RFC] VFS: Export dquot_send_warning
From: Steven Whitehouse <steve@chygwyn.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1254145438.6052.471.camel@localhost.localdomain>
References: <1253708720.6052.289.camel@localhost.localdomain>
	 <20090926162951.GA12397@infradead.org>
	 <1254145438.6052.471.camel@localhost.localdomain>
Content-Type: text/plain
Organization: ChyGwyn Limited (Registered in England and Wales, No.
 03887683) Registered Office: Digital Technium, Singleton Park, Swansea. SA2
 8PP
Date: Mon, 28 Sep 2009 14:45:59 +0100
Message-Id: <1254145559.6052.472.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the patch to make it work with GFS2,

Steve.

------------------------------------------------------------------------------
>From 2d098b275c0ef952e3a3a328bae1beac7d9b9017 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 28 Sep 2009 12:49:15 +0100
Subject: [PATCH 12/12] GFS2: Use dquot_send_warning()

This adds support to GFS2 to send quota warnings via netlink.
Also it removes a stray \r which was left over from when the
code used to print warnings on the console.

Signed-off-by: Steven Whitehouse <swhitehouse@redhat.com>
---
 fs/gfs2/quota.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index e8db534..1d4fc04 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -47,6 +47,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/quota.h>
 #include <linux/dqblk_xfs.h>
 
 #include "gfs2.h"
@@ -1001,7 +1002,7 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	printk(KERN_INFO "GFS2: fsid=%s: quota %s for %s %u\r\n",
+	printk(KERN_INFO "GFS2: fsid=%s: quota %s for %s %u\n",
 	       sdp->sd_fsname, type,
 	       (test_bit(QDF_USER, &qd->qd_flags)) ? "user" : "group",
 	       qd->qd_id);
@@ -1038,6 +1039,10 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 
 		if (be64_to_cpu(qd->qd_qb.qb_limit) && (s64)be64_to_cpu(qd->qd_qb.qb_limit) < value) {
 			print_message(qd, "exceeded");
+			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
+					   USRQUOTA : GRPQUOTA, qd->qd_id,
+					   sdp->sd_vfs->s_dev, QUOTA_NL_BHARDWARN);
+
 			error = -EDQUOT;
 			break;
 		} else if (be64_to_cpu(qd->qd_qb.qb_warn) &&
@@ -1045,6 +1050,9 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 			   time_after_eq(jiffies, qd->qd_last_warn +
 					 gfs2_tune_get(sdp,
 						gt_quota_warn_period) * HZ)) {
+			quota_send_warning(test_bit(QDF_USER, &qd->qd_flags) ?
+					   USRQUOTA : GRPQUOTA, qd->qd_id,
+					   sdp->sd_vfs->s_dev, QUOTA_NL_BSOFTWARN);
 			error = print_message(qd, "warning");
 			qd->qd_last_warn = jiffies;
 		}
-- 
1.6.2.5



