Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbZLJArl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbZLJArl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZLJArc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:47:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:52116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbZLJAra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:47:30 -0500
Date: Thu, 10 Dec 2009 00:47:12 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
References: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-32: Avoid pipeline serialization in PTREGSCALL1 and 2
Message-ID: <tip-ce9119ad90b1caba550447bfcc0a21850558ca49@git.kernel.org>
Git-Commit-ID: ce9119ad90b1caba550447bfcc0a21850558ca49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce9119ad90b1caba550447bfcc0a21850558ca49
Gitweb:     http://git.kernel.org/tip/ce9119ad90b1caba550447bfcc0a21850558ca49
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 9 Dec 2009 16:33:44 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 9 Dec 2009 16:33:44 -0800

x86-32: Avoid pipeline serialization in PTREGSCALL1 and 2

In the PTREGSCALL1 and 2 macros, we can trivially avoid an unnecessary
pipeline serialization, so do so.

In PTREGSCALLS3 this is much less clear-cut since we have to push a
new value to the stack.  Leave it alone for now assuming it is as good
as it is going to be; may want to check on Atom or another in-order
x86 to see if we can do better.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260403316-5679-2-git-send-email-brgerst@gmail.com>
---
 arch/x86/kernel/entry_32.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 6492555..cb12b9b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -735,15 +735,15 @@ ptregs_##name: \
 	ALIGN; \
 ptregs_##name: \
 	leal 4(%esp),%edx; \
-	movl PT_EBX(%edx),%eax; \
+	movl (PT_EBX+4)(%esp),%eax; \
 	jmp sys_##name;
 
 #define PTREGSCALL2(name) \
 	ALIGN; \
 ptregs_##name: \
 	leal 4(%esp),%ecx; \
-	movl PT_ECX(%ecx),%edx; \
-	movl PT_EBX(%ecx),%eax; \
+	movl (PT_ECX+4)(%esp),%edx; \
+	movl (PT_EBX+4)(%esp),%eax; \
 	jmp sys_##name;
 
 #define PTREGSCALL3(name) \
