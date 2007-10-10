Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbXJJHhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbXJJHhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 03:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXJJHho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 03:37:44 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:43056 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752123AbXJJHhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 03:37:43 -0400
Message-ID: <392001863.28140@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 10 Oct 2007 15:37:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Zachary Amsden <zach@vmware.com>
Cc: Avi Kivity <avi@argo.co.il>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, david-g@263.net
Subject: Re: x86_64 : kernel initial decompression hangs on vmware
Message-ID: <20071010073739.GA5952@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zachary,

One of my friends' vmware "hangs" on booting Linux 2.6.23, and then get
it to work by applying your patch at http://lkml.org/lkml/2007/8/4/72.

It would be nice to see your fix going into mainline :-)

Thank you,
Fengguang
---
PS. the original patch:

VT is very picky about when it can enter execution.
Get all segments setup and get LDT and TR into valid state to allow
VT execution under VMware and KVM (untested).

This makes the boot decompression run under VT, which makes it several
orders of magnitude faster on 64-bit Intel hardware.

Before, I was seeing times up to a minute or more to decompress a 1.3MB kernel
on a very fast box.

Signed-off-by: Zachary Amsden <zach@vmware.com>
===================================================================
--- a/arch/x86_64/boot/compressed/head.S
+++ a/arch/x86_64/boot/compressed/head.S
@@ -195,6 +195,11 @@
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
@@ -295,6 +300,8 @@
 	.quad	0x0000000000000000	/* NULL descriptor */
 	.quad	0x00af9a000000ffff	/* __KERNEL_CS */
 	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
+	.quad	0x0080890000000000	/* TS descriptor */
+	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 	.bss
 /* Stack for uncompression */

