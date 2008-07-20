Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYGTGcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYGTGcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 02:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYGTGbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 02:31:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYGTGbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 02:31:51 -0400
From: Neil Brown <neilb@suse.de>
To: Tejun Heo <teheo@suse.de>
Date: Sun, 20 Jul 2008 16:31:42 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18562.56270.855607.668110@notabene.brown>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] sysfs: Support sysfs_notify from atomic context with
 new sysfs_notify_dirent
In-Reply-To: message from Tejun Heo on Wednesday July 16
References: <18557.11132.728439.827572@notabene.brown>
	<487D2F01.5000404@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tejun,

On Wednesday July 16, teheo@suse.de wrote:
> 
> I don't think this inline technique is really necessary.  Please just
> drop the inline versions.  Other than that,

Yep, they don't really need to be inline.  I've fixed that.

> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

> 
> BTW, things like this strongly suggest that we really should switch to
> sd-based interface instead of combination of kobj and optional name string.

Yes.  Once this is in I'll change md over to use it and then see if
anything else could benefit from the change.

Greg:  Can you take this one now?  Thanks.

NeilBrown


>From 39c1ca9fcdfdf7b9f582d0dfb5e80d8ce0d66f7c Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Sun, 20 Jul 2008 16:29:05 +1000
Subject: [PATCH] Support sysfs_notify from atomic context with new sysfs_notify_dirent

sysfs_notify currently takes sysfs_mutex.
This means that it cannot be called in atomic context.
sysfs_mutex  is sometimes held over a malloc (sysfs_rename_dir)
so it can block on low memory.

In md I want to be able to notify on a sysfs attribute from
atomic context, and I don't want to block on low memory because I
could be in the writeout path for freeing memory.

So:
 - export the "sysfs_dirent" structure along with sysfs_get, sysfs_put
   and sysfs_get_dirent so I can get the sysfs_dirent that I want to
   notify on and hold it in an md structure.
 - split sysfs_notify_dirent out of sysfs_notify so the sysfs_dirent
   can be notified on with no blocking (just a spinlock).

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c        |   18 ++++++++++++++++++
 fs/sysfs/file.c       |   31 ++++++++++++++++++-------------
 fs/sysfs/sysfs.h      |   15 ---------------
 include/linux/sysfs.h |   23 +++++++++++++++++++++++
 4 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8c0e4b9..09e40a1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -30,6 +30,23 @@ DEFINE_SPINLOCK(sysfs_assoc_lock);
 static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
 
+struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
+{
+	if (sd) {
+		WARN_ON(!atomic_read(&sd->s_count));
+		atomic_inc(&sd->s_count);
+	}
+	return sd;
+}
+EXPORT_SYMBOL_GPL(sysfs_get);
+
+void sysfs_put(struct sysfs_dirent *sd)
+{
+	if (sd && atomic_dec_and_test(&sd->s_count))
+		release_sysfs_dirent(sd);
+}
+EXPORT_SYMBOL_GPL(sysfs_put);
+
 /**
  *	sysfs_link_sibling - link sysfs_dirent into sibling list
  *	@sd: sysfs_dirent of interest
@@ -606,6 +623,7 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 
 	return sd;
 }
+EXPORT_SYMBOL_GPL(sysfs_get_dirent);
 
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e7735f6..c6060e8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -440,6 +440,22 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	return POLLERR|POLLPRI;
 }
 
+void sysfs_notify_dirent(struct sysfs_dirent *sd)
+{
+	struct sysfs_open_dirent *od;
+
+	spin_lock(&sysfs_open_dirent_lock);
+
+	od = sd->s_attr.open;
+	if (od) {
+		atomic_inc(&od->event);
+		wake_up_interruptible(&od->poll);
+	}
+
+	spin_unlock(&sysfs_open_dirent_lock);
+}
+EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
+
 void sysfs_notify(struct kobject *k, char *dir, char *attr)
 {
 	struct sysfs_dirent *sd = k->sd;
@@ -450,19 +466,8 @@ void sysfs_notify(struct kobject *k, char *dir, char *attr)
 		sd = sysfs_find_dirent(sd, dir);
 	if (sd && attr)
 		sd = sysfs_find_dirent(sd, attr);
-	if (sd) {
-		struct sysfs_open_dirent *od;
-
-		spin_lock(&sysfs_open_dirent_lock);
-
-		od = sd->s_attr.open;
-		if (od) {
-			atomic_inc(&od->event);
-			wake_up_interruptible(&od->poll);
-		}
-
-		spin_unlock(&sysfs_open_dirent_lock);
-	}
+	if (sd)
+		sysfs_notify_dirent(sd);
 
 	mutex_unlock(&sysfs_mutex);
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ce4e15f..ef5ecc1 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -123,21 +123,6 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
 void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
-static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
-{
-	if (sd) {
-		WARN_ON(!atomic_read(&sd->s_count));
-		atomic_inc(&sd->s_count);
-	}
-	return sd;
-}
-
-static inline void sysfs_put(struct sysfs_dirent *sd)
-{
-	if (sd && atomic_dec_and_test(&sd->s_count))
-		release_sysfs_dirent(sd);
-}
-
 /*
  * inode.c
  */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 7858eac..3ab58db 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -78,6 +78,8 @@ struct sysfs_ops {
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
 };
 
+struct sysfs_dirent;
+
 #ifdef CONFIG_SYSFS
 
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
@@ -115,6 +117,11 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 
 void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
+void sysfs_notify_dirent(struct sysfs_dirent *sd);
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name);
+struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd);
+void sysfs_put(struct sysfs_dirent *sd);
 
 extern int __must_check sysfs_init(void);
 
@@ -215,6 +222,22 @@ static inline void sysfs_remove_file_from_group(struct kobject *kobj,
 static inline void sysfs_notify(struct kobject *kobj, char *dir, char *attr)
 {
 }
+static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
+{
+}
+static inline
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name)
+{
+	return NULL;
+}
+static inline struct sysfs_dirent sysfs_get(struct sysfs_dirent *sd)
+{
+	return NULL;
+}
+static inline void sysfs_put(struct sysfs_dirent *sd)
+{
+}
 
 static inline int __must_check sysfs_init(void)
 {
-- 
1.5.6.3

