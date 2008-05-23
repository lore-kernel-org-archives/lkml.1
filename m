Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbYEWNOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbYEWNOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbYEWNNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:13:15 -0400
Received: from gw.goop.org ([64.81.55.164]:33957 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbYEWNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:13:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 5] xen: don't worry about preempt during xen_irq_enable()
X-Mercurial-Node: 73463e67bf8e5bc2f998192740cb574f2116e783
Message-Id: <73463e67bf8e5bc2f998.1211548258@localhost>
In-Reply-To: <patchbomb.1211548253@localhost>
Date: Fri, 23 May 2008 14:10:58 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling interrupts, we don't need to worry about preemption,
because we either enter with interrupts disabled - so no preemption -
or the caller is confused and is re-enabling interrupts on some
indeterminate processor.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -235,13 +235,13 @@
 {
 	struct vcpu_info *vcpu;
 
-	/* There's a one instruction preempt window here.  We need to
-	   make sure we're don't switch CPUs between getting the vcpu
-	   pointer and updating the mask. */
-	preempt_disable();
+	/* We don't need to worry about being preempted here, since
+	   either a) interrupts are disabled, so no preemption, or b)
+	   the caller is confused and is trying to re-enable interrupts
+	   on an indeterminate processor. */
+
 	vcpu = x86_read_percpu(xen_vcpu);
 	vcpu->evtchn_upcall_mask = 0;
-	preempt_enable_no_resched();
 
 	/* Doesn't matter if we get preempted here, because any
 	   pending event will get dealt with anyway. */


