Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYCRFY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYCRFY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYCRFYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:09 -0400
Received: from gw.goop.org ([64.81.55.164]:37831 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYCRFYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 31 of 31] xen: jump to iret fixup
X-Mercurial-Node: f135f9558180d397cc9410a793ca9225d6e5e246
Message-Id: <f135f9558180d397cc94.1205797042@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use jmp rather than call for the iret fixup, so its consistent with
the sysexit fixup, and it simplifies the stack (which is already
complex).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/kernel/entry_32.S |    3 +--
 arch/x86/xen/xen-asm.S     |   22 +++++++++-------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1049,8 +1049,7 @@
 	cmpl $xen_iret_end_crit,%eax
 	jae  1f
 
-	call xen_iret_crit_fixup
-	jmp  2f
+	jmp  xen_iret_crit_fixup
 
 1:	cmpl $xen_sysexit_start_crit,%eax
 	jb   2f
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -223,9 +223,7 @@
 	 ds		}  SAVE_ALL state
 	 eax		}
 	  :		:
-	 ebx		}
-	----------------
-	 return addr	 <- esp
+	 ebx		}<- esp
 	----------------
 
    In order to deliver the nested exception properly, we need to shift
@@ -240,10 +238,8 @@
    it's usermode state which we eventually need to restore.
  */
 ENTRY(xen_iret_crit_fixup)
-	/* offsets +4 for return address */
-
 	/*
-	   Paranoia: Make sure we're really coming from userspace.
+	   Paranoia: Make sure we're really coming from kernel space.
 	   One could imagine a case where userspace jumps into the
 	   critical range address, but just before the CPU delivers a GP,
 	   it decides to deliver an interrupt instead.  Unlikely?
@@ -252,32 +248,32 @@
 	   jump instruction itself, not the destination, but some virtual
 	   environments get this wrong.
 	 */
-	movl PT_CS+4(%esp), %ecx
+	movl PT_CS(%esp), %ecx
 	andl $SEGMENT_RPL_MASK, %ecx
 	cmpl $USER_RPL, %ecx
 	je 2f
 
-	lea PT_ORIG_EAX+4(%esp), %esi
-	lea PT_EFLAGS+4(%esp), %edi
+	lea PT_ORIG_EAX(%esp), %esi
+	lea PT_EFLAGS(%esp), %edi
 
 	/* If eip is before iret_restore_end then stack
 	   hasn't been restored yet. */
 	cmp $iret_restore_end, %eax
 	jae 1f
 
-	movl 0+4(%edi),%eax		/* copy EAX */
-	movl %eax, PT_EAX+4(%esp)
+	movl 0+4(%edi),%eax		/* copy EAX (just above top of frame) */
+	movl %eax, PT_EAX(%esp)
 
 	lea ESP_OFFSET(%edi),%edi	/* move dest up over saved regs */
 
 	/* set up the copy */
 1:	std
-	mov $(PT_EIP+4) / 4, %ecx	/* copy ret+saved regs up to orig_eax */
+	mov $PT_EIP / 4, %ecx		/* saved regs up to orig_eax */
 	rep movsl
 	cld
 
 	lea 4(%edi),%esp		/* point esp to new frame */
-2:	ret
+2:	jmp xen_do_upcall
 
 
 ENTRY(xen_sysexit)


