Return-Path: <linux-kernel-owner+w=401wt.eu-S1764005AbZE2UWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764005AbZE2UWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbZE2UUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45195 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763280AbZE2UTx (ORCPT
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
Date: Fri, 29 May 2009 13:19:16 -0700
Message-Id: <1243628376-22905-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0124]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 06/26] sysfs: Don't hold addrm_start/addrm_finish over multiple removals.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

With respect to the basic integrity of the sysfs data structures holding
the locks across the deletion of multiple sysfs_dirents is unnecessary.

Upper layers are required to coordinate their activity so that they
do not add or delete entries in sysfs directories as they are being
removed, and I have seen nothing to indicate the don't. The upper layers
can not rely on sysfs doing anything for them as it is a compile option
and may not be there.  So the previous atomic delete of the directory
entries and the directory serves no useful purpose.

By removing the only case where addrm_start/addrm_finish are held
over multiple dirent removals I simplify the requirements and
pave the way removing sysfs_addrm_start and sysfs_addrm_finish
completely.

Additionally add some comments explaining some of the thinking behind
sysfs_dirent removal in __sysfs_remove_dir.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 60482be..3e3a87f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -762,23 +762,37 @@ void sysfs_remove_subdir(struct sysfs_dirent *sd)
 	remove_dir(sd);
 }
 
+static struct sysfs_dirent *get_dirent_to_remove(struct sysfs_dirent *dir_sd)
+{
+	struct sysfs_dirent *sd;
+
+	mutex_lock(&sysfs_mutex);
+	for (sd = dir_sd->s_dir.children; sd; sd = sd->s_sibling) {
+		/* Directories might be owned by someone else
+		 * making recursive directory removal unsafe.
+		 */
+		if (sysfs_type(sd) == SYSFS_DIR)
+			continue;
+		break;
+	}
+	sysfs_get(sd);
+	mutex_unlock(&sysfs_mutex);
+
+	return sd;
+}
 
 static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent **pos;
-
-	sysfs_addrm_start(&acxt, dir_sd);
-	pos = &dir_sd->s_dir.children;
-	while (*pos) {
-		struct sysfs_dirent *sd = *pos;
+	struct sysfs_dirent *sd;
 
-		if (sysfs_type(sd) != SYSFS_DIR)
-			sysfs_remove_one(&acxt, sd);
-		else
-			pos = &(*pos)->s_sibling;
+	/* Remove children that we think are safe */
+	while ((sd = get_dirent_to_remove(dir_sd))) {
+		sysfs_addrm_start(&acxt, sd->s_parent);
+		sysfs_remove_one(&acxt, sd);
+		sysfs_addrm_finish(&acxt);
+		sysfs_put(sd);
 	}
-	sysfs_addrm_finish(&acxt);
 
 	remove_dir(dir_sd);
 }
-- 
1.6.3.1.54.g99dd.dirty

