Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZG1Vpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZG1Vpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZG1Vp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:45:29 -0400
Received: from kroah.org ([198.145.64.141]:55413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZG1Vp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:45:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/5] sysfs: fix hardlink count on device_move
Date: Tue, 28 Jul 2009 14:44:37 -0700
Message-Id: <1248817481-13372-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090728213826.GC13090@kroah.com>
References: <20090728213826.GC13090@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Update directory hardlink count when moving kobjects to a new parent.
Fixes the following problem which occurs when several devices are
moved to the same parent and then unregistered:

> ls -laF /sys/devices/css0/defunct/
> total 0
> drwxr-xr-x 4294967295 root root    0 2009-07-14 17:02 ./
> drwxr-xr-x        114 root root    0 2009-07-14 17:02 ../
> drwxr-xr-x          2 root root    0 2009-07-14 17:01 power/
> -rw-r--r--          1 root root 4096 2009-07-14 17:01 uevent

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index d88d0fa..14f2d71 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -939,8 +939,10 @@ again:
 	/* Remove from old parent's list and insert into new parent's list. */
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
+	drop_nlink(old_parent->d_inode);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
+	inc_nlink(new_parent->d_inode);
 	sysfs_link_sibling(sd);
 
  out_unlock:
-- 
1.6.3.2

