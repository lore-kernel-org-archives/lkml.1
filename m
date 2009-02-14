Return-Path: <linux-kernel-owner+w=401wt.eu-S1762543AbZBNBEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762543AbZBNBEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZBNBBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:32 -0500
Received: from kroah.org ([198.145.64.141]:39479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754422AbZBNBBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:31 -0500
Date: Fri, 13 Feb 2009 16:58:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 09/47] syscall define: fix uml compile bug
Message-ID: <20090214005822.GJ11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="syscall-define-fix-uml-compile-bug.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 6c5979631b4b03c9288776562c18036765e398c1 upstream.

With the new system call defines we get this on uml:

arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x308): undefined reference to `sys_sigprocmask'

Reason for this is that uml passes the preprocessor option
-Dsigprocmask=kernel_sigprocmask to gcc when compiling the kernel.
This causes SYSCALL_DEFINE3(sigprocmask, ...) to be expanded to
SYSCALL_DEFINEx(3, kernel_sigprocmask, ...) and finally to a system
call named sys_kernel_sigprocmask.  However sys_sigprocmask is missing
because of this.

To avoid macro expansion for the system call name just concatenate the
name at first define instead of carrying it through severel levels.
This was pointed out by Al Viro.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/syscalls.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -95,13 +95,13 @@ struct old_linux_dirent;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
-#define SYSCALL_DEFINE0(name)   asmlinkage long sys_##name(void)
-#define SYSCALL_DEFINE1(...)    SYSCALL_DEFINEx(1, __VA_ARGS__)
-#define SYSCALL_DEFINE2(...)    SYSCALL_DEFINEx(2, __VA_ARGS__)
-#define SYSCALL_DEFINE3(...)    SYSCALL_DEFINEx(3, __VA_ARGS__)
-#define SYSCALL_DEFINE4(...)    SYSCALL_DEFINEx(4, __VA_ARGS__)
-#define SYSCALL_DEFINE5(...)    SYSCALL_DEFINEx(5, __VA_ARGS__)
-#define SYSCALL_DEFINE6(...)    SYSCALL_DEFINEx(6, __VA_ARGS__)
+#define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
+#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, _##name, __VA_ARGS__)
+#define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
 #ifdef CONFIG_PPC64
 #define SYSCALL_ALIAS(alias, name)					\
@@ -116,21 +116,21 @@ struct old_linux_dirent;
 
 #define SYSCALL_DEFINE(name) static inline long SYSC_##name
 #define SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));		\
-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));	\
-	asmlinkage long SyS_##name(__SC_LONG##x(__VA_ARGS__))		\
+	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__));		\
+	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__));	\
+	asmlinkage long SyS##name(__SC_LONG##x(__VA_ARGS__))		\
 	{								\
 		__SC_TEST##x(__VA_ARGS__);				\
-		return (long) SYSC_##name(__SC_CAST##x(__VA_ARGS__));	\
+		return (long) SYSC##name(__SC_CAST##x(__VA_ARGS__));	\
 	}								\
-	SYSCALL_ALIAS(sys_##name, SyS_##name);				\
-	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
+	SYSCALL_ALIAS(sys##name, SyS##name);				\
+	static inline long SYSC##name(__SC_DECL##x(__VA_ARGS__))
 
 #else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 
 #define SYSCALL_DEFINE(name) asmlinkage long sys_##name
 #define SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))
+	asmlinkage long sys##name(__SC_DECL##x(__VA_ARGS__))
 
 #endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
 

