Return-Path: <linux-kernel-owner+w=401wt.eu-S1763637AbZE2UUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763637AbZE2UUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763414AbZE2UT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:19:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41741 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761516AbZE2UTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:53 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:15 -0700
Message-Id: <1243628376-22905-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0115]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 05/26] sysfs: Improve sysfs directory deletion debugging.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

We have found several cases where directories are deleted without
removing all of their subdirectories.  That case isn't valid so
warn anyone who makes that mistake, and continue to leak dirents
to keep the system as operational as possible.

Move the debug message when a directory is deleted into remove_dir
so we are told when subdirectories are deleted as well as full
fledge kobject directories.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a55e1d4..60482be 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -732,12 +732,28 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.setattr	= sysfs_setattr,
 };
 
-static void remove_dir(struct sysfs_dirent *sd)
+static void remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_addrm_cxt acxt;
 
-	sysfs_addrm_start(&acxt, sd->s_parent);
-	sysfs_remove_one(&acxt, sd);
+	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
+
+	/* Removing non-empty directories is not valid complain! */
+	if (unlikely(dir_sd->s_dir.children)) {
+		struct sysfs_dirent *sd;
+
+		WARN(1, KERN_WARNING "sysfs: removing non-empty dir: %s\n",
+			dir_sd->s_name);
+
+		mutex_lock(&sysfs_mutex);
+		for (sd = dir_sd->s_dir.children; sd; sd  = sd->s_sibling)
+			printk(KERN_WARNING "%s/%s\n",
+				dir_sd->s_name, sd->s_name);
+		mutex_unlock(&sysfs_mutex);
+	}
+
+	sysfs_addrm_start(&acxt, dir_sd->s_parent);
+	sysfs_remove_one(&acxt, dir_sd);
 	sysfs_addrm_finish(&acxt);
 }
 
@@ -752,7 +768,6 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent **pos;
 
-	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt, dir_sd);
 	pos = &dir_sd->s_dir.children;
 	while (*pos) {
-- 
1.6.3.1.54.g99dd.dirty

