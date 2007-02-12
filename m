Return-Path: <linux-kernel-owner+w=401wt.eu-S965025AbXBLRAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbXBLRAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 12:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965024AbXBLRAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 12:00:34 -0500
Received: from ns2.suse.de ([195.135.220.15]:53608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964985AbXBLQve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:34 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: TAKADA Yoshihito <takada@mbf.nifty.com>,
       Jordan Crouse <jordan.crouse@amd.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [13/29] i386: geode configuration fixes
Message-Id: <20070212165133.7356613F45@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: TAKADA Yoshihito <takada@mbf.nifty.com>

Original code doesn't write back to CCR4 register.  This patch reflects a
value of a register.

Cc: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/cyrix.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

Index: linux/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux/arch/i386/kernel/cpu/cyrix.c
@@ -161,19 +161,19 @@ static void __cpuinit set_cx86_inc(void)
 static void __cpuinit geode_configure(void)
 {
 	unsigned long flags;
-	u8 ccr3, ccr4;
+	u8 ccr3;
 	local_irq_save(flags);
 
 	/* Suspend on halt power saving and enable #SUSP pin */
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
 
 	ccr3 = getCx86(CX86_CCR3);
-	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* Enable */
+	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
 	
-	ccr4 = getCx86(CX86_CCR4);
-	ccr4 |= 0x38;		/* FPU fast, DTE cache, Mem bypass */
-	
-	setCx86(CX86_CCR3, ccr3);
+
+	/* FPU fast, DTE cache, Mem bypass */
+	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x38);
+	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
 	
 	set_cx86_memwb();
 	set_cx86_reorder();	
@@ -420,15 +420,14 @@ static void __cpuinit cyrix_identify(str
 		
    	        if (dir0 == 5 || dir0 == 3)
    	        {
-			unsigned char ccr3, ccr4;
+			unsigned char ccr3;
 			unsigned long flags;
 			printk(KERN_INFO "Enabling CPUID on Cyrix processor.\n");
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
-			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN  */
-			ccr4 = getCx86(CX86_CCR4);
-			setCx86(CX86_CCR4, ccr4 | 0x80);          /* enable cpuid  */
-			setCx86(CX86_CCR3, ccr3);                 /* disable MAPEN */
+			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
+			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);  /* enable cpuid  */
+			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
 			local_irq_restore(flags);
 		}
 	}
