Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0BMDWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:22:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53298 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab0BMDWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:22:50 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 3/6] sysfs: Implement sysfs_rename_link
Date: Fri, 12 Feb 2010 19:22:25 -0800
Message-Id: <1266031348-30068-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
References: <m1mxzdstx2.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Because of rename ordering problems we occassionally give false
warnings about invalid sysfs operations.  So using sysfs_rename
create a sysfs_rename_link function that doesn't need strange
workarounds.

Cc: Benjamin Thery <benjamin.thery@bull.net>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/symlink.c    |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h |    9 +++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index c5eff49..1b9a3a1 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -123,6 +123,44 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
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
+}
+
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
 				 struct sysfs_dirent *target_sd, char *path)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2b24ae5..7ee8c31 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -148,6 +148,9 @@ int __must_check sysfs_create_link_nowarn(struct kobject *kobj,
 					  const char *name);
 void sysfs_remove_link(struct kobject *kobj, const char *name);
 
+int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
+			const char *old_name, const char *new_name);
+
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
 int sysfs_update_group(struct kobject *kobj,
@@ -241,6 +244,12 @@ static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
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
1.6.5.2.143.g8cc62

