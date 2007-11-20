Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbXKTKpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbXKTKpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXKTKp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:45:27 -0500
Received: from srv02.itamservices.de ([87.106.7.29]:59899 "EHLO
	itamservices.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXKTKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:45:27 -0500
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 05:45:26 EST
Message-ID: <4742B82C.3060001@itamservices.de>
Date: Tue, 20 Nov 2007 11:34:20 +0100
From: Daniel Reichelt <mail@itamservices.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Patch: Hide process info from other users/users not in my group
X-Enigmail-Version: 0.95.0
OpenPGP: id=360C6B0F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

this patch sets (if the corresponding kconfig option is active) the access
modes of /proc/<pid>-dirs to 550 instead of 555 in order to provide some
privacy to users. Tools like lsof and ps to spy out on other users become
ineffective.

Cheers,
--
Daniel Reichelt

# diff -Naur linux-2.6.23.8/fs/Kconfig linux-2.6.23.8-dhr/fs/Kconfig
--- linux-2.6.23.8/fs/Kconfig   2007-11-16 19:14:27.000000000 +0100
+++ linux-2.6.23.8-dhr/fs/Kconfig       2007-11-20 11:33:18.000000000 +0100
@@ -918,6 +918,17 @@
         help
         Exports the dump image of crashed kernel in ELF format.

+config PROC_SECURED_PID_DIRS
+       bool "chmod /proc/<pid>-dirs to 550"
+       depends on PROC_FS
+       default n
+       help
+         chmod /proc/<pid>-dirs to 550 instead of 555 which provides a bit
+         moreprivacy to users on your system as only the user's and the user's
+         group's process details may be viewed. Other users' tasks running on
+         the system will be completely hidden from the means of utilities like
+         ps or lsof.
+
 config PROC_SYSCTL
        bool "Sysctl support (/proc/sys)" if EMBEDDED
        depends on PROC_FS
# diff -Naur linux-2.6.23.8/fs/proc/base.c linux-2.6.23.8-dhr/fs/proc/base.c
--- linux-2.6.23.8/fs/proc/base.c       2007-11-16 19:14:27.000000000 +0100
+++ linux-2.6.23.8-dhr/fs/proc/base.c   2007-11-20 11:31:31.000000000 +0100
@@ -2200,7 +2200,11 @@
        if (!inode)
                goto out;

+#ifdef CONFIG_PROC_SECURED_PID_DIRS
+       inode->i_mode = S_IFDIR|S_IRUSR|S_IRGRP|S_IXUSR|S_IXGRP;
+#else
        inode->i_mode = S_IFDIR|S_IRUGO|S_IXUGO;
+#endif
        inode->i_op = &proc_tgid_base_inode_operations;
        inode->i_fop = &proc_tgid_base_operations;
        inode->i_flags|=S_IMMUTABLE;
