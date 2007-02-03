Return-Path: <linux-kernel-owner+w=401wt.eu-S1946354AbXBCFwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946354AbXBCFwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 00:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946355AbXBCFwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 00:52:21 -0500
Received: from pxy2nd.nifty.com ([202.248.175.14]:64093 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946354AbXBCFwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 00:52:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=D8EBbXUWMTnKyY+puSXRj5KYI65s4wnh0Tg95d6+S+3CfY0O3FIjTkPED5jpD4AfvqGQRrnnc4gACcZC42aP8w==  ;
From: TAKADA Yoshihito <takada@mbf.nifty.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Please revert "fix typo in geode_configre()@cyrix.c"
Cc: lsorense@csclub.uwaterloo.ca (Lennart Sorensen),
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070202131854.d5ea9de7.akpm@osdl.org>
References: <20070202151236.GN7582@csclub.uwaterloo.ca> <20070202131854.d5ea9de7.akpm@osdl.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.064
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.28.01 [ja]
Message-ID: <20070203055216.13487.qmail@smb517.nifty.com>
Date: Sat, 3 Feb 2007 14:52:16 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. I'm late.

I'll to resend the patch against 2.6.19.

original code doesn't write back to CCR4 register. this patch reflects a
value of a register.

diff -Narup linux-2.6.19.orig/arch/i386/kernel/cpu/cyrix.c linux-2.6.19/arch/i386/kernel/cpu/cyrix.c
--- linux-2.6.19.orig/arch/i386/kernel/cpu/cyrix.c	2006-11-30 06:57:37.000000000 +0900
+++ linux-2.6.19/arch/i386/kernel/cpu/cyrix.c	2007-02-03 14:57:35.000000000 +0900
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
@@ -415,15 +415,14 @@ static void __cpuinit cyrix_identify(str
 		
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


On Fri, 2 Feb 2007 13:18:54 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 2 Feb 2007 10:12:36 -0500
> lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:
> 
> > On Fri, Feb 02, 2007 at 12:05:43AM -0800, Andrew Morton wrote:
> > > On Fri, 2 Feb 2007 07:29:41 +0100 Adrian Bunk <bunk@stusta.de> wrote:
> > > 
> > > > Linus, please revert commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
> > > > 
> > > 
> > > Yup.
> > > 
> > > That discussion seems to have died.  The 2.6.19 code looks rather silly, but
> > > presumably it passed someone's testing at some stage.
> > 
> > The discussion ended because the last patch seemed to be correct to
> > everyone involved in the discussion.  At least that is my understanding.
> > Of course I am just one of the users affected by the patch.
> 
> The discussion ended with me asking for someone to send a patch.  That
> hasn't happened yet.  I don't want to have to troll through 20-30 messages
> and try to work out what patch we ended up with - that's the way in which
> mistakes occur.
> 
> Linus has now reverted e4f0ae0ea63caceff37a13f281a72652b7ea71ba.  Now,
> please, could someone send a patch against either current -git or against
> 2.6.19?  One which includes a descriptin of what it does, and why.
> 
> Thanks.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
TAKADA <takada@mbf.nifty.com>


