Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXCVQKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXCVQKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934102AbXCVQKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:10:14 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53377 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933913AbXCVQJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:48 -0400
Date: Thu, 22 Mar 2007 12:06:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 5/7 ] UML - Move remaining useful contents of user_util.h
Message-ID: <20070322160647.GA7017@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rescue the useful contents of the soon-to-be-gone user-util.h.

pty.c now gets ptsname from stdlib.h like it should have always done.

CATCH_EINTR is now in os.h, although perhaps all usage should be under
os-Linux at some point.

get_pty is also in os.h.

This patch restores the old definition of ARRAY_SIZE in user.h.  This
file is included only in userspace files, so there will be no conflict
with the kernel's new ARRAY_SIZE.  The copy of the kernel's ARRAY_SIZE
and associated infrastructure is now gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/pty.c           |    1 +
 arch/um/include/os.h            |    6 ++++++
 arch/um/include/user.h          |   19 ++++++++-----------
 arch/um/include/user_util.h     |   18 ------------------
 arch/um/os-Linux/sys-i386/tls.c |    1 +
 5 files changed, 16 insertions(+), 29 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/pty.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/pty.c	2007-03-22 11:18:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/pty.c	2007-03-22 11:21:01.000000000 -0400
@@ -4,6 +4,7 @@
  */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
Index: linux-2.6.21-mm/arch/um/include/os.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/os.h	2007-03-22 11:18:48.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/os.h	2007-03-22 11:21:01.000000000 -0400
@@ -16,6 +16,8 @@
 #include "sysdep/tls.h"
 #include "sysdep/archsetjmp.h"
 
+#define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
+
 #define OS_TYPE_FILE 1
 #define OS_TYPE_DIR 2
 #define OS_TYPE_SYMLINK 3
@@ -341,6 +343,10 @@ extern void maybe_sigio_broken(int fd, i
 extern void sig_handler_common_skas(int sig, void *sc_ptr);
 extern void user_signal(int sig, union uml_pt_regs *regs, int pid);
 
+/* sys-x86_64/prctl.c */
 extern int os_arch_prctl(int pid, int code, unsigned long *addr);
 
+/* tty.c */
+int get_pty(void);
+
 #endif
Index: linux-2.6.21-mm/arch/um/include/user.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user.h	2007-03-22 11:18:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/user.h	2007-03-22 11:21:01.000000000 -0400
@@ -6,6 +6,14 @@
 #ifndef __USER_H__
 #define __USER_H__
 
+/*
+ * The usual definition - copied here because the kernel provides its own,
+ * fancier, type-safe, definition.  Using that one would require
+ * copying too much infrastructure for my taste, so userspace files
+ * get less checking than kernel files.
+ */
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
 /* Both on kernelspace and userspace this will provide the size_t definition. It should, at
  * least. But on userspace it won't hurt surely. */
 #include <linux/types.h>
@@ -21,14 +29,3 @@ extern size_t strlcpy(char *, const char
 extern size_t strlcat(char *, const char *, size_t);
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6.21-mm/arch/um/include/user_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user_util.h	2007-03-22 11:18:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/user_util.h	2007-03-22 11:21:01.000000000 -0400
@@ -8,31 +8,13 @@
 
 #include "sysdep/ptrace.h"
 
-/* Copied from kernel.h and compiler-gcc.h */
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
-
-/* &a[0] degrades to a pointer: a different type from an array */
-#define __must_be_array(a) \
-  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
-
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
-
-#define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
-
 extern int mode_tt;
 
 extern int grantpt(int __fd);
 extern int unlockpt(int __fd);
-extern char *ptsname(int __fd);
 
 extern void *add_signal_handler(int sig, void (*handler)(int));
 extern void input_cb(void (*proc)(void *), void *arg, int arg_len);
-extern int get_pty(void);
 extern int switcheroo(int fd, int prot, void *from, void *to, int size);
 extern void do_exec(int old_pid, int new_pid);
 extern void tracer_panic(char *msg, ...)
Index: linux-2.6.21-mm/arch/um/os-Linux/sys-i386/tls.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/sys-i386/tls.c	2007-03-22 11:18:21.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/sys-i386/tls.c	2007-03-22 11:21:01.000000000 -0400
@@ -5,6 +5,7 @@
 #include <unistd.h>
 
 #include "sysdep/tls.h"
+#include "user.h"
 #include "user_util.h"
 
 /* Checks whether host supports TLS, and sets *tls_min according to the value
