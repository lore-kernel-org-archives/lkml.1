Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYKZTRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYKZTRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYKZTRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:17:11 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:27098 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYKZTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Di3XFd1PRTdneiQhavdKtt6Jeza5ZY7tyobfG3wpMaGU7KkpAWlFDcNGzUEUJyNqEf
         SQX8EqzcTgaeQPBBu+aYroCjY0F62bfrSjQUp8Ing4WO08UhWxp3GmQ40urupMzsAzLK
         LBWAxABCRQ2kylDelNOwYrDH0E2nqy4WegOZg=
From: gorcunov@gmail.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Date: Wed, 26 Nov 2008 22:17:01 +0300
Message-Id: <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.4.603.gbc9c0
In-Reply-To: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
In-Reply-To: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
References: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Impact: cleanup, microoptimization

Use straightforward jumping if possible, cpu like it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/entry_64.S |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 098ba0b..7b52b0f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -379,7 +379,10 @@ ENTRY(ret_from_fork)
 	GET_THREAD_INFO(%rcx)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
 	CFI_REMEMBER_STATE
-	jnz rff_trace
+	jz rff_action
+	movq %rsp,%rdi
+	call syscall_trace_leave
+	GET_THREAD_INFO(%rcx)
 rff_action:
 	RESTORE_REST
 	testl $3,CS-ARGOFFSET(%rsp)	# from kernel_thread?
@@ -389,11 +392,6 @@ rff_action:
 	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
 	jmp ret_from_sys_call
 	CFI_RESTORE_STATE
-rff_trace:
-	movq %rsp,%rdi
-	call syscall_trace_leave
-	GET_THREAD_INFO(%rcx)
-	jmp rff_action
 	CFI_ENDPROC
 END(ret_from_fork)
 
-- 
1.6.0.4.603.gbc9c0

