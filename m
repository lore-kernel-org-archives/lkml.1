Return-Path: <linux-kernel-owner+w=401wt.eu-S937670AbYBWIez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937670AbYBWIez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764685AbYBWIVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:21:00 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935323AbYBWIU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:20:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nMB1Wc7TETh4/ywtAxqOb9iNoCDwmdJV3MJijXZONSA/Y6d7JTc/hCimu+FvdB/hCYD4xjwkNHXxNESJCuTNrgaKKXRFkbouNk5+g4bgY+cqoFZtyVgQuirW4J1+6dPAvVrPq6rLPUq/tpfRT8lge2LiZGhSGkwe61jWi8EF1r0=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [PATCH 10/16] s390: use get_personality()
Date: Sat, 23 Feb 2008 16:14:13 +0800
Message-Id: <12037545611159-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037545522455-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
 <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
 <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
 <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
 <12037545522455-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for s390 code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: schwidefsky@de.ibm.com
Cc: heiko.carstens@de.ibm.com

---
 arch/s390/kernel/binfmt_elf32.c |    2 +-
 arch/s390/kernel/sys_s390.c     |    4 ++--
 arch/s390/mm/mmap.c             |    2 +-
 include/asm-s390/elf.h          |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/binfmt_elf32.c b/arch/s390/kernel/binfmt_elf32.c
index 3e1c315..6a55911 100644
--- a/arch/s390/kernel/binfmt_elf32.c
+++ b/arch/s390/kernel/binfmt_elf32.c
@@ -78,7 +78,7 @@
 do {							\
 	if (ibcs2)                                      \
 		set_personality(PER_SVR4);              \
-	else if (current->personality != PER_LINUX32)   \
+	else if (get_personality() != PER_LINUX32)   \
 		set_personality(PER_LINUX);             \
 	set_thread_flag(TIF_31BIT);			\
 } while (0)
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index fefee99..f8371fe 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -215,7 +215,7 @@ asmlinkage long s390x_newuname(struct new_utsname __user *name)
 {
 	int ret = sys_newuname(name);
 
-	if (current->personality == PER_LINUX32 && !ret) {
+	if (get_personality() == PER_LINUX32 && !ret) {
 		ret = copy_to_user(name->machine, "s390\0\0\0\0", 8);
 		if (ret) ret = -EFAULT;
 	}
@@ -226,7 +226,7 @@ asmlinkage long s390x_personality(unsigned long personality)
 {
 	int ret;
 
-	if (current->personality == PER_LINUX32 && personality == PER_LINUX)
+	if (get_personality() == PER_LINUX32 && personality == PER_LINUX)
 		personality = PER_LINUX32;
 	ret = sys_personality(personality);
 	if (ret == PER_LINUX32)
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 5932a82..f5bf304 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -59,7 +59,7 @@ static inline int mmap_is_legacy(void)
 		return 1;
 #endif
 	return sysctl_legacy_va_layout ||
-	    (current->personality & ADDR_COMPAT_LAYOUT) ||
+	    (get_personality() & ADDR_COMPAT_LAYOUT) ||
 	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY;
 }
 
diff --git a/include/asm-s390/elf.h b/include/asm-s390/elf.h
index b3ac262..18482d3 100644
--- a/include/asm-s390/elf.h
+++ b/include/asm-s390/elf.h
@@ -202,7 +202,7 @@ extern char elf_platform[];
 do {							\
 	if (ibcs2)					\
 		set_personality(PER_SVR4);		\
-	else if (current->personality != PER_LINUX32)	\
+	else if (get_personality() != PER_LINUX32)	\
 		set_personality(PER_LINUX);		\
 	clear_thread_flag(TIF_31BIT);			\
 } while (0)
-- 
1.5.3.8

