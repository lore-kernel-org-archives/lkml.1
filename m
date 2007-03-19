Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbXCSTaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbXCSTaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXCSTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:30:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12076 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbXCSTaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:30:05 -0400
Date: Mon, 19 Mar 2007 12:27:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@osdl.org>, "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysctl: vfs_cache_divisor
Message-Id: <20070319122740.286f602e.randy.dunlap@oracle.com>
In-Reply-To: <45A0041F.4060903@zytor.com>
References: <20061214223718.GA3816@elf.ucw.cz>
	<20061216094421.416a271e.randy.dunlap@oracle.com>
	<20061216095702.3e6f1d1f.akpm@osdl.org>
	<458434B0.4090506@oracle.com>
	<1166297434.26330.34.camel@localhost.localdomain>
	<20061219063413.GI24090@1wt.eu>
	<1166511171.26330.120.camel@localhost.localdomain>
	<20070106103331.48150aed.randy.dunlap@oracle.com>
	<459FF60D.7080901@zytor.com>
	<1168112266.2821.2.camel@entropy>
	<20070106121301.d07de0c9.akpm@osdl.org>
	<45A0041F.4060903@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Jan 2007 12:18:39 -0800 H. Peter Anvin wrote:

> Andrew Morton wrote:
> >>>
> >>> The most fundamental problem seems to be that I can't tell currnt Linux 
> >>> kernels that the dcache/icache is precious, and that it's way too eager 
> >>> to dump dcache and icache in favour of data blocks.  If I could do that, 
> >>> this problem would be much, much smaller.
> > 
> > Usually people complain about the exact opposite of this.
> 
> Yeah, but we constantly have all-filesystem sweeps, and being able to 
> retain those in memory would be a key to performance, *especially* from 
> the upload latency standpoint.
> 
> >> Isn't setting the vm.vfs_cache_pressure sysctl below 100 supposed to do
> >> this?
> 
> Just tweaked it (setting it to 1).  There really should be another 
> sysctl to set the denominator instead of hardcoding it at 100, since the 
> granularity of this sysctl at the very low end is really much too coarse.
> 
> I missed this sysctl since the name isn't really all that obvious.

Peter,

Were there any patches written after this?  If so, I missed them.
If not, does this patch help any?
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Add sysctl_vfs_cache_divisor (default value 100), which is used as the
divisor for sysctl_vfs_cache_pressure.  This allows a system admin to
make finer-grained pressure settings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/filesystems/proc.txt |    7 +++++++
 Documentation/sysctl/vm.txt        |    4 ++--
 fs/dcache.c                        |    6 +++++-
 fs/dquot.c                         |    4 +++-
 fs/inode.c                         |    3 ++-
 fs/mbcache.c                       |    3 ++-
 fs/nfs/dir.c                       |    4 +++-
 include/linux/dcache.h             |    1 +
 include/linux/sysctl.h             |    1 +
 kernel/sysctl.c                    |   10 ++++++++++
 10 files changed, 36 insertions(+), 7 deletions(-)

--- linux-2621-rc4.orig/fs/dcache.c
+++ linux-2621-rc4/fs/dcache.c
@@ -17,6 +17,7 @@
 #include <linux/syscalls.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/dcache.h>
 #include <linux/fs.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
@@ -37,6 +38,8 @@
 
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
+int sysctl_vfs_cache_divisor __read_mostly = 100;
+EXPORT_SYMBOL_GPL(sysctl_vfs_cache_divisor);
 
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 static __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
@@ -851,7 +854,8 @@ static int shrink_dcache_memory(int nr, 
 			return -1;
 		prune_dcache(nr, NULL);
 	}
