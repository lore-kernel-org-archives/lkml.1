Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZGTQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZGTQcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZGTQcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:32:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40348 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZGTQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:32:12 -0400
Date: Mon, 20 Jul 2009 12:32:04 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, earl_chew@agilent.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, oleg@redhat.com
Subject: Re: [PATCH 3/3] exec: Allow do_coredump to wait for user space
	pipe readers to complete (v9)
Message-ID: <20090720163204.GC9060@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090703104447.GA19371@hmsreliant.think-freely.org> <20090720154938.GA8563@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720154938.GA8563@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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
this is the one we've come up with. We add ourselves as a pipe reader (to
prevent premature cleanup of the pipe_inode_info), and remove ourselves as a
writer (to provide an EOF condition to the writer in user space), then we
iterate until the user space process exits (which we detect by pipe->readers ==
1, hence the > 1 check in the loop).  When we exit the loop, we restore the
proper reader/writer values, then we return and let filp_close in do_coredump
clean up the pipe data properly.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>


 exec.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 5f70d7e..510b455 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/kmod.h>
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
+#include <linux/pipe_fs_i.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1718,6 +1719,29 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
+static void wait_for_dump_helpers(struct file *file)
+{
+	struct pipe_inode_info *pipe;
+ 
+	pipe = file->f_path.dentry->d_inode->i_pipe;
+ 
+	pipe_lock(pipe);
+	pipe->readers++;
+	pipe->writers--;
+
+	while ((pipe->readers > 1) && (!signal_pending(current))) {
+		wake_up_interruptible_sync(&pipe->wait);
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
+		pipe_wait(pipe);
+	}
+ 
+	pipe->readers--;
+	pipe->writers++;
+	pipe_unlock(pipe);
+ 
+}
+ 
+
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
@@ -1873,6 +1897,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
 close_fail:
+	if (ispipe && core_pipe_limit)
+		wait_for_dump_helpers(file);
 	filp_close(file, NULL);
 fail_dropcount:
 	if (dump_count)
