Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbZBLMpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbZBLMpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbZBLMkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:40:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151AbZBLMkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:40:40 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212139.634236515@firstfloor.org>
In-Reply-To: <20090212139.634236515@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/10] x86: MCE: Use force_sig_info to kill process in machine check
Message-Id: <20090212123933.C518F3E666D@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:39:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bug fix (with tolerant == 3)

do_exit cannot be called directly from the exception handler because 
it can sleep and the exception handler runs on the exception stack.  
Use force_sig() instead.

Based on a earlier patch by Ying Huang who debugged the problem.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:20.000000000 +0100
@@ -297,11 +297,11 @@
 		 * If we know that the error was in user space, send a
 		 * SIGBUS.  Otherwise, panic if tolerance is low.
 		 *
-		 * do_exit() takes an awful lot of locks and has a slight
+		 * force_sig() takes an awful lot of locks and has a slight
 		 * risk of deadlocking.
 		 */
 		if (user_space) {
-			do_exit(SIGBUS);
+			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
 			mce_panic("Uncorrected machine check",
 				&panicm, mcestart);
