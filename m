Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0BIW4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:56:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:34818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab0BIW4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:56:00 -0500
Date: Tue, 9 Feb 2010 22:55:30 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com
In-Reply-To: <20100209202502.406177090@sbs-t61.sc.intel.com>
References: <20100209202502.406177090@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ptrace] ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET
Message-ID: <tip-b26d3b32b860e4667df88dc2407f8823e2aa7cc6@git.kernel.org>
Git-Commit-ID: b26d3b32b860e4667df88dc2407f8823e2aa7cc6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 22:55:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b26d3b32b860e4667df88dc2407f8823e2aa7cc6
Gitweb:     http://git.kernel.org/tip/b26d3b32b860e4667df88dc2407f8823e2aa7cc6
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 9 Feb 2010 12:13:13 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 9 Feb 2010 14:10:07 -0800

ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET

Generic support for PTRACE_GETREGSET/PTRACE_SETREGSET commands which
export the regsets supported by each architecture using the correponding
NT_* types.

'addr' parameter for the ptrace system call encode the REGSET type and
the buffer length. 'data' parameter points to the user buffer.

	ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid,
	       (NT_TYPE << 20) | buf_length, buf);

For more information on how to use this API by users like debuggers and core
dump for accessing xstate registers, etc., please refer to comments in
arch/x86/include/asm/ptrace-abi.h

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100209202502.406177090@sbs-t61.sc.intel.com>
Acked-by: Hongjiu Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/ptrace-abi.h |   50 +++++++++++++++++++++++++++++++++++++
 include/linux/elf.h               |   25 +++++++++++++++++-
 include/linux/ptrace.h            |   14 ++++++++++
 kernel/ptrace.c                   |   34 +++++++++++++++++++++++++
 4 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ptrace-abi.h b/arch/x86/include/asm/ptrace-abi.h
