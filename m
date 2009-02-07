Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZBGMAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZBGMAT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZBGMAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:00:05 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57039 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZBGMAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:00:01 -0500
Date: Sat, 7 Feb 2009 12:59:56 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <gregkh@suse.de>, Shane Hathaway <shane@hathawaymix.org>,
       Daolong Wang <ahlongxp@gmail.com>,
       User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
       Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Rob Landley <rob@landley.net>, Am?rico Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
Message-ID: <20090207125956.110591c9@osiris.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0902042150550.25136@anakin>
References: <20090115194033.GA10926@hack.private>
	<20090116124158.4364e269.akpm@linux-foundation.org>
	<200901170328.15178.rob@landley.net>
	<dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>
	<20090119152104.GC6432@c2.user-mode-linux.org>
	<dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com>
	<49753063.8040007@hathawaymix.org>
	<alpine.LRH.2.00.0902041803360.7690@vixen.sonytel.be>
	<Pine.LNX.4.64.0902042115530.25136@anakin>
	<20090204204009.GA10680@suse.de>
	<Pine.LNX.4.64.0902042150550.25136@anakin>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 21:54:12 +0100 (CET)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> I verified that Shane's solution:
> 
> #define sys_sigprocmask sys_kernel_sigprocmask
> 
> works for me, but that's definitely not the cleanest way.
> 
> Al Viro also had a suggestion to rework the SYSCALL_DEFINE* macros, but I
> haven't tried it yet.


Patch below should fix it.


Subject: [PATCH] syscall define: fix uml compile bug

From: Heiko Carstens <heiko.carstens@de.ibm.com>

With the new system call defines we get this on uml:

arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x308): undefined reference to `sys_sigprocmask'

Reason for this is that uml passes the preprocessor option
-Dsigprocmask=kernel_sigprocmask to gcc when compiling the kernel.
This causes SYSCALL_DEFINE3(sigprocmask, ...) to be expanded to
SYSCALL_DEFINEx(3, kernel_sigprocmask, ...) and finally to a system call
named sys_kernel_sigprocmask. However sys_sigprocmask is missing because
of this.
To avoid macro expansion for the system call name just concatenate the
name at first define instead of carrying it through severel levels.
This was pointed out by Al Viro.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/syscalls.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
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
@@ -121,21 +121,21 @@ struct old_linux_dirent;
 
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
 
