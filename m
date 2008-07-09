Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYGITCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYGITCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYGITCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:02:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:14226 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYGITCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=goNWgqOrzuz68t4Z/vAl3RTkCkmKW1U11YfjkEGbrlN481uw/8mRl2EQHjM0DfDbK4
         NfB1CvmXYCoECV/O7Gzx7tmE+anwTiiSkBMnhXlDnTZVG87XFJtO/yVwLUx+CenKWX9L
         aPwnVZM0qDBS7230Dty2sz+GIRr+Axf7RjNnM=
Date: Wed, 9 Jul 2008 23:02:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: apic LVTT - use APIC_DIVISOR on 64bit mode
Message-ID: <20080709190237.GA21423@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use APIC_TDR_DIV_16 while setting APIC_TDCR (divisor)
it happened this moment is hidden from __setup_APIC_LVTT
caller. So we better increment caller 'clocks' value to
not change current behaviour and use APIC_DIVISOR
(as already done in 32bit version).

The main benefit - unified procedure code for 32/64bit modes.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>
---

Please review carefully. Any comments are welcome.
I'm _not_ 100% sure if this patch is safe.

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
