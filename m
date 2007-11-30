Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbXK3SJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbXK3SJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXK3SIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:08:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbXK3SIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:08:52 -0500
Message-ID: <4750519C.2000907@zytor.com>
Date: Fri, 30 Nov 2007 10:08:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: 2.6.23: does it supposed to work on an i486?
References: <47504923.9030309@msgid.tls.msk.ru>
In-Reply-To: <47504923.9030309@msgid.tls.msk.ru>
Content-Type: multipart/mixed;
 boundary="------------080006050706000207090009"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080006050706000207090009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Tokarev wrote:
> I tried to upgrade one of our ooooold machines
> (used as print servers and similar tasks) today
> from 2.6.22 to 2.6.23[.9].  The same config (with
> minor tweaks for new options), i486 base arch,
> X86_GENERIC=y.
> 
> The result is immediately machine reboot right
> after bootloader (etherboot) passes control to
> the kernel -- BEFORE "Uncompressing linux"
> message.
> 
> 2.6.22 worked just fine.
> 
> So I wonder if it's supposed to work in the first
> place.  The thing is that this machine(s) are very
> slow to boot, so trying to figure out which change
> is at question will require quite some time...

It looks like 2.6.23.9 is missing checkin 
7ed192906a2144ebc8ca2925a85d27b9c5355668 from Linus' tree (attached), 
which is necessary to work on 386 and 486.

	-hpa

--------------080006050706000207090009
Content-Type: text/x-patch;
 name="0001-x86-setup-add-a-near-jump-to-serialize-cr0-on-386.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-setup-add-a-near-jump-to-serialize-cr0-on-386.patch"

>From 7ed192906a2144ebc8ca2925a85d27b9c5355668 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Sun, 4 Nov 2007 17:50:12 -0800
Subject: [PATCH] x86 setup: add a near jump to serialize %cr0 on 386/486

The 386 and 486 needs a jump immediately after setting %cr0 in order
to serialize the pipeline.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/pmjump.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index 2e55923..26baeab 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -31,14 +31,14 @@ protected_mode_jump:
 	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
 	movl	%eax, 2f		# Patch ljmpl instruction
-	jmp	1f			# Short jump to flush instruction q.
 
-1:
 	movw	$__BOOT_DS, %cx
 
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit
 	movl	%edx, %cr0
+	jmp	1f			# Short jump to serialize on 386/486
+1:
 
 	movw	%cx, %ds
 	movw	%cx, %es
-- 
1.5.3.4


--------------080006050706000207090009--
