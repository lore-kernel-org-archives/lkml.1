Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYJVKAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYJVKAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYJVKAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:00:46 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:28694 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYJVKAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:00:45 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, hpa@zytor.com,
       akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>, ebiederm@xmission.com,
       tglx@linutronix.de
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "Neil Horman" <nhorman@tuxdriver.com>
Subject: [PATCH 1/7] i386, dumpstack: Move crash_kexec before bust_spinlocks(0) in oops_end
Date: Wed, 22 Oct 2008 12:00:08 +0200
Message-Id: <1224669614-25863-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Wed, 22 Oct 2008 11:59:10 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.5; VDF: 7.0.7.72; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crash_kexec should not be called with console_sem held. Move
the call before bust_spinlocks(0) in oops_end to avoid the
problem.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: "Neil Horman" <nhorman@tuxdriver.com>
---
 arch/x86/kernel/dumpstack_32.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index b361475..5493d31 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -309,6 +309,9 @@ unsigned __kprobes long oops_begin(void)
 
 void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
+	if (regs && kexec_should_crash(current))
+		crash_kexec(regs);
+
 	bust_spinlocks(0);
 	die_owner = -1;
 	add_taint(TAINT_DIE);
@@ -318,8 +321,6 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	if (!regs)
 		return;
 
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
-- 
1.5.4.3

