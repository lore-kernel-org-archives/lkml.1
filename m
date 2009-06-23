Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbZFWPVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbZFWPVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759766AbZFWPVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:21:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283AbZFWPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:21:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] asm-generic fixes
Date: Tue, 23 Jun 2009 17:20:35 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906231720.38105.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/khPdkt8QPyzZjGbadrzgmyJXlce4GN7OlNRJ
 oGHKDINQplmlV+Aj9w7zDSSeT5v8VLu4+QPY8ANuRN/gNJOxTJ
 zU0AbFMShq+Uq12NyF4J53+E0XlVYkO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this set of fixes for include/asm-generic and
the checksum code from

git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/asm-generic.git for-linus

---
Arnd Bergmann (4):
  asm-generic: drop HARDIRQ_BITS definition from hardirq.h
  asm-generic: list Arnd as asm-generic maintainer
  asm-generic: hook up new system calls
  lib/checksum.c: fix endianess bug

Mike Frysinger (2):
  asm-generic: uaccess: add missing access_ok() check to strnlen_user()
  asm-generic: uaccess: fix up local access_ok() usage

Paul Mundt (1):
  asm-generic: add dummy pgprot_noncached()

 MAINTAINERS                   |    8 ++++++++
 include/asm-generic/hardirq.h |   13 -------------
 include/asm-generic/pgtable.h |    4 ++++
 include/asm-generic/uaccess.h |   14 ++++++++------
 include/asm-generic/unistd.h  |    7 ++++++-
 lib/checksum.c                |   10 +++++++++-
 6 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 02f6f78..b85cf35 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2482,6 +2482,14 @@ F:	drivers/net/wan/pc300too.c
 F:	drivers/net/wan/pci200syn.c
 F:	drivers/net/wan/wanxl*
 
+GENERIC INCLUDE/ASM HEADER FILES
+P:	Arnd Bergmann
+M:	arnd@arndb.de
+L:	linux-arch@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
+S:	Maintained
+F:	include/asm-generic
+
 GFS2 FILE SYSTEM
 P:	Steven Whitehouse
 M:	swhiteho@redhat.com
diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 3d5d2c9..23bb4da 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -11,19 +11,6 @@ typedef struct {
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
-#ifndef HARDIRQ_BITS
-#define HARDIRQ_BITS	8
-#endif
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #ifndef ack_bad_irq
 static inline void ack_bad_irq(unsigned int irq)
 {
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index e410f60..e2bd73e 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -129,6 +129,10 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 #define move_pte(pte, prot, old_addr, new_addr)	(pte)
 #endif
 
+#ifndef pgprot_noncached
+#define pgprot_noncached(prot)	(prot)
+#endif
+
 #ifndef pgprot_writecombine
 #define pgprot_writecombine pgprot_noncached
 #endif
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index 6d8cab2..b218b85 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -163,7 +163,7 @@ static inline __must_check long __copy_to_user(void __user *to,
 #define put_user(x, ptr)					\
 ({								\
 	might_sleep();						\
-	__access_ok(ptr, sizeof (*ptr)) ?			\
+	access_ok(VERIFY_WRITE, ptr, sizeof(*ptr)) ?		\
 		__put_user(x, ptr) :				\
 		-EFAULT;					\
 })
@@ -219,7 +219,7 @@ extern int __put_user_bad(void) __attribute__((noreturn));
 #define get_user(x, ptr)					\
 ({								\
 	might_sleep();						\
-	__access_ok(ptr, sizeof (*ptr)) ?			\
+	access_ok(VERIFY_READ, ptr, sizeof(*ptr)) ?		\
 		__get_user(x, ptr) :				\
 		-EFAULT;					\
 })
@@ -244,7 +244,7 @@ static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
 	might_sleep();
-	if (__access_ok(from, n))
+	if (access_ok(VERIFY_READ, from, n))
 		return __copy_from_user(to, from, n);
 	else
 		return n;
@@ -254,7 +254,7 @@ static inline long copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
 	might_sleep();
-	if (__access_ok(to, n))
+	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_to_user(to, from, n);
 	else
 		return n;
@@ -278,7 +278,7 @@ __strncpy_from_user(char *dst, const char __user *src, long count)
 static inline long
 strncpy_from_user(char *dst, const char __user *src, long count)
 {
-	if (!__access_ok(src, 1))
+	if (!access_ok(VERIFY_READ, src, 1))
 		return -EFAULT;
 	return __strncpy_from_user(dst, src, count);
 }
@@ -291,6 +291,8 @@ strncpy_from_user(char *dst, const char __user *src, long count)
 #ifndef strnlen_user
 static inline long strnlen_user(const char __user *src, long n)
 {
+	if (!access_ok(VERIFY_READ, src, 1))
+		return 0;
 	return strlen((void * __force)src) + 1;
 }
 #endif
@@ -316,7 +318,7 @@ static inline __must_check unsigned long
 clear_user(void __user *to, unsigned long n)
 {
 	might_sleep();
-	if (!__access_ok(to, n))
+	if (!access_ok(VERIFY_WRITE, to, n))
 		return n;
 
 	return __clear_user(to, n);
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 5b34b62..1125e5a 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -618,8 +618,13 @@ __SYSCALL(__NR_migrate_pages, sys_migrate_pages)
 __SYSCALL(__NR_move_pages, sys_move_pages)
 #endif
 
+#define __NR_rt_tgsigqueueinfo 240
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
+#define __NR_perf_counter_open 241
+__SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
+
 #undef __NR_syscalls
-#define __NR_syscalls 240
+#define __NR_syscalls 242
 
 /*
  * All syscalls below here should go away really,
diff --git a/lib/checksum.c b/lib/checksum.c
index 12e5a1c..b2e2fd4 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -55,7 +55,11 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		goto out;
 	odd = 1 & (unsigned long) buff;
 	if (odd) {
+#ifdef __LITTLE_ENDIAN
 		result = *buff;
+#else
+		result += (*buff << 8);
+#endif
 		len--;
 		buff++;
 	}
@@ -71,7 +75,7 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		if (count) {
 			unsigned long carry = 0;
 			do {
-				unsigned long w = *(unsigned long *) buff;
+				unsigned long w = *(unsigned int *) buff;
 				count--;
 				buff += 4;
 				result += carry;
@@ -87,7 +91,11 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 		}
 	}
 	if (len & 1)
+#ifdef __LITTLE_ENDIAN
+		result += *buff;
+#else
 		result += (*buff << 8);
+#endif
 	result = from32to16(result);
 	if (odd)
 		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
