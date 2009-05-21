Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZEUAa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZEUAa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZEUA2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37145 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZEUA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 07/20] sysfs: Simplify sysfs_chmod_file semantics
Date: Wed, 20 May 2009 17:28:01 -0700
Message-Id: <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
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

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/file.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b1606e0..0786b41 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -602,17 +602,9 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
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
1.6.1.2.350.g88cc