index 8672303..965a6ce 100644
--- a/arch/x86/include/asm/ptrace-abi.h
+++ b/arch/x86/include/asm/ptrace-abi.h
@@ -139,4 +139,54 @@ struct ptrace_bts_config {
    Returns number of BTS records drained.
 */
 
+/*
+ * The extended register state using xsave/xrstor infrastructure can be
+ * be read and set by the user using the following ptrace command.
+ *
+ *	ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid,
+ *	       (NT_X86_XSTATE << 20) | xstate_buf_length, xstate_buf);
+ *
+ * The structure layout used for the xstate_buf is same as
+ * the memory layout of xsave used by the processor (except for the bytes
+ * 464..511, which can be used by the software) and hence the size
+ * of this structure varies depending on the features supported by the processor
+ * and OS.  The size of the structure that users need to use can be obtained by
+ * doing:
+ *     cpuid_count(0xd, 0, &eax, &ptrace_xstateregs_struct_size, &ecx, &edx);
+ * i.e., cpuid.(eax=0xd,ecx=0).ebx will be the size that user (debuggers, etc.)
+ * need to use.
+ *
+ * The format of this structure will be like:
+ *	struct {
+ *		fxsave_bytes[0..463]
+ *		sw_usable_bytes[464..511]
+ *		xsave_hdr_bytes[512..575]
+ *		avx_bytes[576..831]
+ *		future_state etc
+ *	}
+ *
+ * The same memory layout will be used for the core-dump NT_X86_XSTATE
+ * note representing the xstate registers.
+ *
+ * For now, only the first 8 bytes of the sw_usable_bytes[464..471] will
+ * be used and will be set to OS enabled xstate mask (which is same as the
+ * 64bit mask returned by the xgetbv's xCR0).  Users (analyzing core dump
+ * remotely, etc.) can use this mask as well as the mask saved in the
+ * xstate_hdr bytes and interpret what states the processor/OS supports
+ * and what states are in modified/initialized conditions for the
+ * particular process/thread.
+ *
+ * Also when the user modifies certain state FP/SSE/etc through this
+ * PTRACE_SETXSTATEREGS, they must ensure that the xsave_hdr.xstate_bv
+ * bytes[512..519] of the above memory layout are updated correspondingly.
+ * i.e., for example when FP state is modified to a non-init state,
+ * xsave_hdr.xstate_bv's bit 0 must be set to '1', when SSE is modified to
+ * non-init state, xsave_hdr.xstate_bv's bit 1 must to be set to '1', etc.
+ */
+
+/*
+ * Enable PTRACE_GETREGSET/PTRACE_SETREGSET interface
+ */
+#define PTRACE_EXPORT_REGSET
+
 #endif /* _ASM_X86_PTRACE_ABI_H */
diff --git a/include/linux/elf.h b/include/linux/elf.h
index a8c4af0..5fd7996 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -349,7 +349,29 @@ typedef struct elf64_shdr {
 #define ELF_OSABI ELFOSABI_NONE
 #endif
 
-/* Notes used in ET_CORE */
+/*
+ * Notes used in ET_CORE. Architectures export some of the arch register sets
+ * using the corresponding note types via ptrace
+ * PTRACE_GETREGSET/PTRACE_SETREGSET requests.
+ *
+ * For example,
+ *	long addr = (NT_X86_XSTATE << 20 | buf_length);
+ *	ptrace(PTRACE_GETREGSET, pid, addr, buf);
+ *
+ * will obtain the x86 extended register state of the pid.
+ *
+ * On 32bit architectures, addr argument is 32bits wide and encodes the length
+ * of the buffer in the first 20 bits, followed by NT_* type encoded in the
+ * remaining 12 bits, representing an unique regset.
+ *
+ * Hence on 32bit architectures, NT_PRXFPREG (0x46e62b7f) will be seen as 0xb7f
+ * and we can't allocate 0xb7f to any other note.
+ *
+ * All the other existing NT_* types fall with in the 12 bits and we have
+ * plenty of room for more NT_* types. For now, on all architectures
+ * we use first 20 bits of the addr for the buffer size and the next 12 bits for
+ * the NT_* type representing the corresponding regset.
+ */
 #define NT_PRSTATUS	1
 #define NT_PRFPREG	2
 #define NT_PRPSINFO	3
@@ -364,7 +386,6 @@ typedef struct elf64_shdr {
 #define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
 #define NT_S390_HIGH_GPRS	0x300	/* s390 upper register halves */
 
-
 /* Note header in a PT_NOTE section */
 typedef struct elf32_note {
   Elf32_Word	n_namesz;	/* Name size */
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 56f2d63..4522e5e 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -26,6 +26,18 @@
 #define PTRACE_GETEVENTMSG	0x4201
 #define PTRACE_GETSIGINFO	0x4202
 #define PTRACE_SETSIGINFO	0x4203
+#define PTRACE_GETREGSET	0x4204
+#define PTRACE_SETREGSET	0x4205
+
+/*
+ * First 20 bits of the addr in the PTRACE_GETREGSET/PTRACE_SETREGSET requests
+ * are reserved for communicating the user buffer size and the remaining 12 bits
+ * are reserved for the NT_* types (defined in include/linux/elf.h) which
+ * indicate the regset that the ptrace user is interested in.
+ */
+#define PTRACE_REGSET_BUF_SIZE(addr)	(addr & 0xfffff)
+#define PTRACE_REGSET_TYPE(addr)	((addr >> 20) & 0xfff)
+#define NOTE_TO_REGSET_TYPE(note)	(note & 0xfff)
 
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	0x00000001
@@ -114,6 +126,8 @@ static inline void ptrace_unlink(struct task_struct *child)
 
 int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
 int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
+int generic_ptrace_regset(struct task_struct *child, long request, long addr,
+			  long data);
 
 /**
  * task_ptrace - return %PT_* flags that apply to a task
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..7040208 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/regset.h>
 
 
 /*
@@ -573,6 +574,11 @@ int ptrace_request(struct task_struct *child, long request,
 			return 0;
 		return ptrace_resume(child, request, SIGKILL);
 
+#ifdef PTRACE_EXPORT_REGSET
+	case PTRACE_GETREGSET:
+	case PTRACE_SETREGSET:
+		return generic_ptrace_regset(child, request, addr, data);
+#endif
 	default:
 		break;
 	}
@@ -664,6 +670,34 @@ int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data)
 	return (copied == sizeof(data)) ? 0 : -EIO;
 }
 
+#ifdef PTRACE_EXPORT_REGSET
+int generic_ptrace_regset(struct task_struct *child, long request, long addr,
+			  long data)
+{
+	const struct user_regset_view *view = task_user_regset_view(child);
+	unsigned int buf_size = PTRACE_REGSET_BUF_SIZE(addr);
+	int setno;
+
+	for (setno = 0; setno < view->n; setno++) {
+		const struct user_regset *regset = &view->regsets[setno];
+		if (NOTE_TO_REGSET_TYPE(regset->core_note_type) !=
+		    PTRACE_REGSET_TYPE(addr))
+			continue;
+
+		if (request == PTRACE_GETREGSET)
+			return copy_regset_to_user(child, view, setno, 0,
+						   buf_size,
+						   (void __user *) data);
+		else if (request == PTRACE_SETREGSET)
+			return copy_regset_from_user(child, view, setno, 0,
+						     buf_size,
+						     (void __user *) data);
+	}
+
+	return -EIO;
+}
+#endif
+
 #if defined CONFIG_COMPAT
 #include <linux/compat.h>
 
