Return-Path: <linux-kernel-owner+w=401wt.eu-S1764400AbZE2UYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764400AbZE2UYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763547AbZE2UUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:20:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41798 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762972AbZE2UTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:54 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Fri, 29 May 2009 13:19:11 -0700
Message-Id: <1243628376-22905-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, benjamin.thery@bull.net, dlezcano@fr.ibm.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=2 Fuz1=2 Fuz2=2 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0270]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=2 Fuz1=2 Fuz2=2]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 01/26] sysfs: Implement sysfs_rename_link
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Because of rename ordering problems we occassionally give false
warnings about invalid sysfs operations, so implement a helper
function for this common sysfs idiom.

This is a stripped down version of an earlier patch that
also added sysfs_delete_link.

Cc: Benjamin Thery <benjamin.thery@bull.net>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/symlink.c    |   16 ++++++++++++++++
 include/linux/sysfs.h |    9 +++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index a3ba217..11c4da5 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -122,6 +122,22 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 	sysfs_hash_and_remove(parent_sd, name);
 }
 
+/**
+ *	sysfs_rename_link - rename symlink in object's directory.
+ *	@kobj:	object we're acting for.
+ *	@targ:	object we're pointing to.
+ *	@old:	previous name of the symlink.
+ *	@new:	new name of the symlink.
+ *
+ *	A helper function for the common rename symlink idiom.
+ */
+int sysfs_rename_link(struct kobject *kobj, struct kobject *targ,
+			const char *old, const char *new)
+{
+	sysfs_remove_link(kobj, old);
+	return sysfs_create_link(kobj, targ, new);
+}
+
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
 				 struct sysfs_dirent *target_sd, char *path)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 9d68fed..18c8e70 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -109,6 +109,9 @@ int __must_check sysfs_create_link_nowarn(struct kobject *kobj,
 					  const char *name);
 void sysfs_remove_link(struct kobject *kobj, const char *name);
 
+int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
+			const char *old_name, const char *new_name);
+
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
 int sysfs_update_group(struct kobject *kobj,
@@ -202,6 +205,12 @@ static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
 }
 
+static inline int sysfs_rename_link(struct kobject *k, struct kobject *t,
+				    const char *old_name, const char *new_name)
+{
+	return 0;
+}
+
 static inline int sysfs_create_group(struct kobject *kobj,
 				     const struct attribute_group *grp)
 {
-- 
1.6.3.1.54.g99dd.dirty

