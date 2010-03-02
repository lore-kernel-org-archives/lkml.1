Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0CBXdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:33:21 -0500
Received: from kroah.org ([198.145.64.141]:38688 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab0CBX3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/62] sysfs: Serialize updates to the vfs inode
Date: Tue,  2 Mar 2010 15:28:48 -0800
Message-Id: <1267572541-410-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

The vfs depends upon filesystem methods to update the
vfs inode.   Sysfs adds to the normal number of places
where the vfs inode is updated by also updatng the
vfs inode in sysfs_refresh_inode.

Typically the inode mutex is used to serialize updates
to the vfs inode, but grabbing the inode mutex in
sysfs_permission and sysfs_getattr causes deadlocks,
because sometimes the vfs calls those operations with
the inode mutex held.  Therefore sysfs  can not use the
inode mutex to serial updates to the vfs inode.

The sysfs_mutex is acquired in all of the routines
where sysfs updates the vfs inode, and with a small
change we can consistently protext sysfs vfs inode
updates with the sysfs_mutex. To protect the sysfs
vfs inode updates with the sysfs_mutex simply requires
extending the scope of sysfs_mutex in sysfs_setattr
over inode_setattr, and over inode_change_ok (so we
have an unchanging inode when we perform the check).

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 6a06a1d..0d09f6c 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -111,20 +111,20 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (!sd)
 		return -EINVAL;
 
+	mutex_lock(&sysfs_mutex);
 	error = inode_change_ok(inode, iattr);
 	if (error)
-		return error;
+		goto out;
 
 	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
 
 	error = inode_setattr(inode, iattr);
 	if (error)
-		return error;
+		goto out;
 
-	mutex_lock(&sysfs_mutex);
 	error = sysfs_sd_setattr(sd, iattr);
+out:
 	mutex_unlock(&sysfs_mutex);
-
 	return error;
 }
 
-- 
1.7.0.1

