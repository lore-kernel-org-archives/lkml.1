Return-Path: <linux-kernel-owner+w=401wt.eu-S1764695AbZE2UZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764695AbZE2UZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763305AbZE2UUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41842 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763418AbZE2UT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:57 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:36 -0700
Message-Id: <1243628376-22905-26-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0050]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=2]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 26/26] sysfs: In sysfs_add_one fail if the targe directory has been removed.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

If a bug in the upper layers results in someone attempting to add
to a sysfs directory that has already been removed, warn about it
and fail.

I don't believe this has ever happened, and it certainly never should
happen, but be strict to avoid errors creeping in.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 7da42fb..fda141d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -394,21 +394,17 @@ static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
 int sysfs_add_one(struct sysfs_dirent *parent_sd, struct sysfs_dirent *sd)
 {
 	struct iattr *ps_iattr;
+	char *path;
+	int result;
 
 	mutex_lock(&sysfs_mutex);
-	if (sysfs_find_dirent(parent_sd, sd->s_name)) {
-		char *path;
-		mutex_unlock(&sysfs_mutex);
 
-		path = kzalloc(PATH_MAX, GFP_KERNEL);
-		WARN(1, KERN_WARNING
-		     "sysfs: cannot create duplicate filename '%s'\n",
-		     (path == NULL) ? sd->s_name :
-		     strcat(strcat(sysfs_pathname(parent_sd, path), "/"),
-		            sd->s_name));
-		kfree(path);
-		return -EEXIST;
-	}
+	result = -ENOENT;
+	if (parent_sd->s_flags & SYSFS_FLAG_REMOVED)
+		goto out_err;
+
+	if (sysfs_find_dirent(parent_sd, sd->s_name))
+		goto out_err;
 
 	sd->s_parent = sysfs_get(parent_sd);
 	sysfs_link_sibling(sd);
@@ -417,9 +413,22 @@ int sysfs_add_one(struct sysfs_dirent *parent_sd, struct sysfs_dirent *sd)
 	ps_iattr = parent_sd->s_iattr;
 	if (ps_iattr)
 		ps_iattr->ia_ctime = ps_iattr->ia_mtime = CURRENT_TIME;
-
 	mutex_unlock(&sysfs_mutex);
 	return 0;
+
+out_err:
+	mutex_unlock(&sysfs_mutex);
+
+	path = kzalloc(PATH_MAX, GFP_KERNEL);
+	WARN(1, KERN_WARNING "sysfs: cannot create '%s' %s\n",
+		(path == NULL) ? sd->s_name :
+		strcat(strcat(sysfs_pathname(parent_sd, path), "/"),
+		       sd->s_name),
+		(result == -EEXIST ? "duplicate filename" : "no such directory")
+		);
+	kfree(path);
+
+	return result;
 }
 
 /**
-- 
1.6.3.1.54.g99dd.dirty

