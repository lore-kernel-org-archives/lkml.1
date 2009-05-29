Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbZE2U2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbZE2U2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZE2UVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:21:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41794 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763410AbZE2UTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:54 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:23 -0700
Message-Id: <1243628376-22905-13-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 13/26] sysfs: Update s_iattr on link and unlink.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
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
 fs/sysfs/dir.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e0bf3a5..c6472d8 100644
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
1.6.3.1.54.g99dd.dirty

