Return-Path: <linux-kernel-owner+w=401wt.eu-S934344AbXG0GEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbXG0GEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 02:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbXG0GEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 02:04:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32780
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbXG0GEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 02:04:36 -0400
Date: Thu, 26 Jul 2007 23:04:35 -0700 (PDT)
Message-Id: <20070726.230435.68159913.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: adobriyan@sw.ru
Subject: Re: /proc/bus/pci IOCTL breakage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070726.190751.66179795.davem@davemloft.net>
References: <20070726.190751.66179795.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 26 Jul 2007 19:07:51 -0700 (PDT)

> Two ways to fix:
> 
> 1) Make the PROC wrapper call ->unlocked_ioctl() or ->ioctl()
>    as a fallback of ->compat_ioctl is NULL.
> 
> 2) Make proc_bus_pci_operations provide a .compat_ioctl method,
>    but then we'll need to audit the entire tree for cases like
>    this and make the same fix.
> 
> Because it's easier to validate that all cases are covered,
> I think #1 is the preferred fix.

Here is my suggested fix.

It is important to only provide the compat_ioctl method
if the downstream de->proc_fops does too, otherwise this
utterly confuses the logic in fs/compat_ioctl.c and we
end up doing the right thing.

To be honest, the other unlocked_ioctl fallback scheme in
this file should be scrutinized for similar problems.

Signed-off-by: David S. Miller <davem@davemloft.net>

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
