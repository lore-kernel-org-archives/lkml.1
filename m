Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYGHTKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYGHTKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYGHTKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:10:00 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:12593 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbYGHTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u75OnGwllr/1Y3sSyRvMFOEWaqY9BzM9mPLCs1W0AmGn9Cr63qu7bjEThQzEL1rL2i
         oh2AQ/r4KQCUXLhV61uVwh/nPFGHjg1UVHEGI5wUfZ40tY1T5Dr4cWd+Ay6Gf9BlRW1F
         MO4AIBfakcBMaJL/lsSWQaCADIDx/tBhmZVwg=
Date: Tue, 8 Jul 2008 23:09:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] Is 64bit LVTT screwed
Message-ID: <20080708190956.GC2775@asus>
References: <20080702184024.GC7003@cvg> <Pine.LNX.4.55.0807072243410.20615@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807072243410.20615@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Mon, Jul 07, 2008 at 11:08:57PM +0100]
[...]
| > 
| > but in both cases we use "divide by 16" in divide register. The only
| > explanation I imagine - for 64bit mode we are required to 'stuck'
| > for a bit longer (by 16 times longer to be precise). Am I right?
| > Or there is another reason why we dont use APIC_DIVISOR here. Actually,
| > as I see it not fair to a caller. For 64bit mode APIC timer is requested
| > to count 250000000 ticks but in real it will count 250000000 * 16.
| > Not sure who is right there. I think the better would be to
| > use 4000000000 and APIC_DIVISOR in 64bit mode. How do you think?
| 
|  The APIC clock varies across systems so the timer setup includes
| calibration.  Which means both variations end up with the correct
| interrupt rate probably, except using different divisors.  We used to
| print the APIC clock rate and that would be off with one of the above, but
| I don't we do this anymore.  We had a similar problem with the 82489DX
| where the prescaler was bypassed altogether resulting in an incorrect 
| clock rate printed, but the rate of timer interrupt was correctly 
| calibrated regardless.
| 
|  This is of course merely an explanation why the code you quoted does not
| explode spectacularly.  It does not make it correct.  If the prescaler is
| indeed set to 16 for 64-bit systems, then APIC_DIVISOR should obviously be
| used in the calculation above too.  And if not, then I think the prescaler 
| should be set consistently across systems and then the setting reflected 
| in the calculations accordingly.  Please note that only values between 2 
| and 16 are supported in a uniform way across all the APIC models and using 
| low values risks an overflow as clock rates are in the GHz range these 
| days already.  The value of 16 seems a reasonable one.
| 
|   Maciej
|

Maciej, I think the right soulution is the next:

Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-07-08 22:52:24.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-07-08 23:00:24.000000000 +0400
@@ -165,6 +165,9 @@ int lapic_get_maxlvt(void)
 	return maxlvt;
 }
 
+/* Clock divisor is set to 16 */
+#define APIC_DIVISOR 16
+
 /*
  * This function sets up the local APIC timer, with a timeout of
  * 'clocks' APIC bus clock. During calibration we actually call
@@ -197,7 +200,7 @@ static void __setup_APIC_LVTT(unsigned i
 				| APIC_TDR_DIV_16);
 
 	if (!oneshot)
-		apic_write(APIC_TMICT, clocks);
+		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
 }
 
 /*
@@ -329,7 +332,7 @@ static void __init calibrate_APIC_clock(
 	 *
 	 * No interrupt enable !
 	 */
-	__setup_APIC_LVTT(250000000, 0, 0);
+	__setup_APIC_LVTT(4000000000, 0, 0);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER

So we remain behaviour the same (ie calibrating duration remains the same)
but it has touched lapic_timer_setup. Will take a look into this more closer
soon.

		- Cyrill -
