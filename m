Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXDMQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXDMQTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbXDMQTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:19:18 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59863 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbXDMQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:19:17 -0400
X-AuditID: d80ac287-9beabbb000002c59-1a-461fad84d4bb 
Date: Fri, 13 Apr 2007 17:19:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH mm] fix i386 get_gate_vma oops
Message-ID: <Pine.LNX.4.64.0704131714160.3687@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 13 Apr 2007 16:19:16.0473 (UTC) FILETIME=[7B68C690:01C77DE7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix oops from i386-make-compat_vdso-runtime-selectable.patch.

Even mingetty at system startup finds it easy to trigger an oops
while reading /proc/PID/maps: though it has a good hold on the mm
itself, that cannot stop exit_mm() from resetting tsk->mm to NULL.

(It is usually show_map()'s call to get_gate_vma() which oopses,
and I expect we could change that to check priv->tail_vma instead;
but no matter, even m_start()'s call just after get_task_mm() is racy.)

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.21-rc6-mm1/arch/i386/kernel/sysenter.c	2007-04-10 11:37:23.000000000 +0100
+++ linux/arch/i386/kernel/sysenter.c	2007-04-13 16:43:45.000000000 +0100
@@ -326,8 +326,10 @@ const char *arch_vma_name(struct vm_area
 
 struct vm_area_struct *get_gate_vma(struct task_struct *tsk)
 {
+	struct mm_struct *mm = tsk->mm;
+
 	/* Check to see if this task was created in compat vdso mode */
-	if (tsk->mm->context.vdso == (void *)VDSO_HIGH_BASE)
+	if (mm && mm->context.vdso == (void *)VDSO_HIGH_BASE)
 		return &gate_vma;
 	return NULL;
 }
