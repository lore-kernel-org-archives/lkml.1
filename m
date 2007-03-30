Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbXC3O5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbXC3O5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbXC3O5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:57:06 -0400
Received: from [198.99.130.12] ([198.99.130.12]:57897 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbXC3O5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:57:05 -0400
Date: Fri, 30 Mar 2007 10:52:57 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - Speed up exec
Message-ID: <20070330145257.GA5471@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

flush_thread doesn't need to do a full page table walk in order to
clear the address space.  It knows what the end result needs to be, so
it can call unmap directly.

This results in a 10-20% speedup in an exec from bash.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/skas/exec.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/kernel/skas/exec.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/skas/exec.c	2007-03-30 10:28:24.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/skas/exec.c	2007-03-30 10:30:15.000000000 -0400
@@ -17,7 +17,17 @@
 
 void flush_thread_skas(void)
 {
-	force_flush_all();
+	void *data = NULL;
+	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
+	int ret;
+
+	ret = unmap(&current->mm->context.skas.id, 0, end, 1, &data);
+	if(ret){
+		printk("flush_thread_skas - clearing address space failed, "
+		       "err = %d\n", ret);
+		force_sig(SIGKILL, current);
+	}
+
 	switch_mm_skas(&current->mm->context.skas.id);
 }
 
