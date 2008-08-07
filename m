Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYHGFIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYHGFIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 01:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYHGFIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 01:08:01 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30077 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752646AbYHGFIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 01:08:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Gz8L7unvIutdFyFd6bMA:9 a=ZAcv7MU9QR_zh4Sb4v4A:7 a=rAAcByYapMJKhTPqPKV9pWuxotgA:4 a=8k_t9Up_kE9YEAHiZboA:9 a=aVolUW-vRWh3Paz2IowA:7 a=fApWQy82LZ_0jw3PGrgg-Gvua1MA:4 a=Hw8qc9ORRP27l3yYD78A:9 a=CFh3nylG6GAtve5rWF8A:7 a=K4-Hqo-fu5l36J01hTPf5-EW_skA:4 a=l9iCJtgIvv4A:10 a=GFZTb6icBPAA:10
Message-ID: <489A82D5.6020903@sieb.net>
Date: Wed, 06 Aug 2008 22:06:29 -0700
From: Samuel Sieb <samuel@sieb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
References: <48841A92.4020301@sieb.net> <48856BC6.7030308@sieb.net> <20080722102457.GA773@elte.hu> <200807221251.10843.jbe@pengutronix.de> <4886DB31.8070306@sieb.net> <20080728153224.GA28495@elte.hu>
In-Reply-To: <20080728153224.GA28495@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050208010007080908000405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050208010007080908000405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> any patch we should pick up to make your box boot?
> 
I've looked through various datasheets and found that the GXm and GXLV 
Geode processors don't have an incrementor.  I attached two patches. 
One only calls the incrementor setup for GX1 or better.  The other one 
removes the incrementor setup entirely.  As the incrementor value 
differs according to clock speed and we would hope that the BIOS 
configures it correctly, it is probably the better one to choose.  But I 
will leave that choice up to you.  Either one works for me. :-)

--------------050208010007080908000405
Content-Type: text/x-patch;
 name="cyrix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cyrix.diff"

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index db5868c..d3323d1 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -155,7 +155,7 @@ static void __cpuinit set_cx86_inc(void)
  *	Configure later MediaGX and/or Geode processor.
  */
 
-static void __cpuinit geode_configure(void)
+static void __cpuinit geode_configure(unsigned char dir1)
 {
 	unsigned long flags;
 	u8 ccr3;
@@ -174,7 +174,9 @@ static void __cpuinit geode_configure(void)
 
 	set_cx86_memwb();
 	set_cx86_reorder();
-	set_cx86_inc();
+	/* GXm and GXLV don't have incrementors */
+	if (dir1 >= 0x80)
+		set_cx86_inc();
 
 	local_irq_restore(flags);
 }
@@ -295,7 +297,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 			 * GX1 : 0x8x          GX1  datasheet 56
 			 */
 			if ((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <= dir1 && dir1 <= 0x8f))
-				geode_configure();
+				geode_configure(dir1);
 			get_model_name(c);  /* get CPU marketing name */
 			return;
 		} else { /* MediaGX */

--------------050208010007080908000405
Content-Type: text/x-patch;
 name="cyrix2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cyrix2.diff"

diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index db5868c..ada5050 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -134,23 +134,6 @@ static void __cpuinit set_cx86_memwb(void)
 	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) | 0x14);
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
-	setCx86_old(CX86_PCR1, getCx86_old(CX86_PCR1) | 0x02);
-	/* PCR0 -- Performance Control */
-	/* Incrementor Margin 10 */
-	setCx86_old(CX86_PCR0, getCx86_old(CX86_PCR0) | 0x04);
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

--------------050208010007080908000405--
