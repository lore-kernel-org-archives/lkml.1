Return-Path: <linux-kernel-owner+w=401wt.eu-S1422881AbXCGRRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422881AbXCGRRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422850AbXCGRQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:43441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422853AbXCGRQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:25 -0500
Message-Id: <20070307171447.165139421@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paul Mackerras <paulus@samba.org>
Subject: [patch 062/101] POWERPC: Fix performance monitor exception
Content-Disposition: inline; filename=powerpc-fix-performance-monitor-exception.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Livio Soares <livio@eecg.toronto.edu>

To the issue: some point during 2.6.20 development, Paul Mackerras
introduced the "lazy IRQ  disabling" patch (very cool work,  BTW).
In that patch, the performance monitor unit exception was marked as
"maskable", in the sense that if interrupts were soft-disabled, that
exception could be ignored.  This broke my PowerPC profiling code.
The symptom that I see is that a varying number of interrupts
(from 0 to $n$, typically closer to 0) get delivered, when, in
reality, it should always be very close to $n$.

The issue stems from the way masking is being done.   Masking in
this fashion seems to  work well with the decrementer and external
interrupts, because they are raised again until "really"  handled.
For the PMU, however, this does not apply (at least on my Xserver
machine with a 970FX processor).  If the PMU exception is not handled,
it will _not_ be re-raised (at least on my machine).  The documentation
states that the PMXE bit in MMCR0 is set to 0 when the PMU exception
is raised.  However, software must re-set the bit to re-enable PMU
exceptions.  If the exception is ignored (as currently) not only is
that interrupt lost, but because software does not re-set PMXE, the
PMU registers are "frozen" forever.

[This patch means that performance monitor exceptions are taken and
handled even if irqs are off, as long as some other interrupt hasn't
come along and caused interrupts to be hard-disabled.  In this sense
the PMU exception becomes like an NMI.  The oprofile code for most
powerpc processors does nothing that is unsafe in an NMI context, but
the Cell oprofile code does a spin_lock_irqsave.  However, that turns
out to be OK because Cell doesn't actually use the performance
monitor exception; performance monitor interrupts come in as a
regular interrupt on Cell, so will be disabled when irqs are off.
 -- paulus.]

From: Livio Soares <livio@eecg.toronto.edu>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/arch/powerpc/kernel/head_64.S
+++ linux-2.6.20.1/arch/powerpc/kernel/head_64.S
@@ -613,7 +613,7 @@ system_call_pSeries:
 /*** pSeries interrupt support ***/
 
 	/* moved from 0xf00 */
-	MASKABLE_EXCEPTION_PSERIES(., performance_monitor)
+	STD_EXCEPTION_PSERIES(., performance_monitor)
 
 /*
  * An interrupt came in while soft-disabled; clear EE in SRR1,

--
