Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZF3Rqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZF3Rqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZF3Rqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:46:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37680 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZF3Rqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:46:38 -0400
Date: Tue, 30 Jun 2009 13:46:34 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v4)
Message-ID: <20090630174634.GD15612@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090630173836.GA15612@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630173836.GA15612@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

core_pattern: Allow core_pattern pipes to wait for user space to complete

One of the things that user space processes like to do is look at metadata for a
crashing process in their /proc/<pid> directory.  this is racy however, since
do_coredump in the kernel doesn't wait for the user space process to complete
before it reaps the crashing process.  This patch corrects that.  Allowing the
kernel to wait for the user space process to complete before cleaning up the
crashing process.  This is a bit tricky to do for a few reasons:

1) The user space process isn't our child, so we can't sys_wait4 on it
2) We need to close the pipe before waiting for the user process to complete,
since the user process may rely on an EOF condition

I've discussed several solutions with Oleg Nesterov off-list about this, and
this is the one we've come up with.  We basically add ourselves as an additional
reader (to prevent cleanup of the pipe), write the dump in ->core_dump(), then
iteratively remove ourselves as a writer (to create the EOF condition) and wake
up the user process.  note that we add ourselves as a reader before writing the
file.  this closes the race in the window between the time we write the dump and
the time we start checking for the user space process to be done with the pipe.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>


exec.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 93ab6eb..8dbf5a4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/kmod.h>
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
+#include <linux/pipe_fs_i.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1711,14 +1712,48 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
+static void wait_for_dump_helpers(struct file *file)
+{
+	struct inode *inode;
+	struct pipe_inode_info *pipe;
+ 
+	if (!file)
+		return;
+ 
+	inode = file->f_path.dentry->d_inode;
+ 
+	if (!S_ISFIFO(inode->i_mode))
+		return;
+ 
+	pipe = inode->i_pipe;
+ 
+	pipe_lock(pipe);
+	while (pipe->readers > 1) {
+		pipe->writers--;
+		wake_up_interruptible_sync(&pipe->wait);
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+		pipe_wait(pipe);
+		pipe->writers++;
+	}
+ 
+	/*
+	 * This reclaims the additional readers count we took in
+	 * do_coredump
+	 */
+	pipe->readers--;
+	pipe_unlock(pipe);
+ 
+}
+ 
+
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
-	struct inode * inode;
-	struct file * file;
+	struct inode * inode = NULL;
+	struct file * file = NULL;
 	const struct cred *old_cred;
 	struct cred *cred;
 	int retval = 0;
@@ -1729,6 +1764,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	int helper_argc = 0;
 	int dump_count = 0;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
+	struct pipe_inode_info *pipe;
 
 	audit_core_dumps(signr);
 
@@ -1824,6 +1860,17 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			       corename);
  			goto fail_dropcount;
  		}
+
+		/*
+		 * This lets us wait on a pipe after we close the writing
+		 * end.  The extra reader count prevents the pipe_inode_info
+		 * from getting freed.  This extra count is reclaimed in
+		 * wait_for_dump_helpers
+		 */
+		pipe = file->f_path.dentry->d_inode->i_pipe;
+		pipe_lock(pipe);
+		pipe->readers++;
+		pipe_unlock(pipe);
 	} else {
 		if (core_limit < binfmt->min_coredump)
 			goto fail_unlock;
@@ -1862,6 +1909,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		current->signal->group_exit_code |= 0x80;
 
 close_fail:
+	wait_for_dump_helpers(file);
 	filp_close(file, NULL);
 fail_dropcount:
 	if (dump_count)
