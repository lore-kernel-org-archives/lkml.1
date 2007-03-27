Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXC0VWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXC0VWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965459AbXC0VWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:22:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54747 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXC0VWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:22:21 -0400
Date: Tue, 27 Mar 2007 23:23:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm1
Message-ID: <20070327212303.GA7146@uranus.ravnborg.org>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070326205706.a750bb35.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> - You may see this:
> 
>   init/missing_syscalls.c:5:27: error: linux/compile.h: No such file or directory
> 
>   during compilation.  It's probably a parallel-build bug in Sam's tree. 
>   Just type make again.

I ended up redoing the check-for-missing-sys-calls patch and backed out the
other patches.
The resulting patch is included below for reference.
Compared to the old patch this does:
-> Unconditionally run the check as part of the prepare for building
-> Does not generate any files
-> Keep most of the functionality in a single file contained in scripts/

I missed it in the patch description but it includes
the syscalls included by David Miller.

I have pushed out a fresh kbuild.git tree with this patch (and 18 others).

	Sam

commit 0dc20d72858da06283db0750ff7edf7294e79d7b
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Tue Mar 27 22:50:29 2007 +0200

    kbuild: complain about missing system calls
    
    Most system calls seems to get added to i386 first. This patch
    automatically generates a warning for any new system call which is
    implemented on i386 but not the architecture currently being compiled.
    On PowerPC at the moment, for example, it results in these warnings:
    init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
    init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
    init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented
    
    The file scripts/checksyscalls.sh list a number of legacy system calls
    that are ignored because they only makes sense on i386 systems.
    
    Other contributors to this patch are Russell King <rmk+lkml@arm.linux.org.uk>
    and Stéphane Jourdois <kwisatz@rubis.org>
    
    Signed-off-by: David Woodhouse <dwmw2@infradead.org>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/Kbuild b/Kbuild
index 0451f69..163f8cb 100644
--- a/Kbuild
+++ b/Kbuild
@@ -2,6 +2,7 @@
 # Kbuild for top-level directory of the kernel
 # This file takes care of the following:
 # 1) Generate asm-offsets.h
+# 2) Check for missing system calls
 
 #####
 # 1) Generate asm-offsets.h
@@ -46,3 +47,13 @@ $(obj)/$(offsets-file): arch/$(ARCH)/kernel/asm-offsets.s Kbuild
 	$(Q)mkdir -p $(dir $@)
 	$(call cmd,offsets)
 
+#####
+# 2) Check for missing system calls
+#
+
+quiet_cmd_syscalls = CALL    $<
+      cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
+
+PHONY += missing-syscalls
+missing-syscalls: scripts/checksyscalls.sh FORCE
+	$(call cmd,syscalls)
diff --git a/Makefile b/Makefile
index f0d7f6e..8d8f208 100644
--- a/Makefile
+++ b/Makefile
@@ -856,6 +856,7 @@ archprepare: prepare1 scripts_basic
 
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
+	$(Q)$(MAKE) $(build)=. missing-syscalls
 
 # All the preparing..
 prepare: prepare0
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
new file mode 100755
index 0000000..619aba1
--- /dev/null
+++ b/scripts/checksyscalls.sh
@@ -0,0 +1,118 @@
+#!/bin/sh
+#
+# Check if current architecture are missing any function calls compared
+# to i386.
+# i386 define a number of legacy system calls that are i386 specific
+# and listed below so they are ignored.
+#
+# Usage:
+# syscallchk gcc gcc-options
+#
+
+ignore_list() {
+cat << EOF
+#include <asm/types.h>
+#include <asm/unistd.h>
+
+/* System calls for 32-bit kernels only */
+#if BITS_PER_LONG == 64
+#define __IGNORE_sendfile64
+#define __IGNORE_ftruncate64
+#define __IGNORE_truncate64
+#define __IGNORE_stat64
+#define __IGNORE_lstat64
+#define __IGNORE_fstat64
+#define __IGNORE_fcntl64
+#define __IGNORE_fadvise64_64
+#define __IGNORE_fstatat64
+#define __IGNORE_fstatfs64
+#define __IGNORE_statfs64
+#endif
+
+/* i386-specific or historical system calls */
+#define __IGNORE_break
+#define __IGNORE_stty
+#define __IGNORE_gtty
+#define __IGNORE_ftime
+#define __IGNORE_prof
+#define __IGNORE_lock
+#define __IGNORE_mpx
+#define __IGNORE_ulimit
+#define __IGNORE_profil
+#define __IGNORE_ioperm
+#define __IGNORE_iopl
+#define __IGNORE_idle
+#define __IGNORE_modify_ldt
+#define __IGNORE_ugetrlimit
+#define __IGNORE_mmap2
+#define __IGNORE_vm86
+#define __IGNORE_vm86old
+#define __IGNORE_set_thread_area
+#define __IGNORE_get_thread_area
+#define __IGNORE_madvise1
+#define __IGNORE_oldstat
+#define __IGNORE_oldfstat
+#define __IGNORE_oldlstat
+#define __IGNORE_oldolduname
+#define __IGNORE_olduname
+#define __IGNORE_umount2
+#define __IGNORE_umount
+#define __IGNORE_waitpid
+#define __IGNORE_stime
+#define __IGNORE_nice
+#define __IGNORE_signal
+#define __IGNORE_sigaction
+#define __IGNORE_sgetmask
+#define __IGNORE_sigsuspend
+#define __IGNORE_sigpending
+#define __IGNORE_ssetmask
+#define __IGNORE_readdir
+#define __IGNORE_socketcall
+#define __IGNORE_ipc
+#define __IGNORE_sigreturn
+#define __IGNORE_sigprocmask
+#define __IGNORE_bdflush
+#define __IGNORE__llseek
+#define __IGNORE__newselect
+#define __IGNORE_create_module
+#define __IGNORE_delete_module
+#define __IGNORE_query_module
+#define __IGNORE_get_kernel_syms
+/* ... including the "new" 32-bit uid syscalls */
+#define __IGNORE_lchown32
+#define __IGNORE_getuid32
+#define __IGNORE_getgid32
+#define __IGNORE_geteuid32
+#define __IGNORE_getegid32
+#define __IGNORE_setreuid32
+#define __IGNORE_setregid32
+#define __IGNORE_getgroups32
+#define __IGNORE_setgroups32
+#define __IGNORE_fchown32
+#define __IGNORE_setresuid32
+#define __IGNORE_getresuid32
+#define __IGNORE_setresgid32
+#define __IGNORE_getresgid32
+#define __IGNORE_chown32
+#define __IGNORE_setuid32
+#define __IGNORE_setgid32
+#define __IGNORE_setfsuid32
+#define __IGNORE_setfsgid32
+
+/* Unmerged syscalls for AFS, STREAMS, etc. */
+#define __IGNORE_afs_syscall
+#define __IGNORE_getpmsg
+#define __IGNORE_putpmsg
+#define __IGNORE_vserver
+EOF
+}
+
+syscall_list() {
+sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
+\#if !defined \(__NR_\1\) \&\& !defined \(__IGNORE_\1\)\
+\#warning syscall \1 not implemented\
+\#endif/p }' $1
+}
+
+(ignore_list && syscall_list ${srctree}/include/asm-i386/unistd.h) | \
+$* -E -x c - > /dev/null
