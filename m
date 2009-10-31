Return-Path: <linux-kernel-owner+w=401wt.eu-S933229AbZJaSsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbZJaSsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbZJaSsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933164AbZJaSsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:48:09 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 08/10] fanotify: sys_fanotify_mark declartion
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:48:06 -0400
Message-ID: <20091031184806.17244.88747.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply declares the new sys_fanotify_mark syscall

int fanotify_mark(int fanotify_fd, unsigned int flags, int dfd
		  const char *pathname, u64 mask, u64 ignored_mask)

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/notify/fanotify/fanotify_user.c |    6 ++++++
 include/linux/syscalls.h           |    3 +++
 6 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index df13544..48960ac 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -843,4 +843,5 @@ ia32_sys_call_table:
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
 	.quad sys_fanotify_init
+	.quad sys_fanotify_mark
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 1dc812d..cf70e9e 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -344,10 +344,11 @@
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
 #define __NR_fanotify_init	338
+#define __NR_fanotify_mark	339
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 339
+#define NR_syscalls 340
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 83f0f69..7fbd20f 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -665,6 +665,8 @@ __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 #define __NR_fanotify_init			300
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
+#define __NR_fanotify_mark			301
+__SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 34bf346..ca486c7 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -338,3 +338,4 @@ ENTRY(sys_call_table)
 	.long sys_perf_event_open
 	.long sys_recvmmsg
 	.long sys_fanotify_init
+	.long sys_fanotify_mark
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9ca7413..c93f56b 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -70,3 +70,9 @@ out_put_group:
 	fsnotify_put_group(group);
 	return fd;
 }
+
+SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
+		int, dfd, const char  __user *, pathname, __u64, mask)
+{
+	return -ENOSYS;
+}
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 534f9ff..f3492ac 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -877,6 +877,9 @@ asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
 			  struct timespec __user *, const sigset_t __user *,
 			  size_t);
 asmlinkage long sys_fanotify_init(unsigned int flags, unsigned int event_f_flags, int priority);
+asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
+				  int fd, const char  __user *pathname,
+				  u64 mask);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 

