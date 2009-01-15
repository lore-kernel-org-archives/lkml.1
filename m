Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbZAOUZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbZAOUZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760969AbZAOUBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:20 -0500
Received: from kroah.org ([198.145.64.141]:49203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932071AbZAOUBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:03 -0500
Date: Thu, 15 Jan 2009 11:58:39 -0800
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
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 38/94] [PATCH 07/44] [CVE-2009-0029] System call wrapper
	infrastructure
Message-ID: <20090115195839.GL14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0007--CVE-2009-0029-System-call-wrapper-infrastructure.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 1a94bc34768e463a93cb3751819709ab0ea80a01 upstream.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

By selecting HAVE_SYSCALL_WRAPPERS architectures can activate
system call wrappers in order to sign extend system call arguments.

All architectures where the ABI defines that the caller of a function
has to perform sign extension probably need this.

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/Kconfig             |    3 ++
 include/linux/syscalls.h |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -60,6 +60,9 @@ config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	  See Documentation/unaligned-memory-access.txt for more
 	  information on the topic of unaligned memory accesses.
 
+config HAVE_SYSCALL_WRAPPERS
+	bool
+
 config KRETPROBES
 	def_bool y
 	depends on KPROBES && HAVE_KRETPROBES
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -66,6 +66,68 @@ struct old_linux_dirent;
 #include <linux/quota.h>
 #include <linux/key.h>
 
+#define __SC_DECL1(t1, a1)	t1 a1
+#define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
+#define __SC_DECL3(t3, a3, ...) t3 a3, __SC_DECL2(__VA_ARGS__)
+#define __SC_DECL4(t4, a4, ...) t4 a4, __SC_DECL3(__VA_ARGS__)
+#define __SC_DECL5(t5, a5, ...) t5 a5, __SC_DECL4(__VA_ARGS__)
+#define __SC_DECL6(t6, a6, ...) t6 a6, __SC_DECL5(__VA_ARGS__)
+
+#define __SC_LONG1(t1, a1) 	long a1
+#define __SC_LONG2(t2, a2, ...) long a2, __SC_LONG1(__VA_ARGS__)
+#define __SC_LONG3(t3, a3, ...) long a3, __SC_LONG2(__VA_ARGS__)
+#define __SC_LONG4(t4, a4, ...) long a4, __SC_LONG3(__VA_ARGS__)
+#define __SC_LONG5(t5, a5, ...) long a5, __SC_LONG4(__VA_ARGS__)
+#define __SC_LONG6(t6, a6, ...) long a6, __SC_LONG5(__VA_ARGS__)
+
+#define __SC_CAST1(t1, a1)	(t1) a1
+#define __SC_CAST2(t2, a2, ...) (t2) a2, __SC_CAST1(__VA_ARGS__)
+#define __SC_CAST3(t3, a3, ...) (t3) a3, __SC_CAST2(__VA_ARGS__)
+#define __SC_CAST4(t4, a4, ...) (t4) a4, __SC_CAST3(__VA_ARGS__)
+#define __SC_CAST5(t5, a5, ...) (t5) a5, __SC_CAST4(__VA_ARGS__)
+#define __SC_CAST6(t6, a6, ...) (t6) a6, __SC_CAST5(__VA_ARGS__)
+
+#define __SC_TEST(type)		BUILD_BUG_ON(sizeof(type) > sizeof(long))
+#define __SC_TEST1(t1, a1)	__SC_TEST(t1)
+#define __SC_TEST2(t2, a2, ...)	__SC_TEST(t2); __SC_TEST1(__VA_ARGS__)
+#define __SC_TEST3(t3, a3, ...)	__SC_TEST(t3); __SC_TEST2(__VA_ARGS__)
+#define __SC_TEST4(t4, a4, ...)	__SC_TEST(t4); __SC_TEST3(__VA_ARGS__)
+#define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
+#define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
+
+#define SYSCALL_DEFINE0(name)   asmlinkage long sys_##name(void)
+#define SYSCALL_DEFINE1(...)    SYSCALL_DEFINEx(1, __VA_ARGS__)
+#define SYSCALL_DEFINE2(...)    SYSCALL_DEFINEx(2, __VA_ARGS__)
+#define SYSCALL_DEFINE3(...)    SYSCALL_DEFINEx(3, __VA_ARGS__)
+#define SYSCALL_DEFINE4(...)    SYSCALL_DEFINEx(4, __VA_ARGS__)
+#define SYSCALL_DEFINE5(...)    SYSCALL_DEFINEx(5, __VA_ARGS__)
+#define SYSCALL_DEFINE6(...)    SYSCALL_DEFINEx(6, __VA_ARGS__)
+
+#define SYSCALL_ALIAS(alias, name)					\
+	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name)
+
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+
+#define SYSCALL_DEFINE(name) static inline long SYSC_##name
+#define SYSCALL_DEFINEx(x, name, ...)					\
+	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));		\
+	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));	\
+	asmlinkage long SyS_##name(__SC_LONG##x(__VA_ARGS__))		\
+	{								\
+		__SC_TEST##x(__VA_ARGS__);				\
+		return (long) SYSC_##name(__SC_CAST##x(__VA_ARGS__));	\
+	}								\
+	SYSCALL_ALIAS(sys_##name, SyS_##name);				\
+	static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))
+
+#else /* CONFIG_HAVE_SYSCALL_WRAPPERS */
+
+#define SYSCALL_DEFINE(name) asmlinkage long sys_##name
+#define SYSCALL_DEFINEx(x, name, ...)					\
+	asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__))
+
+#endif /* CONFIG_HAVE_SYSCALL_WRAPPERS */
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,

