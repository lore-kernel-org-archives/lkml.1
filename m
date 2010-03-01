Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0CAT7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:59:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:37723 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab0CAT7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:59:30 -0500
Date: Mon, 1 Mar 2010 19:59:08 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267469749-11878-6-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-6-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86-32: Fix atomic64_inc_not_zero return value convention
Message-ID: <tip-f3e83131469e29032a700217aa394996107b8fc5@git.kernel.org>
Git-Commit-ID: f3e83131469e29032a700217aa394996107b8fc5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:59:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3e83131469e29032a700217aa394996107b8fc5
Gitweb:     http://git.kernel.org/tip/f3e83131469e29032a700217aa394996107b8fc5
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Mon, 1 Mar 2010 19:55:49 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:39:03 -0800

x86-32: Fix atomic64_inc_not_zero return value convention

atomic64_inc_not_zero must return 1 if it perfomed the add and 0 otherwise.
It was doing the opposite thing.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267469749-11878-6-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/lib/atomic64_386_32.S |    3 +--
 arch/x86/lib/atomic64_cx8_32.S |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index a2f847c..4a5979a 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -153,13 +153,12 @@ BEGIN inc_not_zero %esi
 	adcl $0, %edx
 	movl %eax,  ($v)
 	movl %edx, 4($v)
-	xorl %eax, %eax
+	movl $1, %eax
 2:
 RETURN
 3:
 	testl %edx, %edx
 	jne 1b
-	movl $1, %eax
 	jmp 2b
 END_
 
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index d0e37b1..71e080d 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -212,14 +212,13 @@ ENTRY(atomic64_inc_not_zero_cx8)
 	cmpxchg8b (%esi)
 	jne 1b
 
-	xorl %eax, %eax
+	movl $1, %eax
 3:
 	RESTORE ebx
 	ret
 4:
 	testl %edx, %edx
 	jne 2b
-	movl $1, %eax
 	jmp 3b
 	CFI_ENDPROC
 ENDPROC(atomic64_inc_not_zero_cx8)
