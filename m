Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYKIK74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYKIK74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbYKIK7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:59:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:56555 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYKIK7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=bbzYqH9+lC894uqJvx7nJ2AwKQfE6pMU1KDK6SlwQ7Vapb1BXpE9JakWETtBrNogQr
         pvbcI2DdR/pbEosnarZxK7xCmfvVNVWy/VEUD9mS8fAsgvvafo6O4OO2G1lJVD0TrmMV
         E/ef73hTDWKXiNsu7IXR4hJx3QmezDzxE/HiE=
References: <20081109105709.222708517@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: apic - calibrate_APIC_clock remove redundant irq-enable-disable
Content-Disposition: inline; filename=x86-apic-calibrate_APIC_clock-irq-cleanup
Message-ID: <4916c290.0437560a.270e.0940@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

lapic_timer_setup is self-protected with local_irq_save/restore
no need to use them in caller and levt is the per-cpu variable so
no concurrent access from another cpu.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic.c
@@ -672,13 +672,9 @@ static int __init calibrate_APIC_clock(v
 		while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
 			cpu_relax();
 
-		local_irq_disable();
-
 		/* Stop the lapic timer */
 		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
 
-		local_irq_enable();
-
 		/* Jiffies delta */
 		deltaj = lapic_cal_j2 - lapic_cal_j1;
 		apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);

-- 
