Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYLDFH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYLDFH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYLDFHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:07:46 -0500
Received: from ozlabs.org ([203.10.76.45]:46640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbYLDFHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:07:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18743.25968.602602.875295@drongo.ozlabs.ibm.com>
Date: Thu, 4 Dec 2008 16:06:56 +1100
From: Paul Mackerras <paulus@samba.org>
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Joakim.Tjernlund@transmode.se
Subject: [PATCH] Allow times and time system calls to return small
   negative values
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, the times() system call will appear to fail for a
period shortly after boot, while the value it want to return is
between -4095 and -1.  The same thing will also happen for the time()
system call on 32-bit platforms some time in 2106 or so.

On some platforms, such as x86, this is unavoidable because of the
system call ABI, but other platforms such as powerpc have a separate
error indication from the return value, so system calls can in fact
return small negative values without indicating an error.  On those
platforms, force_successful_syscall_return() provides a way to
indicate that the system call return value should not be treated as an
error even if it is in the range which would normally be taken as a
negative error number.

This adds a force_successful_syscall_return() call to the time() and
times() system calls plus their 32-bit compat versions, so that they
don't erroneously indicate an error on those platforms whose system
call ABI has a separate error indication.  This will not affect
anything on other platforms.

Joakim Tjernlund added the fix for time() and the compat versions of
time() and times(), after I did the fix for times().

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Andrew - since this only touches generic code, will you queue this up
for 2.6.29?

diff --git a/kernel/compat.c b/kernel/compat.c
index 8eafe3e..21a93ce 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -24,6 +24,7 @@
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
 #include <linux/times.h>
+#include <linux/ptrace.h>
 
 #include <asm/uaccess.h>
 
@@ -229,6 +230,7 @@ asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
 		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
 			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return compat_jiffies_to_clock_t(jiffies);
 }
 
@@ -883,8 +885,9 @@ asmlinkage long compat_sys_time(compat_time_t __user * tloc)
 
 	if (tloc) {
 		if (put_user(i,tloc))
-			i = -EFAULT;
+			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return i;
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..1bf8c5c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -33,6 +33,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
 #include <linux/cpu.h>
+#include <linux/ptrace.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -878,6 +879,7 @@ asmlinkage long sys_times(struct tms __user * tbuf)
 		if (copy_to_user(tbuf, &tmp, sizeof(struct tms)))
 			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return (long) jiffies_64_to_clock_t(get_jiffies_64());
 }
 
diff --git a/kernel/time.c b/kernel/time.c
index d63a433..4886e3c 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/math64.h>
+#include <linux/ptrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -65,8 +66,9 @@ asmlinkage long sys_time(time_t __user * tloc)
 
 	if (tloc) {
 		if (put_user(i,tloc))
-			i = -EFAULT;
+			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return i;
 }
 
