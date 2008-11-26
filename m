Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYKZT6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYKZT6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYKZT6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:58:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45054 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYKZT62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:58:28 -0500
Date: Wed, 26 Nov 2008 19:58:24 +0000
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: [PATCH 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081126195824.GB3541@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126195457.GA3541@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the kernel to enable relatime on all mounts by default. This can 
be configured at build time or by a kernel parameter or sysctl. Also add 
an MS_NORELATIME mount option to allow the default to be overridden for 
specific mount points.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Updated version of Ingo's patch, but adds MS_NORELATIME. util-linux will 
need updating to match if this is merged.

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e0f346d..eba3b07 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -616,6 +616,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
+	default_relatime=
+			[FS] mount all filesystems with relative atime
+			updates by default.
+
 	vt.default_utf8=
 			[VT]
 			Format=<0|1>
@@ -1847,6 +1851,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			[KNL, SMP] Set scheduler's default relax_domain_level.
 			See Documentation/cpusets.txt.
 
+	relatime_interval=
+			[FS] relative atime update frequency, in seconds.
+			(default: 1 day: 86400 seconds)
+
 	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
 
 	reservetop=	[X86-32]
diff --git a/fs/Kconfig b/fs/Kconfig
index 522469a..fcd3d48 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1546,6 +1546,29 @@ config 9P_FS
 
 endif # NETWORK_FILESYSTEMS
 
+config DEFAULT_RELATIME
+	bool "Mount all filesystems with relatime by default"
+	default y
+	help
+	  If you say Y here, all your filesystems will be mounted
+	  with the "relatime" mount option. This eliminates many atime
+	  ('file last accessed' timestamp) updates (which otherwise
+	  is performed on every file access and generates a write
+	  IO to the inode) and thus speeds up IO. Atime is still updated,
+	  but only once per day.
+
+	  The mtime ('file last modified') and ctime ('file created')
+	  timestamp are unaffected by this change.
+
+	  Use the "norelatime" kernel boot option to turn off this
+	  feature.
+
+config DEFAULT_RELATIME_VAL
+	int
+	default "1" if DEFAULT_RELATIME
+	default "0"
+
+
 if BLOCK
 menu "Partition Types"
 
diff --git a/fs/inode.c b/fs/inode.c
index 348fa16..51e9ae1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1185,6 +1185,17 @@ EXPORT_SYMBOL(bmap);
 int relatime_interval __read_mostly = 24*60*60;
 
 /*
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
  * With relative atime, only update atime if the
  * previous atime is earlier than either the ctime or
  * mtime.
diff --git a/fs/namespace.c b/fs/namespace.c
index 65b3dc8..76f30b5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1883,6 +1883,24 @@ int copy_mount_options(const void __user * data, unsigned long *where)
 }
 
 /*
+ * Allow users to disable (or enable) atime updates via a .config
+ * option or via the boot line, or via /proc/sys/fs/default_relatime:
+ */
+int default_relatime __read_mostly = CONFIG_DEFAULT_RELATIME_VAL;
+
+static int __init set_default_relatime(char *str)
+{
+	get_option(&str, &default_relatime);
+
+	printk(KERN_INFO "Mount all filesystems with"
+		"default relative atime updates: %s.\n",
+		default_relatime ? "enabled" : "disabled");
+
+	return 1;
+}
+__setup("default_relatime=", set_default_relatime);
+
+/*
  * Flags is a 32-bit value that allows up to 31 non-fs dependent flags to
  * be given to the mount() call (ie: read-only, no-dev, no-suid etc).
  *
@@ -1930,6 +1948,11 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	else if (default_relatime &&
+		 !(flags & (MS_NOATIME | MS_NODIRATIME | MS_NORELATIME))) {
+		mnt_flags |= MNT_RELATIME;
+		flags |= MS_RELATIME;
+	}
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0dcdd94..a4db010 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -135,6 +135,7 @@ extern int dir_notify_enable;
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
+#define MS_NORELATIME	(1<<24)	/* Disable relatie even if the default */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index cab2a85..71c7bc0 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -112,4 +112,7 @@ extern void mark_mounts_for_expiry(struct list_head *mounts);
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
+extern int default_relatime;
+extern int relatime_interval;
+
 #endif /* _LINUX_MOUNT_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9d048fa..872c3d3 100644
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
@@ -1334,6 +1335,22 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "default_relatime",
+		.data		= &default_relatime,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
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
