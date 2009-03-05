Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZCEQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZCEQmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbZCEQjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47149 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbZCEQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:34 -0500
Subject: [RFC][PATCH 06/11] add checkpoint_file_generic() to /proc
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:06 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163906.756FAD1A@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


/proc gets opened a *lot* including during some things that
ld.so does (according to Serge).  If we want *anything* to
be checkpointable, we need to handle at least a few things
in /proc.

My approach here was we should be conservative.  We should
only mark things that we basically already know can change
at any time, so a process would not be confused if they
changed.

Things like /proc/kcore are a bit trickier and should be
left alone for now.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/base.c    |    9 +++++++++
 linux-2.6.git-dave/fs/proc/meminfo.c |    1 +
 linux-2.6.git-dave/fs/proc/stat.c    |    1 +
 linux-2.6.git-dave/mm/vmstat.c       |    4 ++++
 4 files changed, 15 insertions(+)

diff -puN fs/proc/base.c~add-stupid-checkpoint-to-proc-0 fs/proc/base.c
--- linux-2.6.git/fs/proc/base.c~add-stupid-checkpoint-to-proc-0	2009-03-05 08:37:02.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/base.c	2009-03-05 08:37:02.000000000 -0800
@@ -690,6 +690,7 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= mounts_release,
 	.poll		= mounts_poll,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static int mountinfo_open(struct inode *inode, struct file *file)
@@ -703,6 +704,7 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= mounts_release,
 	.poll		= mounts_poll,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static int mountstats_open(struct inode *inode, struct file *file)
@@ -715,6 +717,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= mounts_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 #define PROC_BLOCK_SIZE	(3*1024)		/* 4K page size but our output routines use some slack for overruns */
@@ -751,6 +754,7 @@ out_no_task:
 
 static const struct file_operations proc_info_file_operations = {
 	.read		= proc_info_read,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static int proc_single_show(struct seq_file *m, void *v)
@@ -790,6 +794,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static int mem_open(struct inode* inode, struct file* file)
@@ -1008,6 +1013,7 @@ out_no_task:
 
 static const struct file_operations proc_environ_operations = {
 	.read		= environ_read,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static ssize_t oom_adjust_read(struct file *file, char __user *buf,
@@ -1063,6 +1069,7 @@ static ssize_t oom_adjust_write(struct f
 static const struct file_operations proc_oom_adjust_operations = {
 	.read		= oom_adjust_read,
 	.write		= oom_adjust_write,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -1130,6 +1137,7 @@ out_free_page:
 static const struct file_operations proc_loginuid_operations = {
 	.read		= proc_loginuid_read,
 	.write		= proc_loginuid_write,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
@@ -1150,6 +1158,7 @@ static ssize_t proc_sessionid_read(struc
 
 static const struct file_operations proc_sessionid_operations = {
 	.read		= proc_sessionid_read,
+	.checkpoint	= generic_file_checkpoint,
 };
 #endif
 
diff -puN fs/proc/meminfo.c~add-stupid-checkpoint-to-proc-0 fs/proc/meminfo.c
--- linux-2.6.git/fs/proc/meminfo.c~add-stupid-checkpoint-to-proc-0	2009-03-05 08:37:02.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/meminfo.c	2009-03-05 08:37:02.000000000 -0800
@@ -164,6 +164,7 @@ static const struct file_operations memi
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static int __init proc_meminfo_init(void)
diff -puN fs/proc/stat.c~add-stupid-checkpoint-to-proc-0 fs/proc/stat.c
--- linux-2.6.git/fs/proc/stat.c~add-stupid-checkpoint-to-proc-0	2009-03-05 08:37:02.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/stat.c	2009-03-05 08:37:02.000000000 -0800
@@ -142,6 +142,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static int __init proc_stat_init(void)
diff -puN mm/vmstat.c~add-stupid-checkpoint-to-proc-0 mm/vmstat.c
--- linux-2.6.git/mm/vmstat.c~add-stupid-checkpoint-to-proc-0	2009-03-05 08:37:02.000000000 -0800
+++ linux-2.6.git-dave/mm/vmstat.c	2009-03-05 08:37:02.000000000 -0800
@@ -598,6 +598,7 @@ static const struct file_operations frag
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static const struct seq_operations pagetypeinfo_op = {
@@ -617,6 +618,7 @@ static const struct file_operations page
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 #ifdef CONFIG_ZONE_DMA
@@ -813,6 +815,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 static void *vmstat_start(struct seq_file *m, loff_t *pos)
@@ -887,6 +890,7 @@ static const struct file_operations proc
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.checkpoint	= generic_file_checkpoint,
 };
 #endif /* CONFIG_PROC_FS */
 
_
