Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYA0M1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYA0M1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbYA0M0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:26:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:24944 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbYA0M0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=gxvMXBdDPCzNTo5RwwA695JwNcNPKQQ0GaYTewJZUpR7LtdughtXsj+SEyMvnpgCtc8CQKluGEJQgKy/754rE5hBE9ZahZWPve2mrh+6LPtjUdJUtC6/fxTkgE4bNLIVIM9i5tCoG671k6RtuC9THJUCTAT8i1JVI2MGzRNggd0=
Date: Sun, 27 Jan 2008 15:26:34 +0300
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/2] Race-free kernel.core_pattern
Message-ID: <20080127122634.GA3497@martell.zuzino.mipt.ru>
References: <20080122202727.GB1975@martell.zuzino.mipt.ru> <20080123105140.3406e25b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123105140.3406e25b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 10:51:40AM +0000, Alan Cox wrote:
> On Tue, 22 Jan 2008 23:27:27 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > /proc/sys part of sysctl code runs without BKL held, so BKL during
> > sysctl(2) is useless. Remove misleading comment and "protection" around
> > coredumping code -- kernel.core_pattern can be written without BKL.
> > 
> > do_sysctl() and lookup in /proc/sys use identical iterators, so any locking
> > bug BKL supposedly fixed in sysctl(2) code we should have in /proc/sys
> > code anyway.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> NAK
> 
> The core dump locking is now totally unprotected rather than slightly
> dubious. This patch needs to go in together with a parallel patch to
> actually lock properly. You've made a bug worse not fixed it.

Techically, yes.

> There are cases that updating the corepath name and dumping a core at the
> same moment can result in the wrong thing being exec()'d or a file being
> opened which is a mix of the old and new name and could go anywhere.

Yup, that's the bug.

Below is companion patch to be applied after BKL removal which fixes it:



[PATCH 2/2] Race-free kernel.core_pattern

Alan correctly notices that playing with kernel.core_pattern while coredumping
is in flight can lead to unpredictable name of coredump files or wrong piped to
wrong executable. Fix that by taking mutex around formatting corename and
changing core_pattern via both /proc/sys/kernel/core_pattern and
{CTL_KERN, KERN_CORE_PATTERN}.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/exec.c                |   32 ++++++++++++++++++++++++++++++++
 include/linux/coredump.h |   31 +++++++++++++++++++++++++++++++
 kernel/sysctl.c          |    7 +++----
 3 files changed, 66 insertions(+), 4 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -41,6 +41,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
 #include <linux/namei.h>
+#include <linux/coredump.h>
+#include <linux/sysctl.h>
 #include <linux/proc_fs.h>
 #include <linux/ptrace.h>
 #include <linux/mount.h>
@@ -61,6 +63,7 @@
 
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
+DEFINE_MUTEX(core_pattern_mutex);
 int suid_dumpable = 0;
 
 /* The maximal length of core_pattern is also specified in sysctl.c */
@@ -1585,6 +1588,33 @@ done:
 	return mm->core_waiters;
 }
 
+#ifdef CONFIG_PROC_SYSCTL
+int proc_core_pattern(struct ctl_table *table, int write, struct file *file,
+		      void __user *buf, size_t *lenp, loff_t *ppos)
+{
+	int rv;
+
+	mutex_lock(&core_pattern_mutex);
+	rv = proc_dostring(table, write, file, buf, lenp, ppos);
+	mutex_unlock(&core_pattern_mutex);
+	return rv;
+}
+#endif
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+int sysctl_core_pattern(struct ctl_table *table, int __user *name, int nlen,
+			void __user *oldval, size_t __user *oldlenp,
+			void __user *newval, size_t newlen)
+{
+	int rv;
+
+	mutex_lock(&core_pattern_mutex);
+	rv = sysctl_string(table, name, nlen, oldval, oldlenp, newval, newlen);
+	mutex_unlock(&core_pattern_mutex);
+	return rv;
+}
+#endif
+
 static int coredump_wait(int exit_code)
 {
 	struct task_struct *tsk = current;
@@ -1719,7 +1749,9 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
+	mutex_lock(&core_pattern_mutex);
 	ispipe = format_corename(corename, core_pattern, signr);
+	mutex_unlock(&core_pattern_mutex);
 	/*
 	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
 	 * to a pipe.  Since we're not writing directly to the filesystem
new file mode 100644
--- /dev/null
+++ b/include/linux/coredump.h
@@ -0,0 +1,31 @@
+#ifndef __INCLUDE_LINUX_COREDUMP_H
+#define __INCLUDE_LINUX_COREDUMP_H
+
+#include <linux/compiler.h>
+#include <linux/mutex.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+struct ctl_table;
+struct file;
+
+extern char core_pattern[];
+extern int core_uses_pid;
+extern struct mutex core_pattern_mutex;
+
+#ifdef CONFIG_PROC_SYSCTL
+int proc_core_pattern(struct ctl_table *ctl, int write, struct file *file,
+		      void __user *buffer, size_t *lenp, loff_t *ppos);
+#else
+#define proc_core_pattern NULL
+#endif
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+int sysctl_core_pattern(struct ctl_table *table, int __user *name, int nlen,
+			void __user *oldval, size_t __user *oldlenp,
+			void __user *newval, size_t newlen);
+#else
+#define sysctl_core_pattern NULL
+#endif
+
+#endif
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -26,6 +26,7 @@
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
+#include <linux/coredump.h>
 #include <linux/utsname.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -66,9 +67,7 @@ extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int max_threads;
-extern int core_uses_pid;
 extern int suid_dumpable;
-extern char core_pattern[];
 extern int pid_max;
 extern int min_free_kbytes;
 extern int printk_ratelimit_jiffies;
@@ -369,8 +368,8 @@ static struct ctl_table kern_table[] = {
 		.data		= core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
+		.proc_handler	= proc_core_pattern,
+		.strategy	= sysctl_core_pattern,
 	},
 #ifdef CONFIG_PROC_SYSCTL
 	{
