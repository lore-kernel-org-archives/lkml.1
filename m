Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZKCL7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZKCL7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZKCL7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:59:43 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40740 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZKCL5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:57:17 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 04/13] sysfs: Simplify sysfs_chmod_file semantics
Date: Tue,  3 Nov 2009 03:57:00 -0800
Message-Id: <1257249429-12384-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
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

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
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
1.6.5.2.143.g8cc62

