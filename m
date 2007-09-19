Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbXISQg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbXISQg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbXISQgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:36:18 -0400
Received: from mail2.odcnet.com ([24.248.98.112]:52405 "EHLO srv.odcnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbXISQgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:36:17 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 12:36:17 EDT
Message-ID: <46F14EF3.3050606@3tera.com>
Date: Wed, 19 Sep 2007 09:31:47 -0700
From: Leonid Kalev <lion@3tera.com>
Reply-To: lion@3tera.com
User-Agent: Mozilla Thunderbird 1.0.7-1.1.fc3 (X11/20050929)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [UFS] fs/ufs/super.c misreads the file system state
Content-Type: multipart/mixed;
 boundary="------------010900020506080800040404"
X-OriginalArrivalTime: 19 Sep 2007 16:31:07.0285 (UTC) FILETIME=[7AC45450:01C7FADA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010900020506080800040404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

ufs_get_fs_state() needs the file system type to read the state from the 
correct place in the superblock. It takes the type from 
UFS_SB(sb)->s_flags, but that value is stored after the first call to 
ufs_get_fs_state(). The patch below moves the assignment of s_flags up, 
before the first call to ufs_get_fs_state().

The patch is against linux-2.6.23-rc6-git7, but it applies (with offset) 
to 2.6.22 and to earlier versions as well. It has been tested on the 
Solaris flavor of UFS (ufstype=sunx86) - with this change, the file 
system can be used in read-write mode.

* Please cc me when replying to this - I am not subscribed to the 
linux-kernel list. *

Leonid

--------------010900020506080800040404
Content-Type: text/x-patch;
 name="ufs_state_bug_l.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ufs_state_bug_l.patch"

--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -897,6 +897,8 @@
 
 	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
+	sbi->s_flags = flags;
+
 	/*
 	 * Check, if file system was correctly unmounted.
 	 * If not, make it read only.
@@ -1026,8 +1028,6 @@
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
 	
-	sbi->s_flags = flags;
-
 	inode = iget(sb, UFS_ROOTINO);
 	if (!inode || is_bad_inode(inode))
 		goto failed;

--------------010900020506080800040404--
