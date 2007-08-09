Return-Path: <linux-kernel-owner+w=401wt.eu-S939895AbXHIMo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939895AbXHIMo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939648AbXHIMlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:37 -0400
Received: from mx1.suse.de ([195.135.220.2]:50890 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939642AbXHIMle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:34 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/12] x86_64: Early segment setup for VT
Message-Id: <20070809124133.D559014F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

VT is very picky about when it can enter execution.
Get all segments setup and get LDT and TR into valid state to allow
VT execution under VMware and KVM (untested).

This makes the boot decompression run under VT, which makes it several
orders of magnitude faster on 64-bit Intel hardware.

Before, I was seeing times up to a minute or more to decompress a 1.3MB kernel
on a very fast box.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/boot/compressed/head.S |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/arch/x86_64/boot/compressed/head.S
===================================================================
--- linux.orig/arch/x86_64/boot/compressed/head.S
+++ linux/arch/x86_64/boot/compressed/head.S
@@ -195,6 +195,11 @@ ENTRY(startup_64)
 	movl	%eax, %ds
 	movl	%eax, %es
 	movl	%eax, %ss
+	movl	%eax, %fs
+	movl	%eax, %gs
+	lldt	%ax
+	movl    $0x20, %eax
+	ltr	%ax
 
 	/* Compute the decompressed kernel start address.  It is where
 	 * we were loaded at aligned to a 2M boundary. %rbp contains the
@@ -295,6 +300,8 @@ gdt:
 	.quad	0x0000000000000000	/* NULL descriptor */
 	.quad	0x00af9a000000ffff	/* __KERNEL_CS */
 	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
+	.quad	0x0080890000000000	/* TS descriptor */
+	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 	.bss
 /* Stack for uncompression */
