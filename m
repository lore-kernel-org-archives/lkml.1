Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0BKXTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:19:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:47627 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab0BKXTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:19:35 -0500
Date: Thu, 11 Feb 2010 23:19:04 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com
In-Reply-To: <20100211195614.886724710@sbs-t61.sc.intel.com>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ptrace] ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET
Message-ID: <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
Git-Commit-ID: 2225a122ae26d542bdce523d9d87a4a7ba10e07b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 23:19:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2225a122ae26d542bdce523d9d87a4a7ba10e07b
Gitweb:     http://git.kernel.org/tip/2225a122ae26d542bdce523d9d87a4a7ba10e07b
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 11 Feb 2010 11:51:00 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 11 Feb 2010 15:08:33 -0800

ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET

Generic support for PTRACE_GETREGSET/PTRACE_SETREGSET commands which
export the regsets supported by each architecture using the correponding
NT_* types. These NT_* types are already part of the userland ABI, used
in representing the architecture specific register sets as different NOTES
in an ELF core file.

'addr' parameter for the ptrace system call encode the REGSET type (using
the corresppnding NT_* type) and the 'data' parameter points to the
struct iovec having the user buffer and the length of that buffer.

	struct iovec iov = { buf, len};
	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);

On successful completion, iov.len will be updated by the kernel specifying
how much the kernel has written/read to/from the user's iov.buf.

x86 extended state registers are primarily exported using this interface.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100211195614.886724710@sbs-t61.sc.intel.com>
Acked-by: Hongjiu Lu <hjl.tools@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/linux/elf.h    |    6 +++-
 include/linux/ptrace.h |   15 ++++++++
 kernel/ptrace.c        |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/include/linux/elf.h b/include/linux/elf.h
index a8c4af0..d8e6e61 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -349,7 +349,11 @@ typedef struct elf64_shdr {
 #define ELF_OSABI ELFOSABI_NONE
 #endif
 
-/* Notes used in ET_CORE */
+/*
+ * Notes used in ET_CORE. Architectures export some of the arch register sets
+ * using the corresponding note types via the PTRACE_GETREGSET and
+ * PTRACE_SETREGSET requests.
+ */
 #define NT_PRSTATUS	1
 #define NT_PRFPREG	2
 #define NT_PRPSINFO	3
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 56f2d63..dbfa821 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -27,6 +27,21 @@
 #define PTRACE_GETSIGINFO	0x4202
 #define PTRACE_SETSIGINFO	0x4203
 
+/*
+ * Generic ptrace interface that exports the architecture specific regsets
+ * using the corresponding NT_* types (which are also used in the core dump).
+ *
+ * This interface usage is as follows:
+ *	struct iovec iov = { buf, len};
+ *
+ *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
+ *
+ * On the successful completion, iov.len will be updated by the kernel,
+ * specifying how much the kernel has written/read to/from the user's iov.buf.
+ */
+#define PTRACE_GETREGSET	0x4204
+#define PTRACE_SETREGSET	0x4205
+
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	0x00000001
 #define PTRACE_O_TRACEFORK	0x00000002
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..13b4554 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/regset.h>
 
 
 /*
@@ -511,6 +512,47 @@ static int ptrace_resume(struct task_struct *child, long request, long data)
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+
+static const struct user_regset *
+find_regset(const struct user_regset_view *view, unsigned int type)
+{
+	const struct user_regset *regset;
+	int n;
+
+	for (n = 0; n < view->n; ++n) {
+		regset = view->regsets + n;
+		if (regset->core_note_type == type)
+			return regset;
+	}
+
+	return NULL;
+}
+
+static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
+			 struct iovec *kiov)
+{
+	const struct user_regset_view *view = task_user_regset_view(task);
+	const struct user_regset *regset = find_regset(view, type);
+	int regset_no;
+
+	if (!regset || (kiov->iov_len % regset->size) != 0)
+		return -EIO;
+
+	regset_no = regset - view->regsets;
+	kiov->iov_len = min(kiov->iov_len,
+			    (__kernel_size_t) (regset->n * regset->size));
+
+	if (req == PTRACE_GETREGSET)
+		return copy_regset_to_user(task, view, regset_no, 0,
+					   kiov->iov_len, kiov->iov_base);
+	else
+		return copy_regset_from_user(task, view, regset_no, 0,
+					     kiov->iov_len, kiov->iov_base);
+}
+
+#endif
+
 int ptrace_request(struct task_struct *child, long request,
 		   long addr, long data)
 {
@@ -573,6 +615,26 @@ int ptrace_request(struct task_struct *child, long request,
 			return 0;
 		return ptrace_resume(child, request, SIGKILL);
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	case PTRACE_GETREGSET:
+	case PTRACE_SETREGSET:
+	{
+		struct iovec kiov;
+		struct iovec __user *uiov = (struct iovec __user *) data;
+
+		if (!access_ok(VERIFY_WRITE, uiov, sizeof(*uiov)))
+			return -EFAULT;
+
+		if (__get_user(kiov.iov_base, &uiov->iov_base) ||
+		    __get_user(kiov.iov_len, &uiov->iov_len))
+			return -EFAULT;
+
+		ret = ptrace_regset(child, request, addr, &kiov);
+		if (!ret)
+			ret = __put_user(kiov.iov_len, &uiov->iov_len);
+		break;
+	}
+#endif
 	default:
 		break;
 	}
@@ -711,6 +773,32 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 		else
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	case PTRACE_GETREGSET:
+	case PTRACE_SETREGSET:
+	{
+		struct iovec kiov;
+		struct compat_iovec __user *uiov =
+			(struct compat_iovec __user *) datap;
+		compat_uptr_t ptr;
+		compat_size_t len;
+
+		if (!access_ok(VERIFY_WRITE, uiov, sizeof(*uiov)))
+			return -EFAULT;
+
+		if (__get_user(ptr, &uiov->iov_base) ||
+		    __get_user(len, &uiov->iov_len))
+			return -EFAULT;
+
+		kiov.iov_base = compat_ptr(ptr);
+		kiov.iov_len = len;
+
+		ret = ptrace_regset(child, request, addr, &kiov);
+		if (!ret)
+			ret = __put_user(kiov.iov_len, &uiov->iov_len);
+		break;
+	}
+#endif
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
