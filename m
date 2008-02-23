Return-Path: <linux-kernel-owner+w=401wt.eu-S965129AbYBWIaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965129AbYBWIaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934612AbYBWITs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:19:48 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:40294 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935444AbYBWITq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:19:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KUyKrrfaHY++PshQ4dbgXedowcEwzFCF972CyA4HVvDCm+Ly0nPltUY26PftsolWbRIOrPSYnj1eMQrOvv92fmc7doyvIg0PRM0awMj1Cb0xToNXm+3MP2j9P7ogB8fE0RCaUCNxAGqbvvFnHwwFbOfj0p/+FyE4dhxAflpjwWY=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 03/16] fs: use get_personality()
Date: Sat, 23 Feb 2008 16:14:06 +0800
Message-Id: <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
 fs/binfmt_elf.c |    6 +++---
 fs/compat.c     |    6 +++---
 fs/select.c     |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 41a958a..1b5803f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -516,7 +516,7 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
 	unsigned int random_variable = 0;
 
 	if ((current->flags & PF_RANDOMIZE) &&
-		!(current->personality & ADDR_NO_RANDOMIZE)) {
+		!(get_personality() & ADDR_NO_RANDOMIZE)) {
 		random_variable = get_random_int() & STACK_RND_MASK;
 		random_variable <<= PAGE_SHIFT;
 	}
@@ -744,7 +744,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (elf_read_implies_exec(loc->elf_ex, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+	if (!(get_personality() & ADDR_NO_RANDOMIZE) && randomize_va_space)
 		current->flags |= PF_RANDOMIZE;
 	arch_pick_mmap_layout(current->mm);
 
@@ -969,7 +969,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			arch_randomize_brk(current->mm);
 #endif
 
-	if (current->personality & MMAP_PAGE_ZERO) {
+	if (get_personality() & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.
 		   Since we do not have the power to recompile these, we
diff --git a/fs/compat.c b/fs/compat.c
index 2ce4456..eefe23b 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1610,7 +1610,7 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 	if (tvp) {
 		struct compat_timeval rtv;
 
-		if (current->personality & STICKY_TIMEOUTS)
+		if (get_personality() & STICKY_TIMEOUTS)
 			goto sticky;
 		rtv.tv_usec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ));
 		rtv.tv_sec = timeout;
@@ -1685,7 +1685,7 @@ asmlinkage long compat_sys_pselect7(int n, compat_ulong_t __user *inp,
 	if (tsp) {
 		struct compat_timespec rts;
 
-		if (current->personality & STICKY_TIMEOUTS)
+		if (get_personality() & STICKY_TIMEOUTS)
 			goto sticky;
 
 		rts.tv_sec = timeout / HZ;
@@ -1800,7 +1800,7 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 	if (tsp && timeout >= 0) {
 		struct compat_timespec rts;
 
-		if (current->personality & STICKY_TIMEOUTS)
+		if (get_personality() & STICKY_TIMEOUTS)
 			goto sticky;
 		/* Yes, we know it's actually an s64, but it's also positive. */
 		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
diff --git a/fs/select.c b/fs/select.c
index 5633fe9..6041e24 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -401,7 +401,7 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 	if (tvp) {
 		struct timeval rtv;
 
-		if (current->personality & STICKY_TIMEOUTS)
+		if (get_personality() & STICKY_TIMEOUTS)
 			goto sticky;
 		rtv.tv_usec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ));
 		rtv.tv_sec = timeout;
@@ -467,7 +467,7 @@ asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
 	if (tsp) {
 		struct timespec rts;
 
-		if (current->personality & STICKY_TIMEOUTS)
+		if (get_personality() & STICKY_TIMEOUTS)
 			goto sticky;
 		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
 						1000;
@@ -814,7 +814,7 @@ asmlinkage long sys_ppoll(struct pollfd __user *ufds, unsigned int nfds,
 	if (tsp && timeout >= 0) {
 		struct timespec rts;
 
-		if (current->personality & STICKY_TIMEOUTS)
+		if (get_personality() & STICKY_TIMEOUTS)
 			goto sticky;
 		/* Yes, we know it's actually an s64, but it's also positive. */
 		rts.tv_nsec = jiffies_to_usecs(do_div((*(u64*)&timeout), HZ)) *
-- 
1.5.3.8

