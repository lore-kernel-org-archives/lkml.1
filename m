Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZKDMFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZKDMFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZKDMFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:05:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37159 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZKDMFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:05:07 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 15/13] sysfs: Protect sysfs_refresh_inode with inode mutex.
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 04:05:08 -0800
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 03 Nov 2009 03\:53\:56 -0800")
Message-ID: <m1hbta1onf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In general everything that writes to vfs inodes holds the
inode mutex, so hold the inode mutex over sysfs_refresh_inode.
The sysfs data structures don't need this but it looks like the
vfs might.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e2595a7..ad549f5 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -240,9 +240,11 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *sta
 	struct sysfs_dirent *sd = dentry->d_fsdata;
 	struct inode *inode = dentry->d_inode;
 
+	mutex_lock(&inode->i_mutex);
 	mutex_lock(&sysfs_mutex);
 	sysfs_refresh_inode(sd, inode);
 	mutex_unlock(&sysfs_mutex);
+	mutex_unlock(&inode->i_mutex);
 
 	generic_fillattr(inode, stat);
 	return 0;
@@ -353,9 +355,11 @@ int sysfs_permission(struct inode *inode, int mask)
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

