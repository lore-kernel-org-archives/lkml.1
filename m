Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYJCVRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYJCVRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbYJCVRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:17:43 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:22717 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYJCVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:17:42 -0400
Date: Fri, 3 Oct 2008 23:16:12 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Resend: [PATCH 2/9] traps: x86_64: make math_state_restore more like i386
Message-ID: <20081003211612.GA1690@mailshack.com>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Fri, 03 Oct 2008 23:17:25 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir1)
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

It looks like patches 2 and 7 have been eaten along the way... Trying
those again.

Greetings,
    Alexander

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
