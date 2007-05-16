Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbXEPSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbXEPSbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXEPSbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:31:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:32383 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbXEPSbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tZStgsdW5Ww22cCTG6snr8Abt4x3ivNZkrUgXiZ23y4Zpu7PmUMx4wBQzcZVX0efaWIh89uFO7/h2fgGVW98vBu65gNT9h5QW251jtWLK0bsFOp18tT71aAQpy0itEEgJh1RrAjlpq4zXbheEoyrQim6zNHmDHNGgw1O3SYMrRo=
Message-ID: <464B4DE4.9060100@gmail.com>
Date: Wed, 16 May 2007 20:31:00 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Greg KH <greg@kroah.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [PATCH -stable] sysfs: disable reclamation by default
References: <464A4F56.6080108@tequila.co.jp>	<20070515185350.2e77bf21.akpm@linux-foundation.org>	<464AE56F.3040101@gmail.com>	<20070516082935.fe112ab5.akpm@linux-foundation.org>	<464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org>
In-Reply-To: <20070516091346.3c76cb46.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sd->s_dentry updates made by dentry/inode reclamation are racy and can
lead to BUG() or oops.  This is already fixed in -mm and the fix is
scheduled to be merged into upstream for 2.6.23 but the fix
reimplements sysfs dentry dropping and is too risky for -stable
kernels.

This is an interim solution for -stable kernels.  sysfs reclamation is
disabled by default and can be enabled by using sysfs.enable_reclaim
kernel parameter.  Note that dentries are still created on demand, so
attribute and symlinks nodes aren't allocated on creation.  They're
allocated on first lookup and deallocated when the sysfs node is
removed.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---

Okay, I wasn't sure about the backport, so this is what I've come up
with.  It's ugly but, as Chuck pointed out, anything is better than
oopsing.

Clemens, can you please test this one too?

If anyone has any better idea, feel free to override this one.

Thanks.

 Documentation/kernel-parameters.txt |    8 ++++++++
 fs/sysfs/Makefile                   |    3 ++-
 fs/sysfs/dir.c                      |   11 +++++++++++
 fs/sysfs/inode.c                    |    3 +++
 fs/sysfs/sysfs.h                    |    1 +
 5 files changed, 25 insertions(+), 1 deletion(-)

Index: tree0/fs/sysfs/dir.c
===================================================================
--- tree0.orig/fs/sysfs/dir.c
+++ tree0/fs/sysfs/dir.c
@@ -14,6 +14,13 @@
 
 DECLARE_RWSEM(sysfs_rename_sem);
 
+/*
+ * sysfs dentry/inode reclaming has race conditions around
+ * sd->s_dentry.  Disable it by default.
+ */
+int sysfs_enable_reclaim;
+module_param_named(enable_reclaim, sysfs_enable_reclaim, bool, 0444);
+
 static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
@@ -289,6 +296,10 @@ static struct dentry * sysfs_lookup(stru
 				err = sysfs_attach_link(sd, dentry);
 			else
 				err = sysfs_attach_attr(sd, dentry);
+
+			if (err == 0 && !sysfs_enable_reclaim)
+				dget(dentry);
+
 			break;
 		}
 	}
Index: tree0/fs/sysfs/inode.c
===================================================================
--- tree0.orig/fs/sysfs/inode.c
+++ tree0/fs/sysfs/inode.c
@@ -266,6 +266,9 @@ void sysfs_drop_dentry(struct sysfs_dire
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 		}
+
+		if (!sysfs_enable_reclaim)
+			dput(dentry);
 	}
 }
 
Index: tree0/fs/sysfs/Makefile
===================================================================
--- tree0.orig/fs/sysfs/Makefile
+++ tree0/fs/sysfs/Makefile
@@ -2,5 +2,6 @@
 # Makefile for the sysfs virtual filesystem
 #
 
-obj-y		:= inode.o file.o dir.o symlink.o mount.o bin.o \
+obj-y		:= sysfs.o
+sysfs-objs	:= inode.o file.o dir.o symlink.o mount.o bin.o \
 		   group.o
Index: tree0/Documentation/kernel-parameters.txt
===================================================================
--- tree0.orig/Documentation/kernel-parameters.txt
+++ tree0/Documentation/kernel-parameters.txt
@@ -1721,6 +1721,14 @@ and is between 256 and 4096 characters. 
 	sym53c416=	[HW,SCSI]
 			See header of drivers/scsi/sym53c416.c.
 
+	sysfs.enable_reclaim
+			Enable dentry and inode reclamation for
+			attribute and symlink nodes.  This is buggy
+			and can cause oops or trigger BUG.  Do not
+			enable unless you know what you're doing.
+			This kernel parameter will be removed after
+			reclamation is fixed.
+
 	sysrq_always_enabled
 			[KNL]
 			Ignore sysrq setting - this boot parameter will
Index: tree0/fs/sysfs/sysfs.h
===================================================================
--- tree0.orig/fs/sysfs/sysfs.h
+++ tree0/fs/sysfs/sysfs.h
@@ -12,6 +12,7 @@ struct sysfs_dirent {
 
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
+extern int sysfs_enable_reclaim;
 
 extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
