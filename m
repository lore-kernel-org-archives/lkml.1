Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXCUWWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXCUWWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXCUWWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:22:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40672 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXCUWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:22:17 -0400
Date: Wed, 21 Mar 2007 23:22:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/3] kbuild: complain about missing system calls.
Message-ID: <20070321222236.GB22623@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net> <20070320214714.0e584cd4.akpm@linux-foundation.org> <20070321221905.GA22623@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070321221905.GA22623@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5fbf06eb42fdaf81529d2433fe0953297cbc7cc6 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 8 Mar 2007 23:01:13 +0000
Subject: [PATCH] kbuild: complain about missing system calls.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Most system calls seem to get added to i386 first. This patch
automatically generates a warning for any new system call which is
implemented on i386 but not the architecture currently being compiled.
On PowerPC at the moment, for example, it results in these warnings:
init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented

Other contributors to this patch are Russell King <rmk+lkml@arm.linux.org.uk>
and Stéphane Jourdois <kwisatz@rubis.org>

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 init/Makefile           |   12 +++++++++-
 init/missing_syscalls.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++
 scripts/syscallchk      |    6 +++++
 3 files changed, 74 insertions(+), 1 deletions(-)

diff --git a/init/Makefile b/init/Makefile
index 0154aea..af9f529 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y                          := main.o version.o mounts.o
+obj-y                          := main.o version.o mounts.o missing_syscalls.o
 ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
 else
@@ -21,6 +21,7 @@ clean-files := ../include/linux/compile.h
 # dependencies on generated files need to be listed explicitly
 
 $(obj)/version.o: include/linux/compile.h
+$(obj)/missing_syscalls.o: $(obj)/missing_syscalls.h
 
 # compile.h changes depending on hostname, generation number, etc,
 # so we regenerate it always.
@@ -31,3 +32,12 @@ include/linux/compile.h: FORCE
 	@echo '  CHK     $@'
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkcompile_h $@ \
 	"$(UTS_MACHINE)" "$(CONFIG_SMP)" "$(CONFIG_PREEMPT)" "$(CC) $(CFLAGS)"
+
+
+quiet_cmd_missing_syscalls = GEN     $@
+      cmd_missing_syscalls = sed -n -f $(srctree)/scripts/syscallchk $< > $@
+
+targets += missing_syscalls.h
+$(obj)/missing_syscalls.h: include/asm-i386/unistd.h \
+                           $(srctree)/scripts/syscallchk $(src)/Makefile
+	$(call if_changed,missing_syscalls)
diff --git a/init/missing_syscalls.c b/init/missing_syscalls.c
new file mode 100644
index 0000000..e802b06
--- /dev/null
+++ b/init/missing_syscalls.c
@@ -0,0 +1,57 @@
+#include <asm/types.h>
+#include <asm/unistd.h>
+
+/* Force recompilation (and thus warnings) every time we rebuild the kernel */
+#include <linux/compile.h>
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
+#endif
+
+/* i386-specific or historical system calls */
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
+/* Not yet upstream */
+#define __IGNORE_vserver
+
+#include "missing_syscalls.h"
diff --git a/scripts/syscallchk b/scripts/syscallchk
new file mode 100644
index 0000000..d545717
--- /dev/null
+++ b/scripts/syscallchk
@@ -0,0 +1,6 @@
+/^\#define/ {
+	s/[^_]*__NR_\([^[:space:]]*\).*/\
+\#if !defined (__NR_\1) \&\& !defined (__IGNORE_\1)\
+\#warning syscall \1 not implemented\
+\#endif/p
+}
-- 
1.4.4.2

