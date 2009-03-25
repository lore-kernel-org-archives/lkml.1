Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZCYAle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZCYAle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbZCYAaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:12 -0400
Received: from kroah.org ([198.145.64.141]:54121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756825AbZCYAaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/61] sysfs: Take sysfs_mutex when fetching the root inode.
Date: Tue, 24 Mar 2009 17:26:35 -0700
Message-Id: <1237940825-22904-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

sysfs_get_inode ultimately calls sysfs_count_nlink when the a
directory inode is fectched.  sysfs_count_nlink needs to be
called under the sysfs_mutex to guard against the unlikely
but possible scenario that the root directory is changing
as we are counting the number entries in it, and just in
general to be consistent.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/mount.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 8133ca3..84ef378 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -52,7 +52,9 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sysfs_sb = sb;
 
 	/* get root inode, initialize and unlock it */
+	mutex_lock(&sysfs_mutex);
 	inode = sysfs_get_inode(&sysfs_root);
+	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		return -ENOMEM;
-- 
1.6.2