-	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (dentry_stat.nr_unused / sysctl_vfs_cache_divisor)
+		* sysctl_vfs_cache_pressure;
 }
 
 /**
--- linux-2621-rc4.orig/fs/dquot.c
+++ linux-2621-rc4/fs/dquot.c
@@ -57,6 +57,7 @@
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/dcache.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/mm.h>
@@ -536,7 +537,8 @@ static int shrink_dqcache_memory(int nr,
 		prune_dqcache(nr);
 		spin_unlock(&dq_list_lock);
 	}
-	return (dqstats.free_dquots / 100) * sysctl_vfs_cache_pressure;
+	return (dqstats.free_dquots / sysctl_vfs_cache_divisor)
+		* sysctl_vfs_cache_pressure;
 }
 
 /*
--- linux-2621-rc4.orig/fs/inode.c
+++ linux-2621-rc4/fs/inode.c
@@ -461,7 +461,8 @@ static int shrink_icache_memory(int nr, 
 			return -1;
 		prune_icache(nr);
 	}
-	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
+	return (inodes_stat.nr_unused / sysctl_vfs_cache_divisor)
+		* sysctl_vfs_cache_pressure;
 }
 
 static void __wait_on_freeing_inode(struct inode *inode);
--- linux-2621-rc4.orig/fs/mbcache.c
+++ linux-2621-rc4/fs/mbcache.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 
 #include <linux/hash.h>
+#include <linux/dcache.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -226,7 +227,7 @@ mb_cache_shrink_fn(int nr_to_scan, gfp_t
 						   e_lru_list), gfp_mask);
 	}
 out:
-	return (count / 100) * sysctl_vfs_cache_pressure;
+	return (count / sysctl_vfs_cache_divisor) * sysctl_vfs_cache_pressure;
 }
 
 
--- linux-2621-rc4.orig/include/linux/dcache.h
+++ linux-2621-rc4/include/linux/dcache.h
@@ -355,6 +355,7 @@ extern struct vfsmount *__lookup_mnt(str
 extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
 
 extern int sysctl_vfs_cache_pressure;
+extern int sysctl_vfs_cache_divisor;
 
 #endif /* __KERNEL__ */
 
--- linux-2621-rc4.orig/include/linux/sysctl.h
+++ linux-2621-rc4/include/linux/sysctl.h
@@ -207,6 +207,7 @@ enum
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+	VM_VFS_CACHE_DIVISOR=36, /* dcache/icache reclaim pressure divisor, def. 100 */
 
 	/* s390 vm cmm sysctls */
 	VM_CMM_PAGES=1111,
--- linux-2621-rc4.orig/fs/nfs/dir.c
+++ linux-2621-rc4/fs/nfs/dir.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/dcache.h>
 #include <linux/errno.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
@@ -1773,7 +1774,8 @@ remove_lru_entry:
 		list_del(&cache->lru);
 		nfs_access_free_entry(cache);
 	}
-	return (atomic_long_read(&nfs_access_nr_entries) / 100) * sysctl_vfs_cache_pressure;
+	return (atomic_long_read(&nfs_access_nr_entries) /
+		sysctl_vfs_cache_divisor) * sysctl_vfs_cache_pressure;
 }
 
 static void __nfs_access_zap_cache(struct inode *inode)
--- linux-2621-rc4.orig/kernel/sysctl.c
+++ linux-2621-rc4/kernel/sysctl.c
@@ -800,6 +800,16 @@ static ctl_table vm_table[] = {
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
+	{
+		.ctl_name	= VM_VFS_CACHE_DIVISOR,
+		.procname	= "vfs_cache_divisor",
+		.data		= &sysctl_vfs_cache_divisor,
+		.maxlen		= sizeof(sysctl_vfs_cache_divisor),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
 		.ctl_name	= VM_LEGACY_VA_LAYOUT,
--- linux-2621-rc4.orig/Documentation/filesystems/proc.txt
+++ linux-2621-rc4/Documentation/filesystems/proc.txt
@@ -1156,6 +1156,13 @@ swapcache reclaim.  Decreasing vfs_cache
 to retain dentry and inode caches.  Increasing vfs_cache_pressure beyond 100
 causes the kernel to prefer to reclaim dentries and inodes.
 
+vfs_cache_divisor
+-----------------
+The default vfs_cache_divisor value is 100 (like percent).  However, for
+extremely large systems where a value of vfs_cache_pressure of less than
+1 percent is desirable, using a larger vfs_cache_divisor enables this wanted
+characteristic.
+
 dirty_background_ratio
 ----------------------
 
--- linux-2621-rc4.orig/Documentation/sysctl/vm.txt
+++ linux-2621-rc4/Documentation/sysctl/vm.txt
@@ -35,8 +35,8 @@ Currently, these files are in /proc/sys/
 ==============================================================
 
 dirty_ratio, dirty_background_ratio, dirty_expire_centisecs,
-dirty_writeback_centisecs, vfs_cache_pressure, laptop_mode,
-block_dump, swap_token_timeout, drop-caches:
+dirty_writeback_centisecs, vfs_cache_pressure, vfs_cache_divisor,
+laptop_mode, block_dump, swap_token_timeout, drop-caches:
 
 See Documentation/filesystems/proc.txt
 
