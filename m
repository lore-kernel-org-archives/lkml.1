Return-Path: <linux-kernel-owner+w=401wt.eu-S1750848AbXDDVAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848AbXDDVAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXDDVAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:00:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXDDVAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:00:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/3] utrace - uml: make UML compile with utrace enabled
In-Reply-To: Paolo 'Blaisorblade' Giarrusso's message of  Saturday, 31 March 2007 01:08:04 +0200 <20070330230804.19809.55294.stgit@americanbeauty.home.lan>
X-Windows: simplicity made complex.
Message-Id: <20070404210003.875C7180064@magilla.sf.frob.com>
Date: Wed,  4 Apr 2007 14:00:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Technically those two symbols should not be touched in
utrace-tracehook-um.patch at all, and patches are still entirely missing
for the CONFIG_PTRACE=y build to work.  I refrained from excising them from
the patch just to be anal since I didn't have Jeff's sign-off on that.
What I'd prefer is to remove utrace_native_view from the current patch and
leave it out until there is a utrace-reget-um.patch to define it for real.

I will change utrace-tracehook.patch so it does not call arch_ptrace.
Then there will be no need to leave a definition behind when it's an empty
stub like in utrace-tracehook-um.patch.  (The only reason I left
arch_ptrace code around after utrace-trachook.patch on the arch's ported
before was that it contained historical code that was not fully replaced
until the utrace-ptrace-compat.patch code, so it's a bit clearer when
reading one patch at a time.)

Here is what I'll merge into utrace-tracehook.patch now:

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -239,7 +239,8 @@ asmlinkage long sys_ptrace(long request,
 	if (ret < 0)
 		goto out_put_task_struct;
 
-	ret = arch_ptrace(child, request, addr, data);
+	/*ret = arch_ptrace(child, request, addr, data);*/
+	ret = -ENOSYS;
 	if (ret < 0)
 		goto out_put_task_struct;
 

Here is what I'd merge into utrace-tracehook-um.patch given Jeff's sign-off:

diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index f66d01c..0000000 100644  
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -16,11 +16,6 @@ void ptrace_disable(struct task_struct *
 { 
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
-{
-	return -ENOSYS;
-}
-
 static void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code)
 {
diff --git a/include/asm-um/tracehook.h b/include/asm-um/tracehook.h
index 5fc0d1a..0000000 100644  
--- a/include/asm-um/tracehook.h
+++ b/include/asm-um/tracehook.h
@@ -53,12 +53,5 @@ static inline void tracehook_abort_sysca
 	PT_REGS_SYSCALL_NR(regs) = -1;
 }
 
-extern const struct utrace_regset_view utrace_um_native;
-static inline const struct utrace_regset_view *
-utrace_native_view(struct task_struct *tsk)
-{
-	return &utrace_um_native;
-}
-
 
 #endif



Thanks,
Roland
