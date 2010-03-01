Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab0CASz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:55:59 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50974 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab0CASz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:55:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=OT2mUFVJftqVWJwtCSjythIl210FtCTLshvTiiUdPEk9GcYC6Wp62iAhSAb/QWRkBA
         5hUE/0tGnlybsESuuJyj+33KZ2OBYGrpeyh/Sf1B3q2zuOTFq4WgowwOUhKLlcKviXp2
         vg/dvNc4sqs8PmmKqGM8YudIDhOtLRVcvANPA=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 2/5] x86-32: fix atomic64_add_unless return value convention
Date: Mon,  1 Mar 2010 19:55:46 +0100
Message-Id: <1267469749-11878-3-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic64_add_unless must return 1 if it perfomed the add and 0 otherwise.
The implementation did the opposite thing.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/lib/atomic64_386_32.S |    4 ++--
 arch/x86/lib/atomic64_cx8_32.S |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 5db07fe..a2f847c 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -133,13 +133,13 @@ BEGIN add_unless %ecx
 1:
 	movl %eax,  ($v)
 	movl %edx, 4($v)
-	xorl %eax, %eax
+	movl $1, %eax
 2:
 RETURN
 3:
 	cmpl %edx, %edi
 	jne 1b
-	movl $1, %eax
+	xorl %eax, %eax
 	jmp 2b
 END_
 
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index e49c4eb..d0e37b1 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -180,7 +180,7 @@ ENTRY(atomic64_add_unless_cx8)
 	cmpxchg8b (%ebp)
 	jne 1b
 
-	xorl %eax, %eax
+	movl $1, %eax
 3:
 	addl $8, %esp
 	CFI_ADJUST_CFA_OFFSET -8
@@ -190,7 +190,7 @@ ENTRY(atomic64_add_unless_cx8)
 4:
 	cmpl %edx, 4(%esp)
 	jne 2b
-	movl $1, %eax
+	xorl %eax, %eax
 	jmp 3b
 	CFI_ENDPROC
 ENDPROC(atomic64_add_unless_cx8)
-- 
1.6.6.1.476.g01ddb

