Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZKCL7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZKCL7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZKCL7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:59:11 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40765 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZKCL5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:57:19 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 07/13] sysfs: Update s_iattr on link and unlink.
Date: Tue,  3 Nov 2009 03:57:03 -0800
Message-Id: <1257249429-12384-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently sysfs updates the timestamps on the vfs directory
inode when we create or remove a directory entry but doesn't
update the cached copy on the sysfs_dirent, fix that oversight.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b5e8499..fa37126 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -464,6 +464,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  */
 int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	struct sysfs_inode_attrs *ps_iattr;
+
 	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
 		return -EEXIST;
 
@@ -476,6 +478,13 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 
 	sysfs_link_sibling(sd);
 
+	/* Update timestamps on the parent */
+	ps_iattr = acxt->parent_sd->s_iattr;
+	if (ps_iattr) {
+		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
+		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
+	}
+
 	return 0;
 }
 
@@ -554,10 +563,19 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	struct sysfs_inode_attrs *ps_iattr;
+
 	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
 
 	sysfs_unlink_sibling(sd);
 
+	/* Update timestamps on the parent */
+	ps_iattr = acxt->parent_sd->s_iattr;
+	if (ps_iattr) {
+		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
+		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
+	}
+
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
 	sd->s_sibling = acxt->removed;
 	acxt->removed = sd;
-- 
1.6.5.2.143.g8cc62

