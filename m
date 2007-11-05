Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXKECQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXKECQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbXKECQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:16:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42894 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXKECQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:16:40 -0500
Date: Sun, 4 Nov 2007 18:16:11 -0800
Message-Id: <200711050216.lA52GBmY023984@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL] x86 setup: correct booting on 486 (revised)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus; please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (2):
      x86 setup: add a near jump to serialize %cr0 on 386/486
      x86 setup: set %ebx == %ebp == %edi == 0 on protected mode entry

 arch/x86/boot/pmjump.S |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

commit 142a92e61f9c405a114cb2bfaf3ce3f537a48a89
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Sun Nov 4 17:54:31 2007 -0800

    x86 setup: set %ebx == %ebp == %edi == 0 on protected mode entry
    
    In accordance with the newly formalized 32-bit boot protocol, set
    %ebx == %ebp == %edi == 0 in order to support future extensions to the
    protocol.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index 18732f7..0d24e96 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -28,13 +28,15 @@
  * void protected_mode_jump(u32 entrypoint, u32 bootparams);
  */
 protected_mode_jump:
-	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
 	movl	%eax, 3f		# Patch ljmpl instruction
 	jmp	1f			# Short jump to flush instruction q.
 1:
 
 	movw	$__BOOT_DS, %cx
+	xorl	%ebx, %ebx		# Per the 32-bit boot protocol
+	xorl	%ebp, %ebp		# Per the 32-bit boot protocol
+	xorl	%edi, %edi		# Per the 32-bit boot protocol
 
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit

commit ad676d0fdf2e59ccc28ee9f6f9593ff14a3d8a5a
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Sun Nov 4 17:50:12 2007 -0800

    x86 setup: add a near jump to serialize %cr0 on 386/486
    
    The 386 and 486 needs a jump immediately after setting %cr0 in order
    to serialize the pipeline.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index 2e55923..18732f7 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -30,15 +30,17 @@
 protected_mode_jump:
 	xorl	%ebx, %ebx		# Flag to indicate this is a boot
 	movl	%edx, %esi		# Pointer to boot_params table
-	movl	%eax, 2f		# Patch ljmpl instruction
+	movl	%eax, 3f		# Patch ljmpl instruction
 	jmp	1f			# Short jump to flush instruction q.
-
 1:
+
 	movw	$__BOOT_DS, %cx
 
 	movl	%cr0, %edx
 	orb	$1, %dl			# Protected mode (PE) bit
 	movl	%edx, %cr0
+	jmp	2f			# Short jump to serialize on 386/486
+2:
 
 	movw	%cx, %ds
 	movw	%cx, %es
@@ -48,7 +50,7 @@ protected_mode_jump:
 
 	# Jump to the 32-bit entrypoint
 	.byte	0x66, 0xea		# ljmpl opcode
-2:	.long	0			# offset
+3:	.long	0			# offset
 	.word	__BOOT_CS		# segment
 
 	.size	protected_mode_jump, .-protected_mode_jump
