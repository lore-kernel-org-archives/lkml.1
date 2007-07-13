Return-Path: <linux-kernel-owner+w=401wt.eu-S936274AbXGMTAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936274AbXGMTAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759667AbXGMS75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:59:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62849 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbXGMS74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:59:56 -0400
Date: Fri, 13 Jul 2007 20:59:44 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3][try 1] init: enable system-on-initramfs: enable root=rootfs
In-Reply-To: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
Message-ID: <Pine.LNX.4.58.0707132058450.3303@be1.lrz>
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+fVo72q8N7XPMnVdCdKsMx4gPBcNzK0WsyoSf
 VRaNydQs8COi1pusU8VAeMNGp6ruotc5+aZYmzCn0Z+CRoJceo
 rS5XWb/rEYzcVrBqTFt4w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disable mounting a root filesystem if root=rootfs is supplied.

If you put a rescue system on an initramfs, you should be able to boot it
without using tricks like an additional /init script.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

diff -X dontdiff -pruN linux-2.6.22/Documentation/kernel-parameters.txt linux-2.6.22.tmpfsroot/Documentation/kernel-parameters.txt
--- linux-2.6.22/Documentation/kernel-parameters.txt	2007-07-11 23:14:59.000000000 +0200
+++ linux-2.6.22.tmpfsroot/Documentation/kernel-parameters.txt	2007-07-12 13:57:00.000000000 +0200
@@ -1528,6 +1528,7 @@ and is between 256 and 4096 characters. 
 	ro		[KNL] Mount root device read-only on boot
 
 	root=		[KNL] Root filesystem
+			If set to "rootfs", the initramfs will be used
 
 	rootdelay=	[KNL] Delay (in seconds) to pause before attempting to
 			mount the root filesystem
diff -X dontdiff -pruN linux-2.6.22/init/do_mounts.c linux-2.6.22.tmpfsroot/init/do_mounts.c
--- linux-2.6.22/init/do_mounts.c	2007-07-11 23:15:31.000000000 +0200
+++ linux-2.6.22.tmpfsroot/init/do_mounts.c	2007-07-12 13:57:00.000000000 +0200
@@ -433,6 +433,8 @@ void __init prepare_namespace(void)
 			mount_block_root(root_device_name, root_mountflags);
 			goto out;
 		}
+		if (!strcmp(root_device_name, "rootfs"))
+			goto out_nomount;
 		ROOT_DEV = name_to_dev_t(root_device_name);
 		if (strncmp(root_device_name, "/dev/", 5) == 0)
 			root_device_name += 5;
@@ -450,6 +452,7 @@ void __init prepare_namespace(void)
 out:
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
+out_nomount:
 	security_sb_post_mountroot();
 }
 
