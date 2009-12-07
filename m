Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbZLGC3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbZLGC3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 21:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbZLGC3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 21:29:54 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36173 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933828AbZLGC3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 21:29:53 -0500
Message-ID: <4B1C6856.4060207@ct.jp.nec.com>
Date: Mon, 07 Dec 2009 11:28:38 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp,
       swhiteho@redhat.com, tytso@mit.edu
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm
 tree
References: <200912032240.nB3Mevae027408@imap1.linux-foundation.org> <20091204021444.GA8392@x200> <4B1888CE.8000406@ct.jp.nec.com> <20091204051729.GA3927@x200>
In-Reply-To: <20091204051729.GA3927@x200>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Fri, Dec 04, 2009 at 12:58:06PM +0900, Hiroshi Shimamoto wrote:
>> Alexey Dobriyan wrote:
>>> On Thu, Dec 03, 2009 at 02:40:57PM -0800, akpm@linux-foundation.org wrote:
>>>> --- a/include/linux/sched.h~task_struct-make-journal_info-conditional
>>>> +++ a/include/linux/sched.h
>>>> @@ -1452,8 +1452,10 @@ struct task_struct {
>>>>  	gfp_t lockdep_reclaim_gfp;
>>>>  #endif
>>>>  
>>>> +#ifdef CONFIG_FS_JOURNAL_INFO
>>>>  /* journalling filesystem info */
>>>>  	void *journal_info;
>>>> +#endif
>>> This will prevent using e.g. ext3 on CONFIG_EXT3_FS=n kernels.
>> I'm sorry, I'm not sure what you're mentioning.
> 
> With this patch admin must decide in advance if he will ever use ext3.
> EXT3_FS=n kernels won't be able to get ext3 support without reboot
> even as module, because task_struct will be different.

I see, you want to keep this field for future use even if EXT3_FS=n.
I think, however, there might be a need to remove this because the user
never enable any journaling filesystem.

> 
> Which is a regression compared to current state.

I understand it's a regression, so how about make this option Y by
default?

====
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH v2] task_struct: make journal_info conditional

journal_info in task_struct is used in journaling file system only.
So introduce CONFIG_FS_JOURNAL_INFO and make it conditional.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
CC: Andrew Morton <akpm@linux-foundation.org>
---
v1->v2: Make FS_JOURNAL_INFO Y by default, and add help document.

 fs/Kconfig                |   12 ++++++++++++
 fs/btrfs/Kconfig          |    1 +
 fs/ext4/Kconfig           |    1 +
 fs/gfs2/Kconfig           |    1 +
 fs/jbd/Kconfig            |    1 +
 fs/jbd2/Kconfig           |    1 +
 fs/nilfs2/Kconfig         |    1 +
 fs/reiserfs/Kconfig       |    1 +
 include/linux/init_task.h |    8 +++++++-
 include/linux/sched.h     |    2 ++
 10 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 2aa5663..a684c1b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -6,6 +6,18 @@ menu "File systems"
 
 if BLOCK
 
+config FS_JOURNAL_INFO
+	bool "Include FS Journal Info in task struct"
+	default y
+	help
+	  Include Journal Information in task struct for journaling filesystem.
+	  It used in Btrfs, EXT3, EXT4, GFS2, NILFS2 and Reiserfs.
+	  If you say N, remove the field for journal info from task struct, it
+	  reduces task struct size but disables to support the above journaling
+	  filesystems.
+
+	  Say Y if unsure.
+
 source "fs/ext2/Kconfig"
 source "fs/ext3/Kconfig"
 source "fs/ext4/Kconfig"
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 7bb3c02..402afe0 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -4,6 +4,7 @@ config BTRFS_FS
 	select LIBCRC32C
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
+	select FS_JOURNAL_INFO
 	help
 	  Btrfs is a new filesystem with extents, writable snapshotting,
 	  support for multiple devices and many more features.
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9f2d45d..464b486 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -2,6 +2,7 @@ config EXT4_FS
 	tristate "The Extended 4 (ext4) filesystem"
 	select JBD2
 	select CRC16
+	select FS_JOURNAL_INFO
 	help
 	  This is the next generation of the ext3 filesystem.
 
diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 4dcddf8..b192c66 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -10,6 +10,7 @@ config GFS2_FS
 	select SLOW_WORK
 	select QUOTA
 	select QUOTACTL
+	select FS_JOURNAL_INFO
 	help
 	  A cluster filesystem.
 
diff --git a/fs/jbd/Kconfig b/fs/jbd/Kconfig
index 4e28bee..a840898 100644
--- a/fs/jbd/Kconfig
+++ b/fs/jbd/Kconfig
@@ -1,5 +1,6 @@
 config JBD
 	tristate
+	select FS_JOURNAL_INFO
 	help
 	  This is a generic journalling layer for block devices.  It is
 	  currently used by the ext3 file system, but it could also be
diff --git a/fs/jbd2/Kconfig b/fs/jbd2/Kconfig
index f32f346..0f7d1ce 100644
--- a/fs/jbd2/Kconfig
+++ b/fs/jbd2/Kconfig
@@ -1,6 +1,7 @@
 config JBD2
 	tristate
 	select CRC32
+	select FS_JOURNAL_INFO
 	help
 	  This is a generic journaling layer for block devices that support
 	  both 32-bit and 64-bit block numbers.  It is currently used by
diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 251da07..1225af7 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -2,6 +2,7 @@ config NILFS2_FS
 	tristate "NILFS2 file system support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	select CRC32
+	select FS_JOURNAL_INFO
 	help
 	  NILFS2 is a log-structured file system (LFS) supporting continuous
 	  snapshotting.  In addition to versioning capability of the entire
diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
index 513f431..ac7cd75 100644
--- a/fs/reiserfs/Kconfig
+++ b/fs/reiserfs/Kconfig
@@ -1,6 +1,7 @@
 config REISERFS_FS
 	tristate "Reiserfs support"
 	select CRC32
+	select FS_JOURNAL_INFO
 	help
 	  Stores not just filenames but the files themselves in a balanced
 	  tree.  Uses journalling.
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 8d10aa7..8ed0abf 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -111,6 +111,12 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#ifdef CONFIG_FS_JOURNAL_INFO
+#define INIT_JOURNAL_INFO	.journal_info = NULL,
+#else
+#define INIT_JOURNAL_INFO
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -162,7 +168,6 @@ extern struct cred init_cred;
 		.signal = {{0}}},					\
 	.blocked	= {{0}},					\
 	.alloc_lock	= __SPIN_LOCK_UNLOCKED(tsk.alloc_lock),		\
-	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= __SPIN_LOCK_UNLOCKED(tsk.pi_lock),		\
@@ -173,6 +178,7 @@ extern struct cred init_cred;
 		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
 	},								\
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
+	INIT_JOURNAL_INFO						\
 	INIT_IDS							\
 	INIT_PERF_EVENTS(tsk)						\
 	INIT_TRACE_IRQFLAGS						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c13c43e..92b1325 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1452,8 +1452,10 @@ struct task_struct {
 	gfp_t lockdep_reclaim_gfp;
 #endif
 
+#ifdef CONFIG_FS_JOURNAL_INFO
 /* journalling filesystem info */
 	void *journal_info;
+#endif
 
 /* stacked block device info */
 	struct bio *bio_list, **bio_tail;
-- 
1.6.5.5

