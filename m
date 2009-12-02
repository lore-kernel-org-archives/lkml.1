Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZLBBoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZLBBoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZLBBoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:44:11 -0500
Received: from mail-yw0-f116.google.com ([209.85.211.116]:63646 "EHLO
	mail-yw0-f116.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZLBBoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:44:10 -0500
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 20:44:10 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TsSnyQdc1eHGCsRNlPUN5bBqruLnHmgDpnfqw/ZyEgheVcYw6GXuQvZTrge3f10wx/
         l1Xr0jLqP4wxsk0yqSF38icM7K3d7RWG36fps8DD9zB8sDQHQRmFivaXPXl79CS/V4gX
         y1hW1bWJqfSYSN3ZXOJ4p8KjXnnoerZ2ufKlw=
MIME-Version: 1.0
Date: Tue, 1 Dec 2009 20:30:36 -0500
Message-ID: <1daf33050912011730l5def95brac3ce60647bc2040@mail.gmail.com>
Subject: [PATCH] ext2/3 as ext4
From: Philip Wernersbach <philip.wernersbach@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everyone,
     Below is a small patch I wrote for kernel version 2.6.31.6. It
causes ext2/3 filesystems to be mounted using the ext4 driver, in a
way that is transparent to the userspace (and kernelspace for that
matter, as long as the code uses the kernel's mounting API) and
requires no change to the userspace (/kernelspace). This patch is
useful because: 1) It allows minimalist kernel fanatics, like myself,
to drop 2 drivers from their builds without any loss in functionality.
2) It allows the ext2/3 filesystems to take advantage of the
performance/general improvements in the ext4 driver. 3) In the future,
with this patch, the ext2/3 driver code could be dropped from the
kernel without any loss in functionality. I have been using this patch
for 2 months now with no flaws on my home Linux box, which uses ext3
drives on a daily basis.

Let me know if you use this patch, if enough people use it I will
write a proper KCONFIG and submit it for inclusion into the kernel.

So without further ado, here is the patch.

Sincerely,
Philip Wernersbach <philip.wernersbach@gmail.com>

--- linux-2.6.31.6.orig/fs/namespace.c  2009-11-28 22:30:07.178682500 -0500
+++ linux-2.6.31.6/fs/namespace.c       2009-11-28 22:32:42.813462139 -0500
@@ -6,6 +6,8 @@
 *
 * Based on code from fs/super.c, copyright Linus Torvalds and others.
 * Heavily rewritten.
+ *
+ * Uses ext2/3 as ext4 patch by Philip Wernersbach (November 2009)
 */

 #include <linux/syscalls.h>
@@ -1838,6 +1840,34 @@
       return n;
 }

+/*
+ * compare_fs_names(char *fs1, char *fs2) - Part of the ext2/3 as ext4 patch
+ *
+ * The following is a standard string compare function, made to compare
+ * filesystem names, it returns 0 if they equal, and 1 if they do not.
+ * It only handles strings up to 255 characters though, so be cautious.
+ */
+static int compare_fs_names(char *fs1, char *fs2)
+{
+               int i;
+
+               if (fs1 == 0L || fs2 == 0L) return 1;
+
+               for (i=0;i<256;i++)
+               {
+                       if (fs1[i] != fs2[i])
+                               return 1;
+                       if (fs1[i] == 0 && fs2[i] == 0)
+                               return 0;
+                       if (fs1[i] == 0)
+                               return 1;
+                       if (fs2[i] == 0)
+                               return 1;
+               }
+               return 0;
+}
+
+
 int copy_mount_options(const void __user * data, unsigned long *where)
 {
       int i;
@@ -1891,6 +1921,22 @@
       struct path path;
       int retval = 0;
       int mnt_flags = 0;
+
+       /*
+        * This causes ext2 filesystems to be mounted with the ext4 driver.
+        *
+        * Part of the ext2/3 as ext4 patch.
+        */
+       if (compare_fs_names(type_page, "ext2") == 0)
+               type_page[3] = '4';
+
+       /*
+        * This causes ext3 filesystems to be mounted with the ext4 driver.
+        *
+        * Part of the ext2/3 as ext4 patch.
+        */
+       if (compare_fs_names(type_page, "ext3") == 0)
+               type_page[3] = '4';

       /* Discard magic */
       if ((flags & MS_MGC_MSK) == MS_MGC_VAL)
