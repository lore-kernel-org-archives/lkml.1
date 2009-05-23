Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZEWUOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZEWUOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZEWUN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:13:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39747 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbZEWUNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:13:48 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Sat, 23 May 2009 13:13:11 -0700
Message-Id: <1243109591-21611-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1bppofm9k.fsf@fess.ebiederm.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0028]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 25/20] sysfs:  Only support removing emtpy sysfs directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

I have looked and I have not found a single legitimate case today where
we remove sysfs directories with anything in them.  The only case I have
found to date was a bug.  It was a problem of ownership.  The files in
the directory where not owned by the directory itself.   Leaving open
the potential for double deletion of the directory contents.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b3058f5..6b3e038 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -617,30 +617,14 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.permission	= sysfs_permission,
 };
 
-static struct sysfs_dirent *sysfs_get_one(struct sysfs_dirent *dir_sd)
-{
-	struct sysfs_dirent *sd = dir_sd;
-	mutex_lock(&sysfs_mutex);
-	while ((sysfs_type(sd) == SYSFS_DIR) && sd->s_dir.children)
-		sd = sd->s_dir.children;
-	if (sd != dir_sd)
-		sysfs_get(sd);
-	else
-		sd = NULL;
-	mutex_unlock(&sysfs_mutex);
-	return sd;
-}
-
 static void remove_dir(struct sysfs_dirent *dir_sd)
 {
-	struct sysfs_dirent *sd;
-
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 
-	while ((sd = sysfs_get_one(dir_sd))) {
-		sysfs_remove_one(sd);
-		sysfs_put(sd);
-	}
+	WARN(dir_sd->s_dir.children,
+		KERN_WARNING "sysfs: removing non-empty dir: %s\n",
+		dir_sd->s_name);
+
 	sysfs_remove_one(dir_sd);
 }
 
-- 
1.6.3.1.54.g99dd.dirty

