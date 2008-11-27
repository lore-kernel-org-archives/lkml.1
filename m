Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYK0Q7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYK0Q7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYK0Q7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:59:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47674 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYK0Q7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:59:36 -0500
Date: Thu, 27 Nov 2008 16:59:29 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: [PATCH v3] relatime: Make relatime smarter
Message-ID: <20081127165929.GA23366@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk> <20081127164754.GC22963@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127164754.GC22963@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make relatime smarter
    
Allow atime to be updated once per day even with relatime. This lets
utilities like tmpreaper (which delete files based on last access time)
continue working. The time between atime updates can be configured at boot
with the relatime_interval kernel argument, or at runtime through /proc
    
Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Drop the default behaviour section - as Alan suggests, it can be handled 
in userspace. Merge the configuration code into the change in behaviour 
patch.

 Documentation/kernel-parameters.txt |    4 ++
 fs/inode.c                          |   59 +++++++++++++++++++++++++++++-----
 include/linux/mount.h               |    2 +
 kernel/sysctl.c                     |    9 +++++
 4 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e0f346d..6d0dc0a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1847,6 +1847,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			[KNL, SMP] Set scheduler's default relax_domain_level.
 			See Documentation/cpusets.txt.
 
+	relatime_interval=
+			[FS] relative atime update frequency, in seconds.
+			(default: 1 day: 86400 seconds)
+
 	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
 
 	reservetop=	[X86-32]
diff --git a/fs/inode.c b/fs/inode.c
index 0487ddb..51e9ae1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1179,6 +1179,52 @@ sector_t bmap(struct inode * inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
+/*
+ * Relative atime updates frequency (default: 1 day):
+ */
+int relatime_interval __read_mostly = 24*60*60;
+
+/*
+ * Allow overriding the default relatime value on the kernel command line
+ */
+static int __init set_relatime_interval(char *str)
+{
+	get_option(&str, &relatime_interval);
+
+	return 1;
+}
+__setup("relatime_interval=", set_relatime_interval);
+
+/*
+ * With relative atime, only update atime if the
+ * previous atime is earlier than either the ctime or
+ * mtime.
+ */
+static int relatime_need_update(struct inode *inode, struct timespec now)
+{
+	/*
+	 * Is mtime younger than atime? If yes, update atime:
+	 */
+	if (timespec_compare(&inode->i_mtime, &inode->i_atime) >= 0)
+		return 1;
+	/*
+	 * Is ctime younger than atime? If yes, update atime:
+	 */
+	if (timespec_compare(&inode->i_ctime, &inode->i_atime) >= 0)
+		return 1;
+
+	/*
+	 * Is the previous atime value older than the update interval?
+	 * If yes, update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= relatime_interval)
+		return 1;
+	/*
+	 * Good, we can skip the atime update:
+	 */
+	return 0;
+}
+
 /**
  *	touch_atime	-	update the access time
  *	@mnt: mount the inode is accessed on
@@ -1206,17 +1252,12 @@ void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
 		goto out;
 	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
 		goto out;
-	if (mnt->mnt_flags & MNT_RELATIME) {
-		/*
-		 * With relative atime, only update atime if the previous
-		 * atime is earlier than either the ctime or mtime.
-		 */
-		if (timespec_compare(&inode->i_mtime, &inode->i_atime) < 0 &&
-		    timespec_compare(&inode->i_ctime, &inode->i_atime) < 0)
-			goto out;
-	}
 
 	now = current_fs_time(inode->i_sb);
+
+	if (mnt->mnt_flags & MNT_RELATIME)
+		if (!relatime_need_update(inode, now))
+			goto out;
 	if (timespec_equal(&inode->i_atime, &now))
 		goto out;
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index cab2a85..978fb10 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -112,4 +112,6 @@ extern void mark_mounts_for_expiry(struct list_head *mounts);
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
+extern int relatime_interval;
+
 #endif /* _LINUX_MOUNT_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9d048fa..f085ad6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -29,6 +29,7 @@
 #include <linux/utsname.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/kobject.h>
@@ -1334,6 +1335,14 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "relatime_interval",
+		.data		= &relatime_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
 		.ctl_name	= CTL_UNNUMBERED,

-- 
Matthew Garrett | mjg59@srcf.ucam.org
