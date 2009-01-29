Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbZA2Ia7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbZA2Ia7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbZA2Ia0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:30:26 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60757 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020AbZA2IaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:30:24 -0500
Date: Thu, 29 Jan 2009 14:00:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       mingo@elte.hu, richardj_moore@uk.ibm.com, jason.wessel@windriver.com
Subject: [Patch 7/10] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20090129083015.GD7750@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090129074845.GA5078@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129074845.GA5078@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables re-enabling of Hardware Breakpoint registers through
the  signal handling code. This is now done during
hw_breakpoint_handler().

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/signal.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-hbkpt-lkml-29-rc2/arch/x86/kernel/signal.c
===================================================================
--- linux-hbkpt-lkml-29-rc2.orig/arch/x86/kernel/signal.c
+++ linux-hbkpt-lkml-29-rc2/arch/x86/kernel/signal.c
@@ -814,15 +814,6 @@ static void do_signal(struct pt_regs *re
 
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
