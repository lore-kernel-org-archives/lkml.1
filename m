Return-Path: <linux-kernel-owner+w=401wt.eu-S1161260AbXCGHcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161260AbXCGHcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161290AbXCGHbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:31:40 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51303 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161260AbXCGH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:27:55 -0500
Date: Wed, 7 Mar 2007 12:54:00 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Reloc Kernel List <fastboot@lists.osdl.org>, ebiederm@xmission.com,
       akpm@linux-foundation.org, ak@suse.de, hpa@zytor.com,
       magnus.damm@gmail.com, lwang@redhat.com, dzickus@redhat.com,
       pavel@suse.cz, rjw@sisk.pl
Subject: [PATCH 19/20] x86_64: Extend bzImage protocol for relocatable bzImage
Message-ID: <20070307072400.GT23412@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070307065703.GA23412@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307065703.GA23412@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



o Extend the bzImage protocol (same as i386) to allow bzImage loaders to
  load the protected mode kernel at non-1MB address. Now protected mode
  component is relocatable and can be loaded at non-1MB addresses.

o As of today kdump uses it to run a second kernel from a reserved memory
  area.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 arch/x86_64/boot/setup.S |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/boot/setup.S~x86_64-extend-bzImage-protocol-for-relocatable-bzImage arch/x86_64/boot/setup.S
--- linux-2.6.21-rc2-reloc/arch/x86_64/boot/setup.S~x86_64-extend-bzImage-protocol-for-relocatable-bzImage	2007-03-07 01:32:01.000000000 +0530
+++ linux-2.6.21-rc2-reloc-root/arch/x86_64/boot/setup.S	2007-03-07 01:32:01.000000000 +0530
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
_
