Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZBOKgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZBOKgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZBOKfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:35:13 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:39465 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbZBOKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:35:11 -0500
Date: Sun, 15 Feb 2009 16:04:59 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Patch 7/10] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20090215103459.GH6855@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090215103008.GA6855@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215103008.GA6855@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify signal handling code to refrain from re-enabling HW Breakpoints

From: Alan Stern <stern@rowland.harvard.edu>

This patch disables re-enabling of Hardware Breakpoint registers through
the  signal handling code. This is now done during
hw_breakpoint_handler().

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/signal.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/signal.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/signal.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/signal.c
@@ -803,15 +803,6 @@ static void do_signal(struct pt_regs *re
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/*
-		 * Re-enable any watchpoints before delivering the
-		 * signal to user space. The processor register will
-		 * have been cleared if the watchpoint triggered
-		 * inside the kernel.
-		 */
-		if (current->thread.debugreg7)
-			set_debugreg(current->thread.debugreg7, 7);
-
 		/* Whee! Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
 			/*
