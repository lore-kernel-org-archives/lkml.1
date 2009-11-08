Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZKHH1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZKHH1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 02:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZKHH1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 02:27:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55187 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZKHH1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 02:27:36 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 15/15] sysfs: Protect sysfs_refresh_inode with inode mutex.
Date: Sat,  7 Nov 2009 23:27:13 -0800
Message-Id: <1257665233-12468-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1pr7tmqb4.fsf@fess.ebiederm.org>
References: <m1pr7tmqb4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

In general everything that writes to vfs inodes holds the
inode mutex, so hold the inode mutex over sysfs_refresh_inode.
The sysfs data structures don't need this but it looks like the
vfs might.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 8197e1a..75516cd 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -237,9 +237,11 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *sta
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	struct inode *inode = dentry->d_inode;
 
+	mutex_lock(&inode->i_mutex);
 	mutex_lock(&sysfs_mutex);
 	sysfs_refresh_inode(sd, inode);
 	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&inode->i_mutex);
 
 	generic_fillattr(inode, stat);
 	return 0;
@@ -349,9 +351,11 @@ int sysfs_permission(struct inode *inode, int mask)
 {
 	struct sysfs_dirent *sd = inode->i_private;
 
+	mutex_lock(&inode->i_mutex);
 	mutex_lock(&sysfs_mutex);
 	sysfs_refresh_inode(sd, inode);
 	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&inode->i_mutex);
 
 	return generic_permission(inode, mask, NULL);
 }
-- 
1.6.5.2.143.g8cc62

