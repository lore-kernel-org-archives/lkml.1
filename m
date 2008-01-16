Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYAPNga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYAPNga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYAPNgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:36:21 -0500
Received: from bde.crans.org ([138.231.137.76]:43277 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYAPNgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:36:21 -0500
From: Mathieu Segaud <mathieu.segaud@regala.cx>
To: dri-devel@lists.sourceforge.net
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] Convert drivers/char/agp/frontend.c to use unlocked_ioctl
Date: Wed, 16 Jan 2008 14:36:18 +0100
Message-Id: <1200490578-25717-1-git-send-email-mathieu.segaud@regala.cx>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now, agp_compat_ioctl already runs without the BKL. Mutual exclusion
is enforced by agp_fe.agp_mutex in agp_ioctl() and agp_compat_ioctl().
Apply the same locking rationale to the two functions allowing BKL cleanup.

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 drivers/char/agp/frontend.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 7791e98..6212a9e 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -960,7 +960,7 @@ static int agpioc_unbind_wrap(struct agp_file_private *priv, void __user *arg)
 	return agp_unbind_memory(memory);
 }
 
-static int agp_ioctl(struct inode *inode, struct file *file,
+static long agp_ioctl(struct file *file,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct agp_file_private *curr_priv = file->private_data;
@@ -1047,7 +1047,7 @@ static const struct file_operations agp_fops =
 	.llseek		= no_llseek,
 	.read		= agp_read,
 	.write		= agp_write,
-	.ioctl		= agp_ioctl,
+	.unlocked_ioctl	= agp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= compat_agp_ioctl,
 #endif
-- 
1.5.3.8

