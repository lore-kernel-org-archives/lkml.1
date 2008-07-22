Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYGVKZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYGVKZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYGVKZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:25:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYGVKZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:25:24 -0400
Date: Tue, 22 Jul 2008 12:24:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Samuel Sieb <samuel@sieb.net>
Cc: "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
Message-ID: <20080722102457.GA773@elte.hu>
References: <48841A92.4020301@sieb.net> <48842E71.9070503@gmail.com> <20080721114752.GE23095@elte.hu> <48856BC6.7030308@sieb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48856BC6.7030308@sieb.net>
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
>> * Rafael C. de Almeida <almeidaraf@gmail.com> wrote:
>>
>>> Samuel Sieb wrote:
>>>> I have a computer here with a CPU that the BIOS identifies as:
>>>> Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
>>>>
>>>> I can't boot any kernel later than 2.6.22 on it.  Anything later either
>>>> hangs or gives random kernel panics while booting.  I tracked down the
>>>> problem to a specific commit:
>>>>
>>>> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
>> does the debug patch below (ontop of v2.6.26 or later kernels) make the 
>> system bootable again? Commit f25f64ed5 changed the meaning of that  
>> line. This patch switches back to the old behavior (which essentially  
>> did nothing, due to macro side-effect bugs).
>>
> Commenting out this line didn't have any effect that I could see.  I was  
> hoping one way or another it would affect the TSC unstable message I  
> get, but it didn't even change that.

could you try to figure out which particular use of getCx86() or 
setCx86() makes the difference? Here are the suspect nested ones, for 
which the macro->inline change can be material:

$ grep -n 'Cx86.*Cx86' arch/x86/kernel/*/*.c > 1

arch/x86/kernel/cpu/cyrix.c:119:	setCx86(CX86_PCR0, getCx86(CX86_PCR0) & ~0x80);
arch/x86/kernel/cpu/cyrix.c:130:	setCx86(CX86_CCR2, getCx86(CX86_CCR2) & ~0x04);
arch/x86/kernel/cpu/cyrix.c:134:	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
arch/x86/kernel/cpu/cyrix.c:147:	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
arch/x86/kernel/cpu/cyrix.c:150:	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
arch/x86/kernel/cpu/cyrix.c:165:	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
arch/x86/kernel/cpu/cyrix.c:172:	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x38);
arch/x86/kernel/cpu/cyrix.c:289:			setCx86(CX86_CCR7, getCx86(CX86_CCR7) | 1);
arch/x86/kernel/cpu/cyrix.c:312:			setCx86(CX86_CCR7, getCx86(CX86_CCR7)|1);
arch/x86/kernel/cpu/cyrix.c:427:			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);  /* enable cpuid  */

i've applied the patch below to tip/master:
 
   http://people.redhat.com/mingo/tip.git/README

could you check whether it boots your system fine, out of box?

If yes then could you try to figure out which of the 11 places above 
make the difference? If it's a single line that makes a difference then 
you'd need about 4 reboots to figure it out, by 'bisecting' the lines. 
(changing half of them to setCx86, etc.)

	Ingo

------------------->
commit 6072555e0b697b5bc968bf1b397f0a710d75657e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jul 22 11:58:14 2008 +0200

    x86, cyrix: debug
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/cyrix.c       |   20 ++++++++++----------
 include/asm-x86/processor-cyrix.h |    8 ++++++++
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 3fd7a67..db5868c 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -116,7 +116,7 @@ static void __cpuinit set_cx86_reorder(void)
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
 
 	/* Load/Store Serialize to mem access disable (=reorder it) */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) & ~0x80);
+	setCx86_old(CX86_PCR0, getCx86_old(CX86_PCR0) & ~0x80);
 	/* set load/store serialize from 1GB to 4GB */
 	ccr3 |= 0xe0;
 	setCx86(CX86_CCR3, ccr3);
@@ -127,11 +127,11 @@ static void __cpuinit set_cx86_memwb(void)
 	printk(KERN_INFO "Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
 
 	/* CCR2 bit 2: unlock NW bit */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) & ~0x04);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) & ~0x04);
 	/* set 'Not Write-through' */
 	write_cr0(read_cr0() | X86_CR0_NW);
 	/* CCR2 bit 2: lock NW bit and set WT1 */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x14);
 }
 
 static void __cpuinit set_cx86_inc(void)
@@ -144,10 +144,10 @@ static void __cpuinit set_cx86_inc(void)
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
 	/* PCR1 -- Performance Control */
 	/* Incrementor on, whatever that is */
-	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
+	setCx86_old(CX86_PCR1, getCx86_old(CX86_PCR1) | 0x02);
 	/* PCR0 -- Performance Control */
 	/* Incrementor Margin 10 */
-	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
+	setCx86_old(CX86_PCR0, getCx86_old(CX86_PCR0) | 0x04);
 	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
 }
 
@@ -162,14 +162,14 @@ static void __cpuinit geode_configure(void)
 	local_irq_save(flags);
 
 	/* Suspend on halt power saving and enable #SUSP pin */
-	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
+	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x88);
 
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);	/* enable MAPEN */
 
 
 	/* FPU fast, DTE cache, Mem bypass */
-	setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x38);
+	setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x38);
 	setCx86(CX86_CCR3, ccr3);			/* disable MAPEN */
 
 	set_cx86_memwb();
@@ -286,7 +286,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		/* GXm supports extended cpuid levels 'ala' AMD */
 		if (c->cpuid_level == 2) {
 			/* Enable cxMMX extensions (GX1 Datasheet 54) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7) | 1);
+			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7) | 1);
 
 			/*
 			 * GXm : 0x30 ... 0x5f GXm  datasheet 51
@@ -309,7 +309,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		if (dir1 > 7) {
 			dir0_msn++;  /* M II */
 			/* Enable MMX extensions (App note 108) */
-			setCx86(CX86_CCR7, getCx86(CX86_CCR7)|1);
+			setCx86_old(CX86_CCR7, getCx86_old(CX86_CCR7)|1);
 		} else {
 			c->coma_bug = 1;      /* 6x86MX, it has the bug. */
 		}
@@ -424,7 +424,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
 			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
-			setCx86(CX86_CCR4, getCx86(CX86_CCR4) | 0x80);  /* enable cpuid  */
+			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);  /* enable cpuid  */
 			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
 			local_irq_restore(flags);
 		}
diff --git a/include/asm-x86/processor-cyrix.h b/include/asm-x86/processor-cyrix.h
index 97568ad..1198f2a 100644
--- a/include/asm-x86/processor-cyrix.h
+++ b/include/asm-x86/processor-cyrix.h
@@ -28,3 +28,11 @@ static inline void setCx86(u8 reg, u8 data)
 	outb(reg, 0x22);
 	outb(data, 0x23);
 }
+
+#define getCx86_old(reg) ({ outb((reg), 0x22); inb(0x23); })
+
+#define setCx86_old(reg, data) do { \
+	outb((reg), 0x22); \
+	outb((data), 0x23); \
+} while (0)
+

