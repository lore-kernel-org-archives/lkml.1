Return-Path: <linux-kernel-owner+w=401wt.eu-S1763754AbYBWIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763754AbYBWIb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936900AbYBWIUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:20:24 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936151AbYBWIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:20:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jUhZ45hDrkyHlLsqLgVslG7njKsfY+Aq4OISh+mMznwvnIwmmhv2YCB3fiwIPjmwKTqNdxr06NwxObkTYK0G1FjCnGRtVZQAj464gwp6LTiycbKtYY1hAGFxa6yUlqpdXK6kgesQ95iO4JzN1OkBYlPGiEZBPCRq1rWY1gOG5hM=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       David Miller <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, sparclinux@vger.kernel.org
Subject: [PATCH 06/16] sparc(64): use get_personality()
Date: Sat, 23 Feb 2008 16:14:09 +0800
Message-Id: <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro and other two tiny improvements.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: William L. Irwin <wli@holomorphy.com>
Cc: sparclinux@vger.kernel.org

---
 arch/sparc/kernel/signal.c      |    2 +-
 arch/sparc64/kernel/signal32.c  |    2 +-
 arch/sparc64/kernel/sys_sparc.c |    6 +++---
 include/asm-sparc/namei.h       |    2 +-
 include/asm-sparc64/elf.h       |    2 +-
 include/asm-sparc64/namei.h     |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/kernel/signal.c b/arch/sparc/kernel/signal.c
index 9994cac..0464874 100644
--- a/arch/sparc/kernel/signal.c
+++ b/arch/sparc/kernel/signal.c
@@ -1010,7 +1010,7 @@ asmlinkage void do_signal(struct pt_regs * regs, unsigned long orig_i0, int rest
 #ifdef SVR4_SIGNAL_BROKEN
 	int svr4_signal = 0;
 #else
-	int svr4_signal = current->personality == PER_SVR4;
+	int svr4_signal = (get_personality() == PER_SVR4);
 #endif
 
 	cookie.restart_syscall = restart_syscall;
diff --git a/arch/sparc64/kernel/signal32.c b/arch/sparc64/kernel/signal32.c
index 8c1c121..e3bc993 100644
--- a/arch/sparc64/kernel/signal32.c
+++ b/arch/sparc64/kernel/signal32.c
@@ -1270,7 +1270,7 @@ void do_signal32(sigset_t *oldset, struct pt_regs * regs,
 	struct signal_deliver_cookie cookie;
 	struct k_sigaction ka;
 	int signr;
-	int svr4_signal = current->personality == PER_SVR4;
+	int svr4_signal = (get_personality() == PER_SVR4);
 	
 	cookie.restart_syscall = restart_syscall;
 	cookie.orig_i0 = orig_i0;
diff --git a/arch/sparc64/kernel/sys_sparc.c b/arch/sparc64/kernel/sys_sparc.c
index 134d801..3813ec7 100644
--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -372,7 +372,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
 	if (!test_thread_flag(TIF_32BIT) ||
-	    (current->personality & ADDR_COMPAT_LAYOUT) ||
+	    (get_personality() & ADDR_COMPAT_LAYOUT) ||
 	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY ||
 	    sysctl_legacy_va_layout) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
@@ -518,7 +518,7 @@ asmlinkage long sparc64_newuname(struct new_utsname __user *name)
 {
 	int ret = sys_newuname(name);
 	
-	if (current->personality == PER_LINUX32 && !ret) {
+	if (get_personality() == PER_LINUX32 && !ret) {
 		ret = (copy_to_user(name->machine, "sparc\0\0", 8)
 		       ? -EFAULT : 0);
 	}
@@ -529,7 +529,7 @@ asmlinkage long sparc64_personality(unsigned long personality)
 {
 	int ret;
 
-	if (current->personality == PER_LINUX32 &&
+	if (get_personality() == PER_LINUX32 &&
 	    personality == PER_LINUX)
 		personality = PER_LINUX32;
 	ret = sys_personality(personality);
diff --git a/include/asm-sparc/namei.h b/include/asm-sparc/namei.h
index f2461e8..b87f621 100644
--- a/include/asm-sparc/namei.h
+++ b/include/asm-sparc/namei.h
@@ -13,7 +13,7 @@
 
 static inline char * __emul_prefix(void)
 {
-	switch (current->personality) {
+	switch (get_personality()) {
 	case PER_SUNOS:
 		return SPARC_BSD_EMUL;
 	case PER_SVR4:
diff --git a/include/asm-sparc64/elf.h b/include/asm-sparc64/elf.h
index 11c8e68..2140dbe 100644
--- a/include/asm-sparc64/elf.h
+++ b/include/asm-sparc64/elf.h
@@ -211,7 +211,7 @@ do {	unsigned long new_flags = current_thread_info()->flags; \
 	/* flush_thread will update pgd cache */	\
 	if (ibcs2)					\
 		set_personality(PER_SVR4);		\
-	else if (current->personality != PER_LINUX32)	\
+	else if (get_personality() != PER_LINUX32)	\
 		set_personality(PER_LINUX);		\
 } while (0)
 
diff --git a/include/asm-sparc64/namei.h b/include/asm-sparc64/namei.h
index ccda19e..e6a1dd9 100644
--- a/include/asm-sparc64/namei.h
+++ b/include/asm-sparc64/namei.h
@@ -13,7 +13,7 @@
 
 static inline char * __emul_prefix(void)
 {
-	switch (current->personality) {
+	switch (get_personality()) {
 	case PER_SUNOS:
 		return SPARC_BSD_EMUL;
 	case PER_SVR4:
-- 
1.5.3.8

