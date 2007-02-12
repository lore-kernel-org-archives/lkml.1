Return-Path: <linux-kernel-owner+w=401wt.eu-S964774AbXBLHpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774AbXBLHpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933110AbXBLHnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:43:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:38427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933109AbXBLHiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:23 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Zachary Amsden <zach@vmware.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [32/39] x86_64: x86_64 - Fix FS/GS registers for VT execution
Message-Id: <20070212073820.7163213D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

Initialize FS and GS to __KERNEL_DS as well.  The actual value of them is not
important, but it is important to reload them in protected mode.  At this time,
they still retain the real mode values from initial boot.  VT disallows
execution of code under such conditions, which means hardware virtualization
can not be used to boot the kernel on Intel platforms, making the boot time
painfully slow.

This requires moving the GS load before the load of GS_BASE, so just move
all the segments loads there to keep them together in the code.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/head.S |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux/arch/x86_64/kernel/head.S
===================================================================
--- linux.orig/arch/x86_64/kernel/head.S
+++ linux/arch/x86_64/kernel/head.S
@@ -163,6 +163,20 @@ startup_64:
 	 */
 	lgdt	cpu_gdt_descr
 
+	/* set up data segments. actually 0 would do too */
+	movl $__KERNEL_DS,%eax
+	movl %eax,%ds
+	movl %eax,%ss
+	movl %eax,%es
+
+	/*
+	 * We don't really need to load %fs or %gs, but load them anyway
+	 * to kill any stale realmode selectors.  This allows execution
+	 * under VT hardware.
+	 */
+	movl %eax,%fs
+	movl %eax,%gs
+
 	/* 
 	 * Setup up a dummy PDA. this is just for some early bootup code
 	 * that does in_interrupt() 
@@ -173,12 +187,6 @@ startup_64:
 	shrq	$32,%rdx
 	wrmsr	
 
-	/* set up data segments. actually 0 would do too */
-	movl $__KERNEL_DS,%eax
-	movl %eax,%ds	
-	movl %eax,%ss
-	movl %eax,%es
-			
 	/* esi is pointer to real mode structure with interesting info.
 	   pass it to C */
 	movl	%esi, %edi
