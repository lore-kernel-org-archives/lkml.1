Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXH1Wkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXH1Wkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 18:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXH1Wk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 18:40:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44794 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXH1WkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 18:40:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
cc: <linux-kernel@vger.kernel.org>
Date: Tue, 28 Aug 2007 16:40:15 -0600
Message-ID: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


After adding checking to register_sysctl_table and finding a whole new
set of bugs.  Missed by countless code reviews and testers I have
finally lost patience with the binary sysctl interface.

The binary sysctl interface has been sort of deprecated for years and
finding a user space program that uses the syscall is more difficult
then finding a needle in a haystack.  Problems continue to crop up,
with the in kernel implementation.  So since supporting something that
no one uses is silly, deprecate sys_sysctl with a sufficient grace
period and notice that the handful of user space applications that
care can be fixed or replaced.

The /proc/sys sysctl interface that people use will continue to be
supported indefinitely.

This patch moves the tested warning about sysctls from the path where
sys_sysctl to a separate path called from both implementations of
sys_sysctl, and it adds a proper entry into
Documentation/feature-removal-schedule.

Allowing us to revisit this in a couple years time and actually kill
sys_sysctl.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 Documentation/feature-removal-schedule.txt |   35 ++++++++++++++++
 kernel/sysctl.c                            |   62 +++++++++++++++++----------
 2 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a43d287..4d3097e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -290,3 +290,38 @@ Why:	All mthca hardware also supports MSI-X, which provides
 Who:	Roland Dreier <rolandd@cisco.com>
 
 ---------------------------
+
+What:	sys_sysctl
+When:	September 2010
+Option: CONFIG_SYSCTL_SYSCALL
+Why:	The same information is available in a more convenient from
+	/proc/sys, and none of the sysctl variables appear to be
+	important performance wise.
+
+	Binary sysctls are a long standing source of subtle kernel
+	bugs and security issues.
+
+	When I looked several months ago all I could find after
+	searching several distributions were 5 user space programs and
+	glibc (which falls back to /proc/sys) using this syscall.
+
+	The man page for sysctl(2) documents it as unusable for user
+	space programs.
+
+	sysctl(2) is not generally ABI compatible to a 32bit user
+	space application on a 64bit and a 32bit kernel.
+
+	For the last several months the policy has been no new binary
+	sysctls and no one has put forward an argument to use them.
+
+	Binary sysctls issues seem to keep happening appearing so
+	properly deprecating them (with a warning to user space) and a
+	2 year grace warning period will mean eventually we can kill
+	them and end the pain.
+
+	In the mean time individual binary sysctls can be dealt with
+	in a piecewise fashion.
+
+Who:	Eric Biederman <ebiederm@xmission.com>
+
+---------------------------
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6d01497..792e6fe 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1275,6 +1275,33 @@ struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev)
 	return NULL;
 }
 
+static int deprecated_sysctl_warning(struct __sysctl_args *args)
+{
+	static int msg_count;
+	int name[CTL_MAXNAME];
+	int i;
+
+	/* Read in the sysctl name for better debug message logging */
+	for (i = 0; i < args->nlen; i++)
+		if (get_user(name[i], args->name + i))
+			return -EFAULT;
+
+	/* Ignore accesses to kernel.version */
+	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
+		return 0;
+
+	if (msg_count < 5) {
+		msg_count++;
+		printk(KERN_INFO
+			"warning: process `%s' used the deprecated sysctl "
+			"system call with ", current->comm);
+		for (i = 0; i < args->nlen; i++)
+			printk("%d.", name[i]);
+		printk("\n");
+	}
+	return 0;
+}
+
 #ifdef CONFIG_SYSCTL_SYSCALL
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
@@ -1310,10 +1337,15 @@ asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
 		return -EFAULT;
 
+	error = deprecated_sysctl_warning(&tmp);
+	if (error)
+		goto out;
+
 	lock_kernel();
 	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
 			  tmp.newval, tmp.newlen);
 	unlock_kernel();
+out:
 	return error;
 }
 #endif /* CONFIG_SYSCTL_SYSCALL */
@@ -2503,35 +2535,19 @@ int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
 
 asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
 {
-	static int msg_count;
 	struct __sysctl_args tmp;
-	int name[CTL_MAXNAME];
-	int i;
+	int error;
 
-	/* Read in the sysctl name for better debug message logging */
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
 		return -EFAULT;
-	if (tmp.nlen <= 0 || tmp.nlen >= CTL_MAXNAME)
-		return -ENOTDIR;
-	for (i = 0; i < tmp.nlen; i++)
-		if (get_user(name[i], tmp.name + i))
-			return -EFAULT;
 
-	/* Ignore accesses to kernel.version */
-	if ((tmp.nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
-		goto out;
+	error = deprecated_sysctl_warning(&tmp);
 
-	if (msg_count < 5) {
-		msg_count++;
-		printk(KERN_INFO
-			"warning: process `%s' used the removed sysctl "
-			"system call with ", current->comm);
-		for (i = 0; i < tmp.nlen; i++)
-			printk("%d.", name[i]);
-		printk("\n");
-	}
-out:
-	return -ENOSYS;
+	/* If no error reading the parameters then just -ENOSYS ... */
+	if (!error)
+		error = -ENOSYS;
+
+	return error;
 }
 
 int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
-- 
1.5.3.rc6.17.g1911

