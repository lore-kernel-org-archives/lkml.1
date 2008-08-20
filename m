Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbYHTJd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbYHTJd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYHTJdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:33:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbYHTJdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:33:17 -0400
Date: Wed, 20 Aug 2008 11:32:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Samuel Sieb <samuel@sieb.net>
Cc: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>,
       Juergen Beisert <juergen@kreuzholzen.de>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
Message-ID: <20080820093238.GA22511@elte.hu>
References: <48841A92.4020301@sieb.net> <48856BC6.7030308@sieb.net> <20080722102457.GA773@elte.hu> <200807221251.10843.jbe@pengutronix.de> <4886DB31.8070306@sieb.net> <20080728153224.GA28495@elte.hu> <489A82D5.6020903@sieb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489A82D5.6020903@sieb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Samuel Sieb <samuel@sieb.net> wrote:

> Ingo Molnar wrote:
>> any patch we should pick up to make your box boot?
>>
> I've looked through various datasheets and found that the GXm and GXLV  
> Geode processors don't have an incrementor.  I attached two patches. One 
> only calls the incrementor setup for GX1 or better.  The other one  
> removes the incrementor setup entirely.  As the incrementor value  
> differs according to clock speed and we would hope that the BIOS  
> configures it correctly, it is probably the better one to choose.  But I  
> will leave that choice up to you.  Either one works for me. :-)

i went for the commit below and queued it up in tip/x86/urgent - thanks 
Samuel.

what happens if the incrementor is not set up correctly by the BIOS - do 
timer IRQs come incorrectly? Or dont they come at all?

	Ingo

--------------->
>From c6744955d0ec0cb485c28c51eeb7185e260f6172 Mon Sep 17 00:00:00 2001
From: Samuel Sieb <samuel@sieb.net>
Date: Wed, 6 Aug 2008 22:06:29 -0700
Subject: [PATCH] x86: fix "kernel won't boot on a Cyrix MediaGXm (Geode)"

Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B has stopped
booting starting at v2.6.22.

The reason is this commit:

> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> Author: Juergen Beisert <juergen@kreuzholzen.de>
> Date:   Sun Jul 22 11:12:38 2007 +0200
>
>     x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.

this commit activated a macro which was dormant before due to (buggy)
macro side-effects.

I've looked through various datasheets and found that the GXm and GXLV
Geode processors don't have an incrementor.

Remove the incrementor setup entirely.  As the incrementor value
differs according to clock speed and we would hope that the BIOS
configures it correctly, it is probably the right solution.

Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/cyrix.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 3fd7a67..e710a21 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -134,23 +134,6 @@ static void __cpuinit set_cx86_memwb(void)
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
 }
 
-static void __cpuinit set_cx86_inc(void)
-{
-	unsigned char ccr3;
-
-	printk(KERN_INFO "Enable Incrementor on Cyrix/NSC processor.\n");
-
-	ccr3 = getCx86(CX86_CCR3);
-	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
-	/* PCR1 -- Performance Control */
-	/* Incrementor on, whatever that is */
-	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
-	/* PCR0 -- Performance Control */
-	/* Incrementor Margin 10 */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
-	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
-}
-
 /*
  *	Configure later MediaGX and/or Geode processor.
  */
@@ -174,7 +157,6 @@ static void __cpuinit geode_configure(void)
 
 	set_cx86_memwb();
 	set_cx86_reorder();
-	set_cx86_inc();
 
 	local_irq_restore(flags);
 }
