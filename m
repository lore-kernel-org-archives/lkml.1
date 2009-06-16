Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbZFPQ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbZFPQ5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZFPQ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:56:51 -0400
Received: from mail-fx0-f211.google.com ([209.85.220.211]:36794 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZFPQ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=smWvIGP4Gqqf29aOKwjoWxUmImBUEpcdPFww/kpLjwEjY4KkfjBAzpxBWf6UyzplN+
         oMITuwZwD5sS0TXotKTxWgqZnzZSgFcptJTnP2vPjRDQVQeuxYY9V0wKWzbkF6rwxMFb
         lHHfqeT2qKUSPxU/6U7ijhkY596UCmf1Yi1jM=
Subject: New kernel option alt_root for trying harder to find a valid root
 device
From: Martin Bammer <mrbm74@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-JXY/TGQ1Ol0RvV2XRFif"
Date: Tue, 16 Jun 2009 18:56:45 +0200
Message-Id: <1245171405.4309.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JXY/TGQ1Ol0RvV2XRFif
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

the attached patch (created against 2.6.30) makes the kernel harder
finding a valid root device.
Changes are:
- New kernel option alt_root=<alternative root device>
- If an alternative root device is defined with alt_root, e.g.
alt_root=/dev/sda1, and the primary root device could not be found
because a) root device is defined by it's UUID and b) initrd is missing
or damaged, then the kernel will try to use /dev/sda1 as it's root
device.
- If an alternative root device is defined with alt_root and initrd is
damaged then the kernel will try to use /dev/sda1 as it's root device.

Martin


--=-JXY/TGQ1Ol0RvV2XRFif
Content-Disposition: attachment; filename="init_mounts_alt_root.diff"
Content-Type: text/x-patch; name="init_mounts_alt_root.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Signed-off-by: Martin Bammer <mrbm74@gmail.com>
diff --git a/linux-2.6.30-ep0/init/do_mounts.c b/linux-2.6.30-ep1/init/do_mounts.c
index dd7ee5f..b12e739 100644
--- a/linux-2.6.30-ep0/init/do_mounts.c
+++ b/linux-2.6.30-ep1/init/do_mounts.c
@@ -27,6 +27,7 @@ int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 int root_mountflags = MS_RDONLY | MS_SILENT;
 static char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
+static char __initdata alt_saved_root_name[64];
 static int __initdata root_wait;
 
 dev_t ROOT_DEV;
@@ -152,6 +153,14 @@ static int __init root_dev_setup(char *line)
 
 __setup("root=", root_dev_setup);
 
+static int __init alt_root_dev_setup(char *line)
+{
+	strlcpy(alt_saved_root_name, line, sizeof(alt_saved_root_name));
+	return 1;
+}
+
+__setup("alt_root=", alt_root_dev_setup);
+
 static int __init rootwait_setup(char *str)
 {
 	if (*str)
@@ -412,6 +421,20 @@ void __init prepare_namespace(void)
 	if (is_floppy && rd_doload && rd_load_disk(0))
 		ROOT_DEV = Root_RAM0;
 
+	if ((ROOT_DEV == 0) && alt_saved_root_name[0]) {
+		printk(KERN_WARNING "VFS: Unable to find root device %s. Trying alternative device %s.\n",
+			root_device_name, alt_saved_root_name);
+		root_device_name = alt_saved_root_name;
+		if (!strncmp(root_device_name, "mtd", 3) ||
+		    !strncmp(root_device_name, "ubi", 3)) {
+			mount_block_root(root_device_name, root_mountflags);
+			goto out;
+		}
+		ROOT_DEV = name_to_dev_t(root_device_name);
+		if (strncmp(root_device_name, "/dev/", 5) == 0)
+			root_device_name += 5;
+	}
+
 	mount_root();
 out:
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
diff --git a/linux-2.6.30-ep0/init/do_mounts_initrd.c b/linux-2.6.30-ep1/init/do_mounts_initrd.c
index 614241b..d1d6e1c 100644
--- a/linux-2.6.30-ep0/init/do_mounts_initrd.c
+++ b/linux-2.6.30-ep1/init/do_mounts_initrd.c
@@ -38,7 +38,7 @@ static int __init do_linuxrc(void * shell)
 	return kernel_execve(shell, argv, envp_init);
 }
 
-static void __init handle_initrd(void)
+static int __init handle_initrd(void)
 {
 	int error;
 	int pid;
@@ -79,7 +79,7 @@ static void __init handle_initrd(void)
 
 	if (new_decode_dev(real_root_dev) == Root_RAM0) {
 		sys_chdir("/old");
-		return;
+		return 1;
 	}
 
 	ROOT_DEV = new_decode_dev(real_root_dev);
@@ -105,7 +105,12 @@ static void __init handle_initrd(void)
 			sys_close(fd);
 		}
 		printk(!error ? "okay\n" : "failed\n");
+		if (error) {
+			printk(KERN_ERR "Error %d handling initrd.\n", error);
+			return 0;
+		}
 	}
+	return 1;
 }
 
 int __init initrd_load(void)
@@ -120,8 +125,7 @@ int __init initrd_load(void)
 		 */
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
 			sys_unlink("/initrd.image");
-			handle_initrd();
-			return 1;
+			return handle_initrd();
 		}
 	}
 	sys_unlink("/initrd.image");

--=-JXY/TGQ1Ol0RvV2XRFif--

