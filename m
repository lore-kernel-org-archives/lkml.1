Return-Path: <linux-kernel-owner+w=401wt.eu-S1764478AbYF0Viu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764478AbYF0Viu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764216AbYF0VhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761143AbYF0VhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:13 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 09/39] adapt x86_64 getuser functions
Date: Fri, 27 Jun 2008 18:34:16 -0300
Message-Id: <1214602486-17080-10-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-9-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of doing a sub after the addition, use the
offset directly at the memory operand of the mov instructions.
This is the way i386 do.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/getuser_64.S |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser_64.S
index 2b003d3..df37d3a 100644
--- a/arch/x86/lib/getuser_64.S
+++ b/arch/x86/lib/getuser_64.S
@@ -47,49 +47,40 @@ ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%rdx)
 	addq $1,%rax
-	jc 20f
+	jc bad_get_user
+	GET_THREAD_INFO(%rdx)
 	cmpq threadinfo_addr_limit(%rdx),%rax
-	jae 20f
-	decq   %rax
-2:	movzwl (%rax),%edx
+	jae bad_get_user
+2:	movzwl -1(%rax),%edx
 	xorl %eax,%eax
 	ret
-20:	decq    %rax
-	jmp	bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%rdx)
 	addq $3,%rax
-	jc 30f
+	jc bad_get_user
+	GET_THREAD_INFO(%rdx)
 	cmpq threadinfo_addr_limit(%rdx),%rax
-	jae 30f
-	subq $3,%rax
-3:	movl (%rax),%edx
+	jae bad_get_user
+3:	movl -3(%rax),%edx
 	xorl %eax,%eax
 	ret
-30:	subq $3,%rax
-	jmp bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_4)
 
 ENTRY(__get_user_8)
 	CFI_STARTPROC
-	GET_THREAD_INFO(%rdx)
 	addq $7,%rax
-	jc 40f
+	jc bad_get_user
+	GET_THREAD_INFO(%rdx)
 	cmpq threadinfo_addr_limit(%rdx),%rax
-	jae	40f
-	subq	$7,%rax
-4:	movq (%rax),%rdx
+	jae	bad_get_user
+4:	movq -7(%rax),%rdx
 	xorl %eax,%eax
 	ret
-40:	subq $7,%rax
-	jmp bad_get_user
 	CFI_ENDPROC
 ENDPROC(__get_user_8)
 
-- 
1.5.5.1

