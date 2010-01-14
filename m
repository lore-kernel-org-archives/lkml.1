Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377Ab0ANXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab0ANXLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166Ab0ANXLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:11:15 -0500
Received: from kroah.org ([198.145.64.141]:41928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab0ANXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:10:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 15:06:21 2010
Message-Id: <20100114230621.471041815@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 15:04:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Campbell <neilc@linux.vnet.ibm.com>,
       Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [6/6] powerpc: Handle VSX alignment faults correctly in little-endian mode
In-Reply-To: <20100114230640.GA7259@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 arch/powerpc/kernel/align.c |   63 ++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 17 deletions(-)

--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -641,10 +641,14 @@ static int emulate_spe(struct pt_regs *r
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
 
@@ -653,19 +657,35 @@ static int emulate_vsx(unsigned char __u
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
@@ -764,16 +784,25 @@ int fix_alignment(struct pt_regs *regs)
 
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
@@ -783,7 +812,7 @@ int fix_alignment(struct pt_regs *regs)
 			flags |= SPLT;
 			nb = 8;
 		}
-		return emulate_vsx(addr, reg, areg, regs, flags, nb);
+		return emulate_vsx(addr, reg, areg, regs, flags, nb, elsize);
 	}
 #endif
 	/* A size of 0 indicates an instruction we don't support, with


