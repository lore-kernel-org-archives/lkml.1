Return-Path: <linux-kernel-owner+w=401wt.eu-S1765312AbXGYMKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765312AbXGYMKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762137AbXGYMIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:52 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33041 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758301AbXGYMIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:50 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7Ks4032174@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: simplify ColdFire resume code
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is useless to preserve THREAD_SR in `resume'.  The real user's sr
is actually in the stack.  We also don't need to disable interrupts :
we'll never be in an invalid state, the sp switch is atomic.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/arch/m68knommu/platform/5307/entry.S linux-2.6.22-uc0/arch/m68knommu/platform/5307/entry.S
--- linux-2.6.22/arch/m68knommu/platform/5307/entry.S	2007-07-12 15:23:02.000000000 +1000
+++ linux-2.6.22-uc0/arch/m68knommu/platform/5307/entry.S	2007-07-12 15:27:01.000000000 +1000
@@ -235,16 +216,12 @@
  * Beware - when entering resume, prev (the current task) is
  * in a0, next (the new task) is in a1,so don't change these
  * registers until their contents are no longer needed.
+ * This is always called in supervisor mode, so don't bother to save
+ * and restore sr; user's process sr is actually in the stack.
  */
 ENTRY(resume)
 	movel	%a0, %d1			/* get prev thread in d1 */
 
-	movew	%sr,%d0				/* save thread status reg */
-	movew	%d0,%a0@(TASK_THREAD+THREAD_SR)
-
-	oril	#0x700,%d0			/* disable interrupts */
-	move	%d0,%sr
-
 	movel	sw_usp,%d0			/* save usp */
 	movel	%d0,%a0@(TASK_THREAD+THREAD_USP)
 
@@ -255,7 +232,4 @@
 
 	movel	%a1@(TASK_THREAD+THREAD_USP),%a0 /* restore thread user stack */
 	movel	%a0, sw_usp
-
-	movew	%a1@(TASK_THREAD+THREAD_SR),%d0	/* restore thread status reg */
-	movew	%d0, %sr
 	rts
