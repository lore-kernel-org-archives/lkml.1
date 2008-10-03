Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYJCW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYJCW1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYJCW1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:27:00 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:7558 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYJCW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:26:59 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 2/9] traps: x86_64: make math_state_restore more like i386
Date: Fri,  3 Oct 2008 22:00:33 +0200
Message-Id: <1223064040-23170-3-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 00:26:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - rename variable me -> tsk
 - get thread and tsk like i386
 - expand used_math()
 - copy comment

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_64.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 8cf590b..a7aef2d 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -609,14 +609,15 @@ asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
  */
 asmlinkage void math_state_restore(void)
 {
-	struct task_struct *me = current;
+	struct thread_info *thread = current_thread_info();
+	struct task_struct *tsk = thread->task;
 
-	if (!used_math()) {
+	if (!tsk_used_math(tsk)) {
 		local_irq_enable();
 		/*
 		 * does a slab alloc which can sleep
 		 */
-		if (init_fpu(me)) {
+		if (init_fpu(tsk)) {
 			/*
 			 * ran out of memory!
 			 */
@@ -630,13 +631,13 @@ asmlinkage void math_state_restore(void)
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
-	if (unlikely(restore_fpu_checking(me))) {
+	if (unlikely(restore_fpu_checking(tsk))) {
 		stts();
-		force_sig(SIGSEGV, me);
+		force_sig(SIGSEGV, tsk);
 		return;
 	}
-	task_thread_info(me)->status |= TS_USEDFPU;
-	me->fpu_counter++;
+	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
+	tsk->fpu_counter++;
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-- 
1.5.4.3

