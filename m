Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbXLLUth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbXLLUth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbXLLUs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:48:56 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40747 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759566AbXLLUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:48:55 -0500
Date: Wed, 12 Dec 2007 15:47:58 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/6] UML - don't kill pid 0
Message-ID: <20071212204758.GA9124@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of defensive programming - during development, it ocassionally
happens that a call to init_new_context is missed, resulting in
context holding a host pid of zero.  When that address space is torn
down, destroy_context does a kill(0), which instantly kills the whole
UML without any errors whatsoever.

This patch add a check for pids less than 2, to also catch 1 and
negative pids.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/skas/mmu.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6-git/arch/um/kernel/skas/mmu.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/skas/mmu.c	2007-12-12 15:06:14.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/skas/mmu.c	2007-12-12 15:12:11.000000000 -0500
@@ -164,8 +164,20 @@ void destroy_context(struct mm_struct *m
 
 	if (proc_mm)
 		os_close_file(mmu->id.u.mm_fd);
-	else
+	else {
+		/*
+		 * If init_new_context wasn't called, this will be
+		 * zero, resulting in a kill(0), which will result in the
+		 * whole UML suddenly dying.  Also, cover negative and
+		 * 1 cases, since they shouldn't happen either.
+		 */
+		if (mmu->id.u.pid < 2) {
+			printk(KERN_ERR "corrupt mm_context - pid = %d\n",
+			       mmu->id.u.pid);
+			return;
+		}
 		os_kill_ptraced_process(mmu->id.u.pid, 1);
+	}
 
 	if (skas_needs_stub)
 		free_page(mmu->id.stack);
