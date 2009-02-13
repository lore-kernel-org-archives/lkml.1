Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbZBMQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbZBMQa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbZBMQ2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:28:43 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52279 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761307AbZBMQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:28:41 -0500
Date: Fri, 13 Feb 2009 20:28:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com
Subject: [Patch 7/10] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20090213145800.GG32064@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090213145301.GA31546@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213145301.GA31546@in.ibm.com>
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
