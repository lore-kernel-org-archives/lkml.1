Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZGNP5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZGNP5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZGNP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:57:37 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:55217 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbZGNP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:57:36 -0400
Message-ID: <4A5CAA9F.1050302@linux.vnet.ibm.com>
Date: Tue, 14 Jul 2009 17:56:15 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: gregkh@suse.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: fix hardlink count on device_move
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
---
 fs/sysfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.31-rc3/fs/sysfs/dir.c
===================================================================
--- linux-2.6.31-rc3.orig/fs/sysfs/dir.c
+++ linux-2.6.31-rc3/fs/sysfs/dir.c
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

