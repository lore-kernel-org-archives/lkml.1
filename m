Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbXKED7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbXKED7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 22:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXKED7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 22:59:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbXKED7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 22:59:16 -0500
Date: Sun, 4 Nov 2007 19:58:47 -0800
Message-Id: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] x86 setup: correct booting on 486 (revised)
In-reply-to: <200711050216.lA52GBmY023984@tazenda.hos.anvin.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just for the record, I realized this patch could be done slightly
cleaner and cleaned it up accordingly.

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (2):
      x86 setup: add a near jump to serialize %cr0 on 386/486
      x86 setup: set %ebx == %ebp == %edi == 0 on protected mode entry

 arch/x86/boot/pmjump.S |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

commit 9f259cc59ba45b8db401d60be9700e275676fb15
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Sun Nov 4 17:54:31 2007 -0800

    x86 setup: set %ebx == %ebp == %edi == 0 on protected mode entry
    
    In accordance with the newly formalized 32-bit boot protocol, set
    %ebx == %ebp == %edi == 0 in order to support future extensions to the
    protocol.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index 26baeab..fa6bed1 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -28,11 +28,13 @@
  * void protected_mode_jump(u32 entrypoint, u32 bootparams);
  */
 protected_mode_jump:
-	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
 	movl	%eax, 2f		# Patch ljmpl instruction
 
 	movw	$__BOOT_DS, %cx
+	xorl	%ebx, %ebx		# Per the 32-bit boot protocol
+	xorl	%ebp, %ebp		# Per the 32-bit boot protocol
+	xorl	%edi, %edi		# Per the 32-bit boot protocol
 
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit

commit 7ed192906a2144ebc8ca2925a85d27b9c5355668
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Sun Nov 4 17:50:12 2007 -0800

    x86 setup: add a near jump to serialize %cr0 on 386/486
    
    The 386 and 486 needs a jump immediately after setting %cr0 in order
    to serialize the pipeline.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

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
