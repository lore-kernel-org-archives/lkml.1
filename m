Return-Path: <linux-kernel-owner+w=401wt.eu-S1763950AbZFMN0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763950AbZFMN0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763364AbZFMNZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:25:24 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49807 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763404AbZFMNZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=MfMZQrhB+QDdpc95bJYNURZyFZB+UaGjCt7tFz2eYiUJVdc++GTVscBhK/vZdIdrMf
         aJ3s9qLoz94aN7FmJOhS7YwY1xoJVik9zExn8LqCDCYdDJJfLDLyk1+y280H6Ya9AtUY
         OGugYAiwo9ti7vbaJtVoIeYmCNm+OOOCyfFEQ=
Message-ID: <4A33A7D7.3040008@gmail.com>
Date: Sat, 13 Jun 2009 15:21:27 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 04/14] Pramfs: Mounting as root filesystem
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Pramfs can be used even as root filesystem.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/init/do_mounts.c linux-2.6.30/init/do_mounts.c
--- linux-2.6.30-orig/init/do_mounts.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30/init/do_mounts.c	2009-06-13 12:50:36.000000000 +0200
@@ -299,6 +299,17 @@ static int __init mount_nfs_root(void)
 }
 #endif
 
+#ifdef CONFIG_ROOT_PRAMFS
+static int __init mount_pramfs_root(void)
+{
+	create_dev("/dev/root", ROOT_DEV);
+	if (do_mount_root("/dev/root", "pramfs",
+				root_mountflags, root_mount_data) == 0)
+		return 1;
+        return 0;
+}
+#endif
+
 #if defined(CONFIG_BLK_DEV_RAM) || defined(CONFIG_BLK_DEV_FD)
 void __init change_floppy(char *fmt, ...)
 {
@@ -331,6 +342,15 @@ void __init change_floppy(char *fmt, ...
 
 void __init mount_root(void)
 {
+#ifdef CONFIG_ROOT_PRAMFS
+	if (MAJOR(ROOT_DEV) == MEM_MAJOR) {
+		if (mount_pramfs_root())
+			return;
+
+		printk(KERN_ERR "VFS: Unable to mount root fs via PRAMFS, trying floppy.\n");
+		ROOT_DEV = Root_FD0;
+	}
+#endif
 #ifdef CONFIG_ROOT_NFS
 	if (MAJOR(ROOT_DEV) == UNNAMED_MAJOR) {
 		if (mount_nfs_root())



