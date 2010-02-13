Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0BMDWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:22:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53284 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0BMDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:22:43 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 1/6] sysfs: Serialize updates to the vfs inode
Date: Fri, 12 Feb 2010 19:22:23 -0800
Message-Id: <1266031348-30068-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
References: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
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
1.6.5.2.143.g8cc62

