Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbZINUOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbZINUOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933639AbZINUOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:14:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54153 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597AbZINUI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 54/72] Blackfin: optimize fixed code handling for the most common case
Date: Mon, 14 Sep 2009 16:07:58 -0400
Message-Id: <1252958896-25150-55-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of the time we are returning to user space, it is not in the
fixed atomic code region.  So rather than branch to a function where we
check the PC and return, do the check inline and branch only when needed.

Also, tweak some of the fixed code handling based on assumptions we are
aware of but cannot be expressed in C.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/process.c    |   10 ++--------
 arch/blackfin/mach-common/entry.S |    6 ++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 9da36ba..f5b2861 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -282,25 +282,19 @@ void finish_atomic_sections (struct pt_regs *regs)
 {
 	int __user *up0 = (int __user *)regs->p0;
 
-	if (regs->pc < ATOMIC_SEQS_START || regs->pc >= ATOMIC_SEQS_END)
-		return;
-
 	switch (regs->pc) {
 	case ATOMIC_XCHG32 + 2:
 		put_user(regs->r1, up0);
-		regs->pc += 2;
+		regs->pc = ATOMIC_XCHG32 + 4;
 		break;
 
 	case ATOMIC_CAS32 + 2:
 	case ATOMIC_CAS32 + 4:
 		if (regs->r0 == regs->r1)
+	case ATOMIC_CAS32 + 6:
 			put_user(regs->r2, up0);
 		regs->pc = ATOMIC_CAS32 + 8;
 		break;
-	case ATOMIC_CAS32 + 6:
-		put_user(regs->r2, up0);
-		regs->pc += 2;
-		break;
 
 	case ATOMIC_ADD32 + 2:
 		regs->r0 = regs->r1 + regs->r0;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index e7eb163..a9b15aa 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1025,6 +1025,12 @@ ENTRY(_schedule_and_signal_from_int)
 #endif
 	sti r0;
 
+	/* finish the userspace "atomic" functions for it */
+	r1 = FIXED_CODE_END;
+	r2 = [sp + PT_PC];
+	cc = r1 <= r2;
+	if cc jump .Lresume_userspace (bp);
+
 	r0 = sp;
 	sp += -12;
 	call _finish_atomic_sections;
-- 
1.6.4.2

