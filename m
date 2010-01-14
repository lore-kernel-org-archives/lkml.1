Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339Ab0ANXLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0ANXLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880Ab0ANXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:10:13 -0500
Received: from kroah.org ([198.145.64.141]:41925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab0ANXKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:10:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 15:06:21 2010
Message-Id: <20100114230621.341451387@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 15:04:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>
Subject: [5/6] powerpc: Disable VSX or current process in giveup_fpu/altivec
In-Reply-To: <20100114230640.GA7259@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 7e875e9dc8af70d126fa632446e967327ac3fdda upstream.

When we call giveup_fpu, we need to need to turn off VSX for the
current process.  If we don't, on return to userspace it may execute a
VSX instruction before the next FP instruction, and not have its
register state refreshed correctly from the thread_struct.  Ditto for
altivec.

This caused a bug where an unaligned lfs or stfs results in
fix_alignment calling giveup_fpu so it can use the FPRs (in order to
do a single <-> double conversion), and then returning to userspace
with FP off but VSX on.  Then if a VSX instruction is executed, before
another FP instruction, it will proceed without another exception and
hence have the incorrect register state for VSX registers 0-31.

   lfs unaligned   <- alignment exception turns FP off but leaves VSX on

   VSX instruction <- no exception since VSX on, hence we get the
                      wrong VSX register values for VSX registers 0-31,
                      which overlap the FPRs.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/fpu.S     |    5 +++++
 arch/powerpc/kernel/misc_64.S |    8 ++++++++
 2 files changed, 13 insertions(+)

--- a/arch/powerpc/kernel/fpu.S
+++ b/arch/powerpc/kernel/fpu.S
@@ -145,6 +145,11 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)
 	beq	1f
 	PPC_LL	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
 	li	r3,MSR_FP|MSR_FE0|MSR_FE1
+#ifdef CONFIG_VSX
+BEGIN_FTR_SECTION
+	oris	r3,r3,MSR_VSX@h
+END_FTR_SECTION_IFSET(CPU_FTR_VSX)
+#endif
 	andc	r4,r4,r3		/* disable FP for previous task */
 	PPC_STL	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
 1:
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -493,7 +493,15 @@ _GLOBAL(giveup_altivec)
 	stvx	vr0,r4,r3
 	beq	1f
 	ld	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
+#ifdef CONFIG_VSX
+BEGIN_FTR_SECTION
+	lis	r3,(MSR_VEC|MSR_VSX)@h
+FTR_SECTION_ELSE
+	lis	r3,MSR_VEC@h
+ALT_FTR_SECTION_END_IFSET(CPU_FTR_VSX)
+#else
 	lis	r3,MSR_VEC@h
+#endif
 	andc	r4,r4,r3		/* disable FP for previous task */
 	std	r4,_MSR-STACK_FRAME_OVERHEAD(r5)
 1:


