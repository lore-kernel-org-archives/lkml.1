Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZETXS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZETXS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbZETXSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39815 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756058AbZETXSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:10 -0400
X-Sasl-enc: 655q9LCmh8ne9VR6eqOuoP3g/ZUHLo+8bU0yD77Nl5zL 1242861490
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: get rid of resume_userspace_sig define
Date: Thu, 21 May 2009 01:17:59 +0200
Message-Id: <1242861486-7255-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resume_userspace_sig is defined to check_userspace or resume_userspace
depending on CONFIG_VM86. It's used only two times, and once inside
code conditionally compiled depending on CONFIG_VM86. Duplicating two
trivial lines leaves a single #ifdef/#else block and removes the need
for redefining labels. Inverting a branch and getting rid of some real
code duplication removes a few bytes from the object file.

before, CONFIG_VM86=y
---------------------
c1008749 <work_notifysig>:
c1008749:       f7 44 24 38 00 00 02    testl  $0x20000,0x38(%esp)
c1008750:       00
c1008751:       89 e0                   mov    %esp,%eax
c1008753:       75 0f                   jne    c1008764 <work_notifysig_v86>
c1008755:       31 d2                   xor    %edx,%edx
c1008757:       e8 34 f0 ff ff          call   c1007790 <do_notify_resume>
c100875c:       e9 89 fd ff ff          jmp    c10084ea <check_userspace>
c1008761:       8d 76 00                lea    0x0(%esi),%esi
c1008764 <work_notifysig_v86>:
c1008764:       51                      push   %ecx
c1008765:       e8 76 69 01 00          call   c101f0e0 <save_v86_state>
c100876a:       59                      pop    %ecx
c100876b:       89 c4                   mov    %eax,%esp
c100876d:       31 d2                   xor    %edx,%edx
c100876f:       e8 1c f0 ff ff          call   c1007790 <do_notify_resume>
c1008774:       e9 71 fd ff ff          jmp    c10084ea <check_userspace>

after, CONFIG_VM86=y
--------------------
c1008749 <work_notifysig>:
c1008749:       f7 44 24 38 00 00 02    testl  $0x20000,0x38(%esp)
c1008750:       00
c1008751:       89 e0                   mov    %esp,%eax
c1008753:       74 09                   je     c100875e <no_work_notifysig_v86>
c1008755:       51                      push   %ecx
c1008756:       e8 65 69 01 00          call   c101f0c0 <save_v86_state>
c100875b:       59                      pop    %ecx
c100875c:       89 c4                   mov    %eax,%esp
c100875e <no_work_notifysig_v86>:
c100875e:       31 d2                   xor    %edx,%edx
c1008760:       e8 2b f0 ff ff          call   c1007790 <do_notify_resume>
c1008765:       e9 80 fd ff ff          jmp    c10084ea <check_userspace>

before, CONFIG_VM86=n
---------------------
c1008729 <work_notifysig>:
c1008729:       89 e0                   mov    %esp,%eax
c100872b:       31 d2                   xor    %edx,%edx
c100872d:       e8 3e f0 ff ff          call   c1007770 <do_notify_resume>
c1008732:       e9 a9 fd ff ff          jmp    c10084e0 <resume_userspace>

after, CONFIG_VM86=n (i.e., no change)
--------------------------------------
c1008729:       89 e0                   mov    %esp,%eax
c100872b:       31 d2                   xor    %edx,%edx
c100872d:       e8 3e f0 ff ff          call   c1007770 <do_notify_resume>
c1008732:       e9 a9 fd ff ff          jmp    c10084e0 <resume_userspace>

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c929add..314563e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -96,12 +96,6 @@
 #endif
 .endm
 
-#ifdef CONFIG_VM86
-#define resume_userspace_sig	check_userspace
-#else
-#define resume_userspace_sig	resume_userspace
-#endif
-
 /*
  * User gs save/restore
  *
@@ -634,26 +628,24 @@ work_notifysig:				# deal with pending signals and
 #ifdef CONFIG_VM86
 	testl $X86_EFLAGS_VM, PT_EFLAGS(%esp)
 	movl %esp, %eax
-	jne work_notifysig_v86		# returning to kernel-space or
+	je no_work_notifysig_v86	# returning to kernel-space or
 					# vm86-space
-	xorl %edx, %edx
-	call do_notify_resume
-	jmp resume_userspace_sig
-
-	ALIGN
-work_notifysig_v86:
 	pushl %ecx			# save ti_flags for do_notify_resume
 	CFI_ADJUST_CFA_OFFSET 4
 	call save_v86_state		# %eax contains pt_regs pointer
 	popl %ecx
 	CFI_ADJUST_CFA_OFFSET -4
 	movl %eax, %esp
+no_work_notifysig_v86:
+	xorl %edx, %edx			# %eax contains pt_regs pointer
+	call do_notify_resume
+	jmp check_userspace
 #else
 	movl %esp, %eax
-#endif
 	xorl %edx, %edx
 	call do_notify_resume
-	jmp resume_userspace_sig
+	jmp resume_userspace
+#endif
 END(work_pending)
 
 	# perform syscall exit tracing
-- 
1.6.0.4

