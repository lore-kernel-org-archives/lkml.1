Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZECX3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZECX3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZECX31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:29:27 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36234 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbZECX30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JL5lakwklwYdzRxjh6trirgSYCyZb8TSX1W3uL+h6kVph0I8mRPX37nMZCCd9i03PP
         Jz1HjiEcpTjz8wbnpl6SliEbiFighDFj5l/Fr/+MAwAZK9fh3zd04MMg4GOgYRIuJr81
         bkHnrPOtq1O/Jzmocm4DfIcmA+rFDfSZZkEHY=
Date: Mon, 4 May 2009 03:30:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH] x86_64: ifdef out struct thread_struct::ip
Message-ID: <20090503233015.GJ16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
index eedfaeb..d07706f 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -141,7 +141,7 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	gdb_regs32[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
 	gdb_regs32[GDB_CS]	= __KERNEL_CS;
 	gdb_regs32[GDB_SS]	= __KERNEL_DS;
-	gdb_regs[GDB_PC]	= p->thread.ip;
+	gdb_regs[GDB_PC]	= 0;
 	gdb_regs[GDB_R8]	= 0;
 	gdb_regs[GDB_R9]	= 0;
 	gdb_regs[GDB_R10]	= 0;
