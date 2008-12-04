Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYLDTO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYLDTO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbYLDTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:14:16 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:45418 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476AbYLDTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:14:14 -0500
Date: Fri, 5 Dec 2008 00:44:07 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: [RFC Patch 7/9] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20081204191407.GG20563@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081204190804.GA15134@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204190804.GA15134@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables re-enabling of Hardware Breakpoint registers through the 
signal handling code. This is now during hw_breakpoint_handler().

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/signal_32.c |    9 ---------
 arch/x86/kernel/signal_64.c |    9 ---------
 2 files changed, 18 deletions(-)

Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/signal_32.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/kernel/signal_32.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/signal_32.c
@@ -622,15 +622,6 @@ static void do_signal(struct pt_regs *re
 
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
Index: linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/signal_64.c
===================================================================
--- linux-2.6.28-rc5-bkpt-latest.orig/arch/x86/kernel/signal_64.c
+++ linux-2.6.28-rc5-bkpt-latest/arch/x86/kernel/signal_64.c
@@ -422,15 +422,6 @@ static void do_signal(struct pt_regs *re
 
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
