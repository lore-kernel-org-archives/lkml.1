Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXEQS40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXEQS40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbXEQS4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:56:19 -0400
Received: from m-relay.rz.uni-saarland.de ([134.96.7.3]:14156 "EHLO
	m-relay.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbXEQS4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:56:18 -0400
Date: Thu, 17 May 2007 20:54:25 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 new setup: use appropriate sections for code and data
Message-ID: <20070517185425.GA15461@mailshack.com>
References: <20070517112553.GA12901@mailshack.com> <464C8B60.5040109@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464C8B60.5040109@zytor.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.5.1 (m-relay.rz.uni-saarland.de [134.96.7.3]); Thu, 17 May 2007 20:56:16 +0200 (CEST)
X-AntiVirus: checked by AntiVir Milter (version: 1.1.3-1; AVE: 7.4.0.23; VDF: 6.38.1.155; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

An intermediate elf file is generated for the 16-bit setup code.
The generated code can be viewed using objdump -m i8086 -d. As it
stands, it also tries to disassemble the bugger_off_msg, which
results in garbage. This introduces two new sections to separate
the code and the data part of the bootsector stub. It also moves
some code from the .header section (a data section) to .inittext.

Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>
---
> I'd prefer .bstext or .bs_text and .bsdata/.bs_data; possibly .bsecttext
> and .bsectdata.  The term "boot sector" for that particular piece of
> code is firmly established.
> 
> 	-hpa

Hi,

This version uses the section names .bstext/.bsdata.

Greetings,
	Alexander


 arch/i386/boot/header.S |   10 +++++-----
 arch/i386/boot/setup.ld |    4 ++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/i386/boot/header.S b/arch/i386/boot/header.S
index 02d0f7d..c1c89e5 100644
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -44,7 +44,7 @@ SWAP_DEV	= 0			/* SWAP_DEV is now written by "build" */
 #endif
 
 	.code16
-	.section ".header", "ax"
+	.section ".bstext", "ax"
 
 	.global bootsect_start
 bootsect_start:
@@ -82,7 +82,7 @@ bs_die:
 	# invoke the BIOS reset code...
 	ljmp	$0xf000,$0xfff0
 
-
+	.section ".bsdata", "a"
 bugger_off_msg:
 	.ascii	"Direct booting from floppy is no longer supported.\r\n"
 	.ascii	"Please use a boot loader program instead.\r\n"
@@ -94,7 +94,7 @@ bugger_off_msg:
 	# Kernel attributes; used by setup.  This is part 1 of the
 	# header, from the old boot sector.
 
-	.org 497
+	.section ".header", "a"
 	.globl	hdr
 hdr:
 setup_sects:	.byte SETUPSECTS
@@ -208,10 +208,11 @@ pad3:			.word 0
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
                                                 #version 2.06
+start_of_setup:
 
 # End of setup header #####################################################
 
-start_of_setup:
+	.section ".inittext", "ax"
 #ifdef SAFE_RESET_DISK_CONTROLLER
 # Reset the disk controller.
 	movw	$0x0000, %ax		# Reset disk controller
@@ -225,7 +226,6 @@ start_of_setup:
 	pushw	$setup2
 	lretw
 
-	.section ".inittext", "ax"
 setup2:
 # Force %es = %ds
 	movw	%ds, %ax
diff --git a/arch/i386/boot/setup.ld b/arch/i386/boot/setup.ld
index a111572..01816bb 100644
--- a/arch/i386/boot/setup.ld
+++ b/arch/i386/boot/setup.ld
@@ -10,6 +10,10 @@ ENTRY(_start)
 SECTIONS
 {
 	. = 0;
+	.bstext		: { *(.bstext) }
+	.bsdata		: { *(.bsdata) }
+
+	. = 497;
 	.header		: { *(.header) }
 	.inittext	: { *(.inittext) }
 	.initdata	: { *(.initdata) }
-- 
1.4.4.2

