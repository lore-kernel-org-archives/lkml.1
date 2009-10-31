Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbZJaSsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbZJaSsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933199AbZJaSr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:47:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbZJaSr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:47:57 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 06/10] fanotify: fanotify_init syscall declaration
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:47:54 -0400
Message-ID: <20091031184753.17244.50364.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines a new syscall fanotify_init() of the form:
    
int sys_fanotify_init(unsigned int flags, unsigned int event_f_flags, int priority)
    
This syscall is used to create and fanotify group.  This is very similar to
the inotify_init() syscall.
    
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/notify/fanotify/Makefile        |    2 +-
 fs/notify/fanotify/fanotify_user.c |   13 +++++++++++++
 include/linux/syscalls.h           |    1 +
 7 files changed, 21 insertions(+), 2 deletions(-)
 create mode 100644 fs/notify/fanotify/fanotify_user.c

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index d23b987..df13544 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -842,4 +842,5 @@ ia32_sys_call_table:
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
+	.quad sys_fanotify_init
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 3baf379..1dc812d 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -343,10 +343,11 @@
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
+#define __NR_fanotify_init	338
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 338
+#define NR_syscalls 339
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 4843f7b..83f0f69 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,8 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_fanotify_init			300
+__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 70c2125..34bf346 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -337,3 +337,4 @@ ENTRY(sys_call_table)
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
 	.long sys_recvmmsg
+	.long sys_fanotify_init
diff --git a/fs/notify/fanotify/Makefile b/fs/notify/fanotify/Makefile
index e7d39c0..0999213 100644
--- a/fs/notify/fanotify/Makefile
+++ b/fs/notify/fanotify/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_FANOTIFY)		+= fanotify.o
+obj-$(CONFIG_FANOTIFY)		+= fanotify.o fanotify_user.o
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
new file mode 100644
index 0000000..ca35276
--- /dev/null
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -0,0 +1,13 @@
+#include <linux/fcntl.h>
+#include <linux/fs.h>
+#include <linux/fsnotify_backend.h>
+#include <linux/security.h>
+#include <linux/syscalls.h>
+
+#include "fanotify.h"
+
+SYSCALL_DEFINE3(fanotify_init, unsigned int, flags, unsigned int, event_f_flags,
+		int, priority)
+{
+	return -ENOSYS;
+}
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f03a2d9..534f9ff 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -876,6 +876,7 @@ asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
 asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
 			  struct timespec __user *, const sigset_t __user *,
 			  size_t);
+asmlinkage long sys_fanotify_init(unsigned int flags, unsigned int event_f_flags, int priority);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 

