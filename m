Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZE1XF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZE1XF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZE1XCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:02:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32900 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZE1XCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:24 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:01:03 -0700
Message-Id: <1243551665-23596-22-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
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
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 22/24] sysfs: Make sysfs_rename_link atomic
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Use the existing sysfs_rename to make sysfs_rename_link an atomic
operation that does less work.  While I am at add additional sanity
checking to ensure it is a symlink I am renaming.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/symlink.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index fc5fc86..39d050b 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -106,8 +106,30 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 int sysfs_rename_link(struct kobject *kobj, struct kobject *targ,
 			const char *old, const char *new)
 {
-	sysfs_remove_link(kobj, old);
-	return sysfs_create_link(kobj, targ, new);
+	struct sysfs_dirent *parent_sd, *sd = NULL;
+	int result;
+
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	result = -ENOENT;
+	sd = sysfs_get_dirent(parent_sd, old);
+	if (!sd)
+		goto out;
+
+	result = -EINVAL;
+	if (sysfs_type(sd) != SYSFS_KOBJ_LINK)
+		goto out;
+	if (sd->s_symlink.target_sd->s_dir.kobj != targ)
+		goto out;
+
+	result = sysfs_rename(sd, parent_sd, new);
+
+out:
+	sysfs_put(sd);
+	return result;
 }
 
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
-- 
1.6.3.1.54.g99dd.dirty

