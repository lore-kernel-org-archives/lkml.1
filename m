Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbZLKWdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbZLKWdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761296AbZLKWdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:33:47 -0500
Received: from kroah.org ([198.145.64.141]:32788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762718AbZLKWZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/27] sysfs: Simplify sysfs_chmod_file semantics
Date: Fri, 11 Dec 2009 14:24:37 -0800
Message-Id: <1260570289-6997-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently every caller of sysfs_chmod_file happens at either
file creation time to set a non-default mode or in response
to a specific user requested space change in policy.  Making
timestamps of when the chmod happens and notification of
a file changing mode uninteresting.

Remove the unnecessary time stamp and filesystem change
notification, and removes the last of the explicit inotify
and donitfy support from sysfs.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index f5ea468..faa1a80 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -604,17 +604,9 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 	mutex_lock(&inode->i_mutex);
 
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
-	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	newattrs.ia_ctime = current_fs_time(inode->i_sb);
+	newattrs.ia_valid = ATTR_MODE;
 	rc = sysfs_setattr(victim, &newattrs);
 
-	if (rc == 0) {
-		fsnotify_change(victim, newattrs.ia_valid);
-		mutex_lock(&sysfs_mutex);
-		victim_sd->s_mode = newattrs.ia_mode;
-		mutex_unlock(&sysfs_mutex);
-	}
-
 	mutex_unlock(&inode->i_mutex);
  out:
 	dput(victim);
-- 
1.6.5.5

