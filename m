Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZA2GvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZA2GvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 01:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZA2Gut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 01:50:49 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40120 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbZA2Gus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 01:50:48 -0500
Date: Wed, 28 Jan 2009 22:46:43 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: [RFC][PATCH 3/5] Move common mknod_ptmx() calls into caller
Message-ID: <20090129064643.GD23160@us.ibm.com>
References: <20090129064259.GA23160@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129064259.GA23160@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 28 Jan 2009 18:54:25 -0800
Subject: [RFC][PATCH 3/5] Move common mknod_ptmx() calls into caller

We create 'ptmx' node in both single-instance and multiple-instance
mounts. So devpts_get_sb() can call mknod_ptmx() once rather than
have both modes calling mknod_ptmx() separately.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 fs/devpts/inode.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 8e00779..97b8e9f 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -343,17 +343,7 @@ static int new_pts_mount(struct file_system_type *fs_type, int flags,
 	fsi = DEVPTS_SB(mnt->mnt_sb);
 	memcpy(&fsi->mount_opts, opts, sizeof(opts));
 
-	err = mknod_ptmx(mnt->mnt_sb);
-	if (err)
-		goto fail;
-
 	return 0;
-
-fail:
-	dput(mnt->mnt_sb->s_root);
-	up_write(&mnt->mnt_sb->s_umount);
-	deactivate_super(mnt->mnt_sb);
-	return err;
 }
 
 /*
@@ -421,13 +411,6 @@ static int init_pts_mount(struct file_system_type *fs_type, int flags,
 	if (err)
 		return err;
 
-	err = mknod_ptmx(mnt->mnt_sb);
-	if (err) {
-		dput(mnt->mnt_sb->s_root);
-		up_write(&mnt->mnt_sb->s_umount);
-		deactivate_super(mnt->mnt_sb);
-	}
-
 	return err;
 }
 
@@ -444,9 +427,24 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	}
 
 	if (opts.newinstance)
-		return new_pts_mount(fs_type, flags, data, &opts, mnt);
+		error = new_pts_mount(fs_type, flags, data, &opts, mnt);
 	else
-		return init_pts_mount(fs_type, flags, data, &opts, mnt);
+		error = init_pts_mount(fs_type, flags, data, &opts, mnt);
+
+	if (error)
+		return error;
+
+	error = mknod_ptmx(mnt->mnt_sb);
+	if (error)
+		goto out_dput;
+
+	return 0;
+
+out_dput:
+	dput(mnt->mnt_sb->s_root);
+	up_write(&mnt->mnt_sb->s_umount);
+	deactivate_super(mnt->mnt_sb);
+	return error;
 }
 
 #else
-- 
1.5.2.5

