Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXKRRJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXKRRJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXKRRJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:09:29 -0500
Received: from [212.12.190.181] ([212.12.190.181]:55134 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751111AbXKRRJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:09:28 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][retry-2] init: Introduce rootdir bootparm to select which dir to sys_chroot
Date: Sun, 18 Nov 2007 20:09:19 +0300
User-Agent: KMail/1.5
Cc: hpa@zytor.com, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200711182009.19072.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Second try; this time with a doc-update, and the ability to remount normally.

Tested against 2.6.23.

---

This patch introduces a rootdir kernel boot parameter, which specifies the 
path to the kernel sys_chroot boot dir.

This is useful for systems that have more than one distribution installed on 
the same fs/partition.


Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Boldi <a1426z@gawab.com>

---

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1506,6 +1506,10 @@ and is between 256 and 4096 characters. 
 			Useful for devices that are detected asynchronously
 			(e.g. USB and MMC devices).
 
+	rootdir=	[KNL] Set root dir to chroot to on bootup.
+			Useful for systems that have more than one distribution
+			installed on the same filesystem.
+
 	rw		[KNL] Mount root device read-write on boot
 
 	S		[KNL] Run init in single mode
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -252,6 +252,16 @@ __setup("rootflags=", root_data_setup);
 __setup("rootfstype=", fs_names_setup);
 __setup("rootdelay=", root_delay_setup);
 
+static char __initdata root_dir[128];
+static int __init root_dir_setup(char *str)
+{
+	strcpy(root_dir, "./");
+	strlcat(root_dir, str, sizeof(root_dir));
+	return 1;
+}
+
+__setup("rootdir=", root_dir_setup);
+
 static void __init get_fs_names(char *page)
 {
 	char *s = page;
@@ -469,6 +479,12 @@ void __init prepare_namespace(void)
 	mount_root();
 out:
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
+
+	if (root_dir) {
+		sys_mount(root_dir, root_dir, NULL, MS_BIND, NULL);
+		sys_chdir(root_dir);
+	}
+
 	sys_chroot(".");
 	security_sb_post_mountroot();
 }

