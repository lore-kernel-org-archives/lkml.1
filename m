Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757031AbXG1F6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXG1F6s (ORCPT <rfc822;akpm@linux-foundation.org>);
	Sat, 28 Jul 2007 01:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbXG1F6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 01:58:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60490
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbXG1F6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 01:58:38 -0400
Date: Fri, 27 Jul 2007 22:58:37 -0700 (PDT)
Message-Id: <20070727.225837.09668865.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, adobriyan@sw.ru
Subject: [PATCH]: Fix procfs compat_ioctl regression.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alexey reviewed the patch and is fine with this fix.

Please apply, thanks!

[PROCFS]: Fix ioctl regression.

It is important to only provide the compat_ioctl method
if the downstream de->proc_fops does too, otherwise this
utterly confuses the logic in fs/compat_ioctl.c and we
end up doing the wrong thing.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Alexey Dobriyan <adobriyan@sw.ru>

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 94e2c1a..a5b0dfd 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -386,6 +386,19 @@ static const struct file_operations proc_reg_file_ops = {
 	.release	= proc_reg_release,
 };
 
+#ifdef CONFIG_COMPAT
+static const struct file_operations proc_reg_file_ops_no_compat = {
+	.llseek		= proc_reg_llseek,
+	.read		= proc_reg_read,
+	.write		= proc_reg_write,
+	.poll		= proc_reg_poll,
+	.unlocked_ioctl	= proc_reg_unlocked_ioctl,
+	.mmap		= proc_reg_mmap,
+	.open		= proc_reg_open,
+	.release	= proc_reg_release,
+};
+#endif
+
 struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 				struct proc_dir_entry *de)
 {
@@ -413,8 +426,15 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 		if (de->proc_iops)
 			inode->i_op = de->proc_iops;
 		if (de->proc_fops) {
-			if (S_ISREG(inode->i_mode))
-				inode->i_fop = &proc_reg_file_ops;
+			if (S_ISREG(inode->i_mode)) {
+#ifdef CONFIG_COMPAT
+				if (!de->proc_fops->compat_ioctl)
+					inode->i_fop =
+						&proc_reg_file_ops_no_compat;
+				else
+#endif
+					inode->i_fop = &proc_reg_file_ops;
+			}
 			else
 				inode->i_fop = de->proc_fops;
 		}
