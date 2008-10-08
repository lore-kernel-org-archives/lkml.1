Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYJHT0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYJHT0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYJHT0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:26:22 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:50491 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756165AbYJHT0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:26:21 -0400
Date: Thu, 9 Oct 2008 00:56:11 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 7/9] Modify signal handling code to refrain from
	re-enabling HW Breakpoints
Message-ID: <20081008192611.GG4989@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081008192044.GA4510@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008192044.GA4510@in.ibm.com>
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
 arch/x86/kernel/signal_64.c |    8 --------
 2 files changed, 17 deletions(-)

Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/signal_32.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/signal_32.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/signal_32.c
@@ -600,15 +600,6 @@ static void do_signal(struct pt_regs *re
 
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
Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/signal_64.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/signal_64.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/signal_64.c
@@ -496,14 +496,6 @@ static void do_signal(struct pt_regs *re
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
-		/* Re-enable any watchpoints before delivering the
-		 * signal to user space. The processor register will
-		 * have been cleared if the watchpoint triggered
-		 * inside the kernel.
-		 */
-		if (current->thread.debugreg7)
-			set_debugreg(current->thread.debugreg7, 7);
-
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
 			/*
