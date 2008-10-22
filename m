Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYJVKST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYJVKST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYJVKSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:18:08 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:13923 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbYJVKSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:18:07 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, hpa@zytor.com,
       akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>, ebiederm@xmission.com,
       tglx@linutronix.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 7/7] i386, dumpstack: unify die()
Date: Wed, 22 Oct 2008 12:00:14 +0200
Message-Id: <1224669614-25863-8-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224669614-25863-7-git-send-email-heukelum@fastmail.fm>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-2-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-3-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-4-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-5-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-6-git-send-email-heukelum@fastmail.fm>
 <1224669614-25863-7-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 22 Oct 2008 12:16:43 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.5; VDF: 7.0.7.72; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make i386's die() equal to x86_64's version.

Whitespace-only changes on x86_64, to make it equal to i386's
version. (user_mode and user_mode_vm are equal on x86_64.)

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   10 +++-------
 arch/x86/kernel/dumpstack_64.c |    6 +++++-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index e91ae34..f2046c5 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -378,15 +378,11 @@ void die(const char *str, struct pt_regs *regs, long err)
 	unsigned long flags = oops_begin();
 	int sig = SIGSEGV;
 
-	if (die_nest_count < 3) {
+	if (!user_mode_vm(regs))
 		report_bug(regs->ip, regs);
 
-		if (__die(str, regs, err))
-			sig = 0;
-	} else {
-		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
-	}
-
+	if (__die(str, regs, err))
+		sig = 0;
 	oops_end(flags, regs, sig);
 }
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 831e1e1..28c67aa 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -506,12 +506,16 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	return 0;
 }
 
+/*
+ * This is gone through when something in the kernel has done something bad
+ * and is about to be terminated:
+ */
 void die(const char *str, struct pt_regs *regs, long err)
 {
 	unsigned long flags = oops_begin();
 	int sig = SIGSEGV;
 
-	if (!user_mode(regs))
+	if (!user_mode_vm(regs))
 		report_bug(regs->ip, regs);
 
 	if (__die(str, regs, err))
-- 
1.5.4.3

