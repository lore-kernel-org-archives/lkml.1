Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbYAQVrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbYAQVrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYAQVlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:47 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44806 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207AbYAQVlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:45 -0500
Date: Thu, 17 Jan 2008 16:40:44 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/20] UML - Move register initialization
Message-ID: <20080117214044.GA6737@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling init_registers inside the skas3 checking causes mysterious
crashes if it doesn't happen because the skas3 checking is bypassed.
This patch moves it to os_early_checks.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/start_up.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6.22/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/start_up.c	2007-12-19 13:15:22.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/start_up.c	2007-12-19 13:16:08.000000000 -0500
@@ -342,6 +342,8 @@ static void __init check_coredump_limit(
 
 void __init os_early_checks(void)
 {
+	int pid;
+
 	/* Print out the core dump limits early */
 	check_coredump_limit();
 
@@ -351,6 +353,11 @@ void __init os_early_checks(void)
 	 * kernel is running.
 	 */
 	check_tmpexec();
+
+	pid = start_ptraced_child();
+	if (init_registers(pid))
+		fatal("Failed to initialize default registers");
+	stop_ptraced_child(pid, 1, 1);
 }
 
 static int __init noprocmm_cmd_param(char *str, int* add)
@@ -412,9 +419,6 @@ static inline void check_skas3_ptrace_fa
 			non_fatal("found\n");
 	}
 
-	if (init_registers(pid))
-		fatal("Failed to initialize default registers");
-
 	stop_ptraced_child(pid, 1, 1);
 }
 
