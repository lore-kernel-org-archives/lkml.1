Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388Ab0AKUWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0AKUWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365Ab0AKUWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:22:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40012 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0AKUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:22:10 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 1/7] sysfs: Serialize updates to the vfs inode
Date: Mon, 11 Jan 2010 12:21:49 -0800
Message-Id: <1263241315-19499-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1d41g9z3q.fsf@fess.ebiederm.org>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

The way the vfs is structured only calls to the filesystem
methods actually update the vfs inode.  We add to the
normal number of places where the vfs inode is updated by
also updating the vfs inode in sysfs_refresh_inode.

Grabbing the inode mutex in sysfs_permission and sysfs_getattr
causes deadlocks, because somtimes those operations are called
with the inode mutex held, but not always.  Therefore we can
not depend upon the inode mutex to serialize all updates
to the vfs inode.

We take the sysfs_mutex in all of those places so we can
also use it to protect the vfs inode.  To accomplish that
we simply requires extending the vfs inode in sysfs_setattr
over inode_change_ok (so we have an unchanging inode
when we perform the check), and inode_setattr.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 220b758..104cbc1 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -112,20 +112,20 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
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

