Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXKDQoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXKDQoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 11:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXKDQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 11:44:30 -0500
Received: from aun.it.uu.se ([130.238.12.36]:52805 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbXKDQo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 11:44:29 -0500
Date: Sun, 4 Nov 2007 17:44:04 +0100 (MET)
Message-Id: <200711041644.lA4Gi4Ms013028@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix i486 boot failure due to stale %ds
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 01:05:58 +0100 (MET), Mikael Pettersson wrote:
>My old 486 fails to boot with the 2.6.24-rc1 kernel.
>Grub loads it, 4 lines of text appear but not the kernel's
>"Linux version <blah> greet", and the machine reboots.
>Double-checked with a serial console: nothing appears
>before it reboots.
>
>All 2.6 kernels up to 2.6.23 worked fine on this machine.

Problem identified and solved.

The last good kernel was 2.6.23-git17. The change in 2.6.23-git18
that broke my 486 was a24e785111a32ccb7cebafd24b1b1cb474ea8e5d,
which included the following:

>--- a/arch/x86/boot/compressed/head_32.S
>+++ b/arch/x86/boot/compressed/head_32.S
>@@ -27,13 +27,22 @@
> #include <asm/segment.h>
> #include <asm/page.h>
> #include <asm/boot.h>
>+#include <asm/asm-offsets.h>
> 
> .section ".text.head","ax",@progbits
>        .globl startup_32
> 
> startup_32:
>-       cld
>-       cli
>+       /* check to see if KEEP_SEGMENTS flag is meaningful */
>+       cmpw $0x207, BP_version(%esi)
>+       jb 1f
>+
>+       /* test KEEP_SEGMENTS flag to see if the bootloader is asking
>+        * us to not reload segments */
>+       testb $(1<<6), BP_loadflags(%esi)
>+       jnz 2f
>+
>+1:     cli
>        movl $(__BOOT_DS),%eax
>        movl %eax,%ds
>        movl %eax,%es

That is, it added loads from %ds:offset(%esi) before the code
that sanitises %ds et al. Commenting out these loads and tests
made the kernel boot again.

Adding debugging code to head_32.S and decompress_kernel(),
I found that startup_32 actually is invoked with a good %ds
(== 0x18 == __BOOT_DS) and a flat 4GB data segment in the
corresponding GDT entry.

Since data accesses work after %ds is (re)loaded with __BOOT_DS,
it's clear that on this machine, the hidden registers behind %ds
are stale on entry to startup_32. After adding a patch to reload
%ds with itself (not __BOOT_DS) at startup_32 the kernel doesn't
crash and reboot any more on this machine.

The machine in question is a ca 1993 vintage Siemens 486 with
a Quadtel S3 / Phoenix BIOS from 1994, booting via grub-0.95-13
from Fedora Core 4.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 arch/x86/boot/compressed/head_32.S |    5 +++++
 1 files changed, 5 insertions(+)

--- linux-2.6.24-rc1-git13/arch/x86/boot/compressed/head_32.S.~1~	2007-11-04 16:34:33.000000000 +0100
+++ linux-2.6.24-rc1-git13/arch/x86/boot/compressed/head_32.S	2007-11-04 16:44:15.000000000 +0100
@@ -33,6 +33,11 @@
 	.globl startup_32
 
 startup_32:
+	/* workaround for BIOSen or boot loaders that don't reload %ds
+	   after changing the GDT (insane but unfortunately true) */
+	movl %ds,%eax
+	movl %eax,%ds
+
 	cld
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 	 * us to not reload segments */
