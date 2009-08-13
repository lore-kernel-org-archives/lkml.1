Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZHMTrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZHMTrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZHMTrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:48 -0400
Received: from kroah.org ([198.145.64.141]:36712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579AbZHMTrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:36 2009
Message-Id: <20090813194336.458805351@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: [patch 07/28] sysfs: fix hardlink count on device_move
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=sysfs-fix-hardlink-count-on-device_move.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

commit 0f58b44582001c8bcdb75f36cf85ebbe5170e959 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -914,8 +914,10 @@ again:
 	/* Remove from old parent's list and insert into new parent's list. */
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
+	drop_nlink(old_parent->d_inode);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
+	inc_nlink(new_parent->d_inode);
 	sysfs_link_sibling(sd);
 
  out_unlock:


