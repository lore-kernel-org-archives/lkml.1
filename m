Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549Ab0AEAy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0AEAy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983Ab0AEAyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:54:55 -0500
Received: from kroah.org ([198.145.64.141]:34136 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab0AEAev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Campbell <neilc@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/97] powerpc: Handle VSX alignment faults correctly in little-endian mode
Date: Mon,  4 Jan 2010 16:32:30 -0800
Message-Id: <1262651630-7354-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Campbell <neilc@linux.vnet.ibm.com>

commit bb7f20b1c639606def3b91f4e4aca6daeee5d80a upstream.

This patch fixes the handling of VSX alignment faults in little-endian
mode (the current code assumes the processor is in big-endian mode).

The patch also makes the handlers clear the top 8 bytes of the register
when handling an 8 byte VSX load.

This is based on 2.6.32.

Signed-off-by: Neil Campbell <neilc@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/align.c |   63 +++++++++++++++++++++++++++++++-----------
 1 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index a5b632e..f0c624f 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -642,10 +642,14 @@ static int emulate_spe(struct pt_regs *regs, unsigned int reg,
  */
 static int emulate_vsx(unsigned char __user *addr, unsigned int reg,
 		       unsigned int areg, struct pt_regs *regs,
-		       unsigned int flags, unsigned int length)
+		       unsigned int flags, unsigned int length,
+		       unsigned int elsize)
 {
 	char *ptr;
+	unsigned long *lptr;
 	int ret = 0;
+	int sw = 0;
+	int i, j;
 
 	flush_vsx_to_thread(current);
 
@@ -654,19 +658,35 @@ static int emulate_vsx(unsigned char __user *addr, unsigned int reg,
 	else
 		ptr = (char *) &current->thread.vr[reg - 32];
 
-	if (flags & ST)
-		ret = __copy_to_user(addr, ptr, length);
-        else {
-		if (flags & SPLT){
-			ret = __copy_from_user(ptr, addr, length);
-			ptr += length;
+	lptr = (unsigned long *) ptr;
+
+	if (flags & SW)
+		sw = elsize-1;
+
+	for (j = 0; j < length; j += elsize) {
+		for (i = 0; i < elsize; ++i) {
+			if (flags & ST)
+				ret |= __put_user(ptr[i^sw], addr + i);
+			else
+				ret |= __get_user(ptr[i^sw], addr + i);
 		}
-		ret |= __copy_from_user(ptr, addr, length);
+		ptr  += elsize;
+		addr += elsize;
 	}
-	if (flags & U)
-		regs->gpr[areg] = regs->dar;
-	if (ret)
+
+	if (!ret) {
+		if (flags & U)
+			regs->gpr[areg] = regs->dar;
+
+		/* Splat load copies the same data to top and bottom 8 bytes */
+		if (flags & SPLT)
+			lptr[1] = lptr[0];
+		/* For 8 byte loads, zero the top 8 bytes */
+		else if (!(flags & ST) && (8 == length))
+			lptr[1] = 0;
+	} else
 		return -EFAULT;
+
 	return 1;
 }
 #endif
@@ -767,16 +787,25 @@ int fix_alignment(struct pt_regs *regs)
 
 #ifdef CONFIG_VSX
 	if ((instruction & 0xfc00003e) == 0x7c000018) {
-		/* Additional register addressing bit (64 VSX vs 32 FPR/GPR */
+		unsigned int elsize;
+
+		/* Additional register addressing bit (64 VSX vs 32 FPR/GPR) */
 		reg |= (instruction & 0x1) << 5;
 		/* Simple inline decoder instead of a table */
+		/* VSX has only 8 and 16 byte memory accesses */
+		nb = 8;
 		if (instruction & 0x200)
 			nb = 16;
-		else if (instruction & 0x080)
-			nb = 8;
-		else
-			nb = 4;
+
+		/* Vector stores in little-endian mode swap individual
+		   elements, so process them separately */
+		elsize = 4;
+		if (instruction & 0x80)
+			elsize = 8;
+
 		flags = 0;
+		if (regs->msr & MSR_LE)
+			flags |= SW;
 		if (instruction & 0x100)
 			flags |= ST;
 		if (instruction & 0x040)
@@ -787,7 +816,7 @@ int fix_alignment(struct pt_regs *regs)
 			nb = 8;
 		}
 		PPC_WARN_EMULATED(vsx);
-		return emulate_vsx(addr, reg, areg, regs, flags, nb);
+		return emulate_vsx(addr, reg, areg, regs, flags, nb, elsize);
 	}
 #endif
 	/* A size of 0 indicates an instruction we don't support, with
-- 
1.6.6

