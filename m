Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZEUAbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZEUAbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZEUA2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37164 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZEUA2R (ORCPT
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
Subject: [PATCH 11/20] sysfs: Update s_iattr on link and unlink.
Date: Wed, 20 May 2009 17:28:05 -0700
Message-Id: <1242865694-2100-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-10-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-9-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-10-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently sysfs updates the timestamps on the vfs directory
inode when we create or remove a directory entry but doesn't
update the cached copy on the sysfs_dirent, fix that oversight.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8dd2abf..94b926f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -480,6 +480,8 @@ static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
  */
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	struct iattr *ps_iattr;
+
 	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
 		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
 		WARN(1, KERN_WARNING
@@ -500,6 +502,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 
 	sysfs_link_sibling(sd);
 
+	/* Update timestamps on the parent */
+	ps_iattr = acxt->parent_sd->s_iattr;
+	if (ps_iattr)
+		ps_iattr->ia_ctime = ps_iattr->ia_mtime = CURRENT_TIME;
+
 	return 0;
 }
 
@@ -520,10 +527,17 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	struct iattr *ps_iattr;
+
 	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
 
 	sysfs_unlink_sibling(sd);
 
+	/* Update timestamps on the parent */
+	ps_iattr = acxt->parent_sd->s_iattr;
+	if (ps_iattr)
+		ps_iattr->ia_ctime = ps_iattr->ia_mtime = CURRENT_TIME;
+
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
 	sd->s_sibling = acxt->removed;
 	acxt->removed = sd;
-- 
1.6.1.2.350.g88cc

