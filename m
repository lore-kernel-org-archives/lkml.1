Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYAPDGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYAPDGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYAPDGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:06:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:57723 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbYAPDGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:06:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=oKqYV95bHWE5WgYSrYO3JT+Ikq431O2sMrXAaFMXHBrysC6gUCBUbOLC35aAwqyQ7kDP9EWMOWgAHoC+1bQhN7sam+oGHtWeXBvzGkA0BZ2Rn4h9PIEjRdhF4//T/s3qBO4Ylew0HYtwT5pD8C0VzgW3frjAXyAlkfAzBwohMNk=
Message-ID: <478D74A6.7000206@gmail.com>
Date: Wed, 16 Jan 2008 12:06:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: [PATCH 2.6.24-rc7 1/2] sysfs: make sysfs_lookup() return ERR_PTR(-ENOENT)
 on failed lookup
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs tries to keep dcache a strict subset of sysfs_dirent tree by
shooting down dentries when a node is removed, that is, no negative
dentry for sysfs.  However, the lookup function returned NULL and thus
created negative dentries when the target node didn't exist.

Make sysfs_lookup() return ERR_PTR(-ENOENT) on lookup failure.  This
fixes the NULL dereference bug in sysfs_get_dentry() discovered by
bluetooth rfcomm device moving around.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: work/fs/sysfs/dir.c
===================================================================
--- work.orig/fs/sysfs/dir.c
+++ work/fs/sysfs/dir.c
@@ -678,8 +678,10 @@ static struct dentry * sysfs_lookup(stru
 	sd = sysfs_find_dirent(parent_sd, dentry->d_name.name);
 
 	/* no such entry */
-	if (!sd)
+	if (!sd) {
+		ret = ERR_PTR(-ENOENT);
 		goto out_unlock;
+	}
 
 	/* attach dentry and inode */
 	inode = sysfs_get_inode(sd);
