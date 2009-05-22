Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZEVE6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZEVE6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZEVEzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:28780 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZEVEzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J1wmC8Diqoqx1v570urKoD7+kNZ4z+8MzuqS7CeDygrEiC9uzU1TW99KHmv+ASsiVs
         qLcyIv6UFRdSHTYkYO8ut/hq7QYvs8kJpzrx8KZE5YA3v4EAGeW2bvs8Z7bpltV1RuFs
         1Z/YSPBUxbsOlhJnsVVvpPoQKbxvx3gez/xU8=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 13/38] x86_64: ifdef out struct thread_struct::ip
Date: Fri, 22 May 2009 08:55:07 +0400
Message-Id: <1242968132-1044-13-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct thread_struct::ip isn't used on x86_64, struct pt_regs::ip is used
instead.

kgdb should be reading 0 always, but I can't check it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/kgdb.c           |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a6732ff..a9ba743 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -427,7 +427,9 @@ struct thread_struct {
 	unsigned short		fsindex;
 	unsigned short		gsindex;
 #endif
+#ifdef CONFIG_X86_32
 	unsigned long		ip;
+#endif
 #ifdef CONFIG_X86_64
 	unsigned long		fs;
 #endif
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index b1f4dff..8d82a77 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -142,7 +142,7 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	gdb_regs32[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
 	gdb_regs32[GDB_CS]	= __KERNEL_CS;
 	gdb_regs32[GDB_SS]	= __KERNEL_DS;
-	gdb_regs[GDB_PC]	= p->thread.ip;
+	gdb_regs[GDB_PC]	= 0;
 	gdb_regs[GDB_R8]	= 0;
 	gdb_regs[GDB_R9]	= 0;
 	gdb_regs[GDB_R10]	= 0;
-- 
1.5.6.5

