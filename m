Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYABNdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYABNdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYABNdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:33:38 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:26158 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYABNdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:33:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uCrUIpvY+RnfEyNbleCRqy/x6X4gulM6kEEay0BLDMH7iFWC6Zlln3KpQtRrivSpGJ5aY+/CKHzvSNHWLMoCOnjEq2B3R5L3m+2di8gIfKtmkPnrPmjBFLBiQR73c4fvfEl0XVf+zqzgQA4YdJfp9fd7wUDEzHkShxi0MILYWp4=
Subject: [PATCH] x86: introduce force_sig_info_fault helper to X86_64
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 05:33:35 -0800
Message-Id: <1199280815.6323.68.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the force_sig_info_fault helper from X86_32 in X86_64.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |    2 +-
 arch/x86/mm/fault_64.c |   31 ++++++++++++++++++-------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 300c9d8..b1893eb 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -249,7 +249,7 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	return prefetch;
 }
 
-static noinline void force_sig_info_fault(int si_signo, int si_code,
+static void force_sig_info_fault(int si_signo, int si_code,
 	unsigned long address, struct task_struct *tsk)
 {
 	siginfo_t info;
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index dd41793..357a3e0 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -252,6 +252,18 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	return prefetch;
 }
 
+static void force_sig_info_fault(int si_signo, int si_code,
+	unsigned long address, struct task_struct *tsk)
+{
+	siginfo_t info;
+
+	info.si_signo = si_signo;
+	info.si_errno = 0;
+	info.si_code = si_code;
+	info.si_addr = (void __user *)address;
+	force_sig_info(si_signo, &info, tsk);
+}
+
 static int bad_address(void *p)
 {
 	unsigned long dummy;
@@ -415,7 +427,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	unsigned long address;
 	int write, fault;
 	unsigned long flags;
-	siginfo_t info;
+	int si_code;
 
 	/*
 	 * We can fault from pretty much anywhere, with unknown IRQ state.
@@ -429,7 +441,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	/* get the address */
 	address = read_cr2();
 
-	info.si_code = SEGV_MAPERR;
+	si_code = SEGV_MAPERR;
 
 
 	/*
@@ -532,7 +544,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
  * we can handle it..
  */
 good_area:
-	info.si_code = SEGV_ACCERR;
+	si_code = SEGV_ACCERR;
 	write = 0;
 	switch (error_code & (PF_PROT|PF_WRITE)) {
 	default:	/* 3: write, present */
@@ -611,11 +623,8 @@ bad_area_nosemaphore:
 		/* Kernel addresses are always protection faults */
 		tsk->thread.error_code = error_code | (address >= TASK_SIZE);
 		tsk->thread.trap_no = 14;
-		info.si_signo = SIGSEGV;
-		info.si_errno = 0;
-		/* info.si_code has been set above */
-		info.si_addr = (void __user *)address;
-		force_sig_info(SIGSEGV, &info, tsk);
+
+		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
 		return;
 	}
 
@@ -682,11 +691,7 @@ do_sigbus:
 	tsk->thread.cr2 = address;
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = 14;
-	info.si_signo = SIGBUS;
-	info.si_errno = 0;
-	info.si_code = BUS_ADRERR;
-	info.si_addr = (void __user *)address;
-	force_sig_info(SIGBUS, &info, tsk);
+	force_sig_info_fault(SIGBUS, BUS_ADRERR, address, tsk);
 	return;
 }
 
-- 
1.5.4.rc2.1097.gb6e0d



