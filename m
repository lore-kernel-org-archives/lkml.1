Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0CARal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:30:41 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65202 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0CARae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bn7HmEMXPV/2y+SdnL1mHcC4Wu0zmuFbM1+HeG26QBq4ZAbLaEWfmv5XKGY4NsrAeq
         FXkngBjBqGi+sFGAd2AkMtFlYF5HD7HQ2wRuNdqBtfSpZUmppjSHg256N2fFw3FeEmEE
         83D89zLtHSDceEBjZVNpF5Gy+X4pU4vuQ7syQ=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 2/2] x86-32: fix atomic64_inc_not_zero return value convention
Date: Mon,  1 Mar 2010 18:30:19 +0100
Message-Id: <1267464619-6784-3-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267464619-6784-1-git-send-email-luca@luca-barbieri.com>
References: <1267464619-6784-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buggy like atomic64_add_unless

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
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
-- 
1.6.6.1.476.g01ddb

