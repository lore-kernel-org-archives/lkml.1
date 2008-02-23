Return-Path: <linux-kernel-owner+w=401wt.eu-S935173AbYBWIfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173AbYBWIfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936303AbYBWIVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:21:09 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934249AbYBWIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qnvl5Rg8+sClAhRJpkv9XmRLywtyFT5jREFdZVuo8sUXQnPWgybAjAC19eUF0UJ/1DlsjS2EIzKJYgR8L3RIPVyWglBjJaw+1VpnUZkcbuiQVpFPgZmMRu7q3Z4dVs2RJq8YOa+aQW6Z/FGDMo0wvE1IjMyDLNIDjDKKUytIdhk=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 11/16] mips: use get_personality()
Date: Sat, 23 Feb 2008 16:14:14 +0800
Message-Id: <1203754571655-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037545611159-git-send-email-xiyou.wangcong@gmail.com>
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
 <12037545611159-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for mips code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc:  Ralf Baechle <ralf@linux-mips.org>

---
 arch/mips/kernel/linux32.c |    4 ++--
 arch/mips/kernel/process.c |    4 ++--
 include/asm-mips/elf.h     |    2 +-
 include/asm-mips/namei.h   |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 65af3cc..e5b7671 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -446,7 +446,7 @@ asmlinkage long sys32_newuname(struct new_utsname __user * name)
 		ret = -EFAULT;
 	up_read(&uts_sem);
 
-	if (current->personality == PER_LINUX32 && !ret)
+	if (get_personality() == PER_LINUX32 && !ret)
 		if (copy_to_user(name->machine, "mips\0\0\0", 8))
 			ret = -EFAULT;
 
@@ -457,7 +457,7 @@ asmlinkage int sys32_personality(unsigned long personality)
 {
 	int ret;
 	personality &= 0xffffffff;
-	if (personality(current->personality) == PER_LINUX32 &&
+	if (personality(get_personality()) == PER_LINUX32 &&
 	    personality == PER_LINUX)
 		personality = PER_LINUX32;
 	ret = sys_personality(personality);
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 2c09a44..dc7486c 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -126,7 +126,7 @@ int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
 	childregs->regs[7] = 0;	/* Clear error flag */
 
 #if defined(CONFIG_BINFMT_IRIX)
-	if (current->personality != PER_LINUX) {
+	if (get_personality() != PER_LINUX) {
 		/* Under IRIX things are a little different. */
 		childregs->regs[3] = 1;
 		regs->regs[3] = 0;
@@ -471,7 +471,7 @@ out:
  */
 unsigned long arch_align_stack(unsigned long sp)
 {
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+	if (!(get_personality() & ADDR_NO_RANDOMIZE) && randomize_va_space)
 		sp -= get_random_int() & ~PAGE_MASK;
 
 	return sp & ALMASK;
diff --git a/include/asm-mips/elf.h b/include/asm-mips/elf.h
index f69f7ac..c07f464 100644
--- a/include/asm-mips/elf.h
+++ b/include/asm-mips/elf.h
@@ -308,7 +308,7 @@ do {									\
 									\
 	if (ibcs2)							\
 		set_personality(PER_SVR4);				\
-	else if (current->personality != PER_LINUX32)			\
+	else if (get_personality() != PER_LINUX32)			\
 		set_personality(PER_LINUX);				\
 } while (0)
 
diff --git a/include/asm-mips/namei.h b/include/asm-mips/namei.h
index c94d12d..18ab9eb 100644
--- a/include/asm-mips/namei.h
+++ b/include/asm-mips/namei.h
@@ -9,7 +9,7 @@
 
 static inline char *__emul_prefix(void)
 {
-	switch (current->personality) {
+	switch (get_personality()) {
 	case PER_IRIX32:
 	case PER_IRIXN32:
 	case PER_IRIX64:
-- 
1.5.3.8

