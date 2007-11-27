Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbXK0HLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbXK0HLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXK0HLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:11:11 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:50702 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXK0HLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:11:09 -0500
Message-ID: <474BC29F.4060706@cosmosbay.com>
Date: Tue, 27 Nov 2007 08:09:19 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] get rid of NR_OPEN and introduce a sysctl_nr_open
References: <200711200023.lAK0NtEe004292@imap1.linux-foundation.org>	<20071120004832.393cc5a8@the-village.bc.nu>	<474291E7.5060700@cosmosbay.com>	<20071120001411.4db1eb04.akpm@linux-foundation.org>	<474420EE.4060603@cosmosbay.com> <20071126201717.450e44eb.akpm@linux-foundation.org>
In-Reply-To: <20071126201717.450e44eb.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------060604000204050500070601"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 27 Nov 2007 08:09:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060604000204050500070601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

As changing NR_OPEN from 1024*1024 to 16*1024*1024 was considered a litle
bit dangerous, just let it default to 1024*1024 but adds a new sysctl
to let sysadmins change this value.

Thank you

[PATCH] get rid of NR_OPEN and introduce a sysctl_nr_open

NR_OPEN (historically set to 1024*1024) actually forbids processes to open 
more than 1024*1024 handles.

Unfortunatly some production servers hit the not so 'ridiculously high value' 
of 1024*1024 file descriptors per process.

Changing NR_OPEN is not considered safe because of vmalloc space potential 
exhaust.

This patch introduces a new sysctl (/proc/sys/fs/nr_open) wich defaults to 
1024*1024, so that admins can decide to change this limit if their workload 
needs it.


Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

  Documentation/filesystems/proc.txt |    8 ++++++++
  Documentation/sysctl/fs.txt        |   10 ++++++++++
  fs/file.c                          |    8 +++++---
  include/linux/fs.h                 |    2 +-
  kernel/sys.c                       |    2 +-
  kernel/sysctl.c                    |    8 ++++++++
  6 files changed, 33 insertions(+), 5 deletions(-)

--------------060604000204050500070601
Content-Type: text/plain;
 name="nr_open.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nr_open.patch"

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index dec9945..9b390d7 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -989,6 +989,14 @@ nr_inodes
 Denotes the  number  of  inodes the system has allocated. This number will
 grow and shrink dynamically.
 
+nr_open
+-------
+
+Denotes the maximum number of file-handles a process can
+allocate. Default value is 1024*1024 (1048576) which should be
+enough for most machines. Actual limit depends on RLIMIT_NOFILE
+resource limit.
+
 nr_free_inodes
 --------------
 
diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index aa986a3..f992543 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -23,6 +23,7 @@ Currently, these files are in /proc/sys/fs:
 - inode-max
 - inode-nr
 - inode-state
+- nr_open
 - overflowuid
 - overflowgid
 - suid_dumpable
@@ -91,6 +92,15 @@ usage of file handles and you don't need to increase the maximum.
 
 ==============================================================
 
+nr_open:
+
+This denotes the maximum number of file-handles a process can
+allocate. Default value is 1024*1024 (1048576) which should be
+enough for most machines. Actual limit depends on RLIMIT_NOFILE
+resource limit.
+
+==============================================================
+
 inode-max, inode-nr & inode-state:
 
 As with file handles, the kernel allocates the inode structures
diff --git a/fs/file.c b/fs/file.c
index c5575de..5110acb 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -24,6 +24,8 @@ struct fdtable_defer {
 	struct fdtable *next;
 };
 
+int sysctl_nr_open __read_mostly = 1024*1024;
+
 /*
  * We use this list to defer free fdtables that have vmalloced
  * sets/arrays. By keeping a per-cpu list, we avoid having to embed
@@ -147,8 +149,8 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	nr /= (1024 / sizeof(struct file *));
 	nr = roundup_pow_of_two(nr + 1);
 	nr *= (1024 / sizeof(struct file *));
-	if (nr > NR_OPEN)
-		nr = NR_OPEN;
+	if (nr > sysctl_nr_open)
+		nr = sysctl_nr_open;
 
 	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL);
 	if (!fdt)
@@ -233,7 +235,7 @@ int expand_files(struct files_struct *files, int nr)
 	if (nr < fdt->max_fds)
 		return 0;
 	/* Can we expand? */
-	if (nr >= NR_OPEN)
+	if (nr >= sysctl_nr_open)
 		return -EMFILE;
 
 	/* All good, so we try */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..1cda287 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -21,7 +21,7 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define NR_OPEN (1024*1024)	/* Absolute upper limit on fd num */
+extern int sysctl_nr_open;
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
diff --git a/kernel/sys.c b/kernel/sys.c
index d1fe71e..99c6ce1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1472,7 +1472,7 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > NR_OPEN)
+	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
 	retval = security_task_setrlimit(resource, &new_rlim);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0deed82..de22f7b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1127,6 +1127,14 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_open",
+		.data		= &sysctl_nr_open,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= FS_DENTRY,
 		.procname	= "dentry-state",
 		.data		= &dentry_stat,

--------------060604000204050500070601--
