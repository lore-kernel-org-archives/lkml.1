Return-Path: <linux-kernel-owner+w=401wt.eu-S1163356AbXD1SCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163356AbXD1SCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163352AbXD1SBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:01:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163358AbXD1R7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:59:10 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Message-Id: <20070428175909.1D09D151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:59:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>


o Extend the bzImage protocol (same as i386) to allow bzImage loaders to
  load the protected mode kernel at non-1MB address. Now protected mode
  component is relocatable and can be loaded at non-1MB addresses.

o As of today kdump uses it to run a second kernel from a reserved memory
  area.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/boot/setup.S |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/boot/setup.S
===================================================================
--- linux.orig/arch/x86_64/boot/setup.S
+++ linux/arch/x86_64/boot/setup.S
@@ -80,7 +80,7 @@ start:
 # This is the setup header, and it must start at %cs:2 (old 0x9020:2)
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0204		# header version number (>= 0x0105)
+		.word	0x0205		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
 start_sys_seg:	.word	SYSSEG
@@ -155,7 +155,16 @@ cmd_line_ptr:	.long 0			# (Header versio
 					# low memory 0x10000 or higher.
 
 ramdisk_max:	.long 0xffffffff
-	
+kernel_alignment:  .long 0x200000       # physical addr alignment required for
+					# protected mode relocatable kernel
+#ifdef CONFIG_RELOCATABLE
+relocatable_kernel:    .byte 1
+#else
+relocatable_kernel:    .byte 0
+#endif
+pad2:                  .byte 0
+pad3:                  .word 0
+
 trampoline:	call	start_of_setup
 		.align 16
 					# The offset at this point is 0x240
