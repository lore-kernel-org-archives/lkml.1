Return-Path: <linux-kernel-owner+w=401wt.eu-S1030716AbXAZC55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030716AbXAZC55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030717AbXAZC55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:57:57 -0500
Received: from mailout1.vmware.com ([65.113.40.130]:44284 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030716AbXAZC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:57:56 -0500
Message-ID: <45B96E33.1080400@vmware.com>
Date: Thu, 25 Jan 2007 18:57:55 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jim Mattson <jmattson@vmware.com>
Subject: [PATCH] x86_64 - Fix FS/GS registers for VT execution
Content-Type: multipart/mixed;
 boundary="------------070706090907000509050102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070706090907000509050102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andi, as we discussed, FS/GS segment state doesn't allow VT execution 
during boot.  Patch fixes this problem.  Please apply.  I will be 
sending for -stable review when upstream.

Thanks,

Zach

--------------070706090907000509050102
Content-Type: text/plain;
 name="fs-gs-clear"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fs-gs-clear"

Initialize FS and GS to __KERNEL_DS as well.  The actual value of them is not
important, but it is important to reload them in protected mode.  At this time,
they still retain the real mode values from initial boot.  VT disallows
execution of code under such conditions, which means hardware virtualization
can not be used to boot the kernel on Intel platforms, making the boot time
painfully slow.

This requires moving the GS load before the load of GS_BASE, so just move
all the segments loads there to keep them together in the code.

Signed-off-by: Zachary Amsden <zach@vmware.com>

Index: linux-2.6.19/arch/x86_64/kernel/head.S
===================================================================
--- linux-2.6.19.orig/arch/x86_64/kernel/head.S	2006-11-29 13:57:37.000000000 -0800
+++ linux-2.6.19/arch/x86_64/kernel/head.S	2007-01-11 16:57:24.000000000 -0800
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

--------------070706090907000509050102--
