Return-Path: <linux-kernel-owner+w=401wt.eu-S937609AbYBWIdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937609AbYBWIdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936933AbYBWIU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:20:57 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936932AbYBWIUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OC8mHcmlPgRcoX124J7sEur8FPif7fFyTFk2VgP52xAK+I9+BJHQ1EiZB8gay9G0LQXZx3kNqLF/jTtwJY0QM7ZSwXxhxly6xAtkIEDIelKcDbD4Y5b4ssLzi4sGcxlKVFnRniZ7cDv/QQbWQM0maRHWPjx2qEiIPreisN7XRJ4=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 09/16] um: use get_personality()
Date: Sat, 23 Feb 2008 16:14:12 +0800
Message-Id: <12037545522455-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
 <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
 <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
 <12037545424136-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference for
uml code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
 arch/um/kernel/process.c       |    2 +-
 arch/um/sys-x86_64/syscalls.c  |    2 +-
 include/asm-um/vm-flags-i386.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index fc50d2f..91e0a84 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -405,7 +405,7 @@ int singlestepping(void * t)
 #ifndef arch_align_stack
 unsigned long arch_align_stack(unsigned long sp)
 {
-	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
+	if (!(get_personality() & ADDR_NO_RANDOMIZE) && randomize_va_space)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
diff --git a/arch/um/sys-x86_64/syscalls.c b/arch/um/sys-x86_64/syscalls.c
index f1199fd..cf7b61e 100644
--- a/arch/um/sys-x86_64/syscalls.c
+++ b/arch/um/sys-x86_64/syscalls.c
@@ -20,7 +20,7 @@ asmlinkage long sys_uname64(struct new_utsname __user * name)
 	err = copy_to_user(name, utsname(), sizeof (*name));
 	up_read(&uts_sem);
 
-	if (personality(current->personality) == PER_LINUX32)
+	if (personality(get_personality()) == PER_LINUX32)
 		err |= copy_to_user(&name->machine, "i686", 5);
 
 	return err ? -EFAULT : 0;
diff --git a/include/asm-um/vm-flags-i386.h b/include/asm-um/vm-flags-i386.h
index e0d24c5..c30e0f6 100644
--- a/include/asm-um/vm-flags-i386.h
+++ b/include/asm-um/vm-flags-i386.h
@@ -8,7 +8,7 @@
 
 #define VM_DATA_DEFAULT_FLAGS \
 	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+	((get_personality() & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #endif
-- 
1.5.3.8

