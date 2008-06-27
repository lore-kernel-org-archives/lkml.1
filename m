Return-Path: <linux-kernel-owner+w=401wt.eu-S1764979AbYF0Vod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764979AbYF0Vod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763848AbYF0Vhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764259AbYF0Vhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:43 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 19/39] change testing logic in putuser_64.S
Date: Fri, 27 Jun 2008 18:34:26 -0300
Message-Id: <1214602486-17080-20-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-19-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of operating over a register we need to put back
into normal state afterwards (the memory position), just
sub from rbx, which is trashed anyway. We can save a few instructions.

Also, this is the i386 way.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/putuser_64.S |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
index ce5fcd5..a96bd8a 100644
--- a/arch/x86/lib/putuser_64.S
+++ b/arch/x86/lib/putuser_64.S
@@ -46,48 +46,39 @@ ENDPROC(__put_user_1)
 ENTRY(__put_user_2)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rbx)
-	addq $1,%rcx
-	jc 20f
-	cmpq TI_addr_limit(%rbx),%rcx
-	jae 20f
-	decq %rcx
+	mov TI_addr_limit(%rbx),%rbx
+	sub  $1, %rbx
+	cmpq %rbx ,%rcx
+	jae  bad_put_user
 2:	movw %ax,(%rcx)
 	xorl %eax,%eax
 	ret
-20:	decq %rcx
-	jmp bad_put_user
 	CFI_ENDPROC
 ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rbx)
-	addq $3,%rcx
-	jc 30f
-	cmpq TI_addr_limit(%rbx),%rcx
-	jae 30f
-	subq $3,%rcx
+	mov TI_addr_limit(%rbx),%rbx
+	sub  $3, %rbx
+	cmp  %rbx, %rcx
+	jae bad_put_user
 3:	movl %eax,(%rcx)
 	xorl %eax,%eax
 	ret
-30:	subq $3,%rcx
-	jmp bad_put_user
 	CFI_ENDPROC
 ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rbx)
-	addq $7,%rcx
-	jc 40f
-	cmpq TI_addr_limit(%rbx),%rcx
-	jae 40f
-	subq $7,%rcx
+	mov TI_addr_limit(%rbx),%rbx
+	sub  $7, %rbx
+	cmp  %rbx, %rcx
+	jae bad_put_user
 4:	movq %rax,(%rcx)
 	xorl %eax,%eax
 	ret
-40:	subq $7,%rcx
-	jmp bad_put_user
 	CFI_ENDPROC
 ENDPROC(__put_user_8)
 
-- 
1.5.5.1

