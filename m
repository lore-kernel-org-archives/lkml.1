Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab0CAT64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:58:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:37675 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab0CAT6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:58:45 -0500
Date: Mon, 1 Mar 2010 19:58:22 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267469749-11878-3-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-3-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86-32: Fix atomic64_add_unless return value convention
Message-ID: <tip-6e6104fe085026e6ef82cc5cc303d6c8ceb7e411@git.kernel.org>
Git-Commit-ID: 6e6104fe085026e6ef82cc5cc303d6c8ceb7e411
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:58:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e6104fe085026e6ef82cc5cc303d6c8ceb7e411
Gitweb:     http://git.kernel.org/tip/6e6104fe085026e6ef82cc5cc303d6c8ceb7e411
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Mon, 1 Mar 2010 19:55:46 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:38:46 -0800

x86-32: Fix atomic64_add_unless return value convention

atomic64_add_unless must return 1 if it perfomed the add and 0 otherwise.
The implementation did the opposite thing.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267469749-11878-3-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
