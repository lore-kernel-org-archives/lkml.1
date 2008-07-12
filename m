Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYGLHWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYGLHWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYGLHWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:22:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:38672 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYGLHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a/mM4K0S9iRK/SqqFWTozt44mlejerNm0TnvJ25hbfNuGoBLqeIqhPsGEj8P1jn4zk
         XJ+CXNeFrisZvQkc8STqHADRyRCvVph9iEPZ6mpZqtFWuFMFGsBGYTgtfF3vPv7i6rSJ
         fVMbhfOCNrBdeEIl/Pck7nOsYlOj4l3I+DMo4=
Date: Sat, 12 Jul 2008 11:22:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic LVTT - use APIC_DIVISOR on 64bit mode
Message-ID: <20080712072216.GA7010@asus>
References: <20080709190237.GA21423@asus> <20080712060504.GB14714@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080712060504.GB14714@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sat, Jul 12, 2008 at 08:05:04AM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > We use APIC_TDR_DIV_16 while setting APIC_TDCR (divisor) it happened 
| > this moment is hidden from __setup_APIC_LVTT caller. So we better 
| > increment caller 'clocks' value to not change current behaviour and 
| > use APIC_DIVISOR (as already done in 32bit version).
| > 
| > The main benefit - unified procedure code for 32/64bit modes.
| 
| > Please review carefully. Any comments are welcome.
| > I'm _not_ 100% sure if this patch is safe.
| 
| hm, how about the other caller to __setup_APIC_LVTT(), 
| lapic_timer_setup():
| 
|         case CLOCK_EVT_MODE_ONESHOT:
|                 __setup_APIC_LVTT(calibration_result,
|                                   mode != CLOCK_EVT_MODE_PERIODIC, 1);
|                 break;
| 
| that will affect high-res timers. Wont calibration_result have the same 
| value after your patch as well, but only a 16th of it will be used in 
| __setup_APIC_LVTT(), causing 16 times shorter timeouts than intended?
| 
| I.e. are we fixing a bug, are we changing nothing, or are we introducing 
| a bug? :-)
| 
| 	Ingo
| 

well, the last I would say :). That happened I sent first version of
patch instead of modified second version. Thanks a lot Ingo for catching
it! Oh my, sorry... Here is an updated version.
---

We use APIC_TDR_DIV_16 while setting APIC_TDCR (divisor).
It happened this moment is hidden from __setup_APIC_LVTT
caller. So we better increment caller 'clocks' value to
not change current behaviour and use APIC_DIVISOR
(as already done in 32bit version).

The main benefit - unified procedure code for 32/64bit modes.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>
---

Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-07-12 11:11:33.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-07-12 11:14:22.000000000 +0400
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
@@ -367,7 +370,7 @@ static void __init calibrate_APIC_clock(
 	lapic_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
-	calibration_result = result / HZ;
+	calibration_result = result * APIC_DIVISOR / HZ;
 }
 
 /*
