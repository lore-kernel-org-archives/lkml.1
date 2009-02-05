Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZBEO0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZBEO0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZBEO0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:26:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46359 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZBEO0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:26:24 -0500
Date: Thu, 5 Feb 2009 15:26:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perfcounters: fix "perf counters kills oprofile" bug
Message-ID: <20090205142607.GC28443@elte.hu>
References: <1233813650.9044.29.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233813650.9044.29.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Impact: fix "perf counters kills oprofile" bug
> 
> Both oprofile and perfcounters register an NMI die handler, but only one
> can handle the NMI.  Conveniently, oprofile unregisters it's notifier
> when not actively in use, so setting it's notifier priority higher than
> perfcounter's allows oprofile to borrow the NMI for the duration of it's
> run.  Tested/works both as module and built-in.
> 
> While testing, I found that if kerneltop was generating NMIs at very
> high frequency, the kernel may panic when oprofile registered it's
> handler.  This turned out to be because oprofile registers it's handler
> before reset_value has been allocated, so if an NMI comes in while it's
> still setting up, kabOom.  Rather than try more invasive changes, I
> followed the lead of other places in op_model_ppro.c, and simply
> returned in that highly unlikely event.  (debug warnings attached)

applied to tip:perfcounters/core, thanks Mike!

> I can break this into two patches if you prefer, but since the panic was 
> initiated by borrowing the active NMI, I figured they belong together.

No need, it's fine this way. Note that there's two commits from you: i 
applied your earier fix of this already, and now i did a delta patch of the 
other bug you found. The delta patch i have applied is below.

Thanks,

	Ingo

--------------------->
>From 82aa9a1829199233f9bdaf26e2ee271114f4701e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 5 Feb 2009 15:23:08 +0100
Subject: [PATCH] perfcounters: fix "perf counters kills oprofile" bug, v2

Impact: fix kernel crash

Both oprofile and perfcounters register an NMI die handler, but only one
can handle the NMI.  Conveniently, oprofile unregisters it's notifier
when not actively in use, so setting it's notifier priority higher than
perfcounter's allows oprofile to borrow the NMI for the duration of it's
run.  Tested/works both as module and built-in.

While testing, I found that if kerneltop was generating NMIs at very
high frequency, the kernel may panic when oprofile registered it's
handler.  This turned out to be because oprofile registers it's handler
before reset_value has been allocated, so if an NMI comes in while it's
still setting up, kabOom.  Rather than try more invasive changes, I
followed the lead of other places in op_model_ppro.c, and simply
returned in that highly unlikely event.  (debug warnings attached)

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/oprofile/op_model_ppro.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 07c9145..85eb626 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -126,6 +126,13 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
+	/*
+	 * This can happen if perf counters are in use when
+	 * we steal the die notifier NMI.
+	 */
+	if (unlikely(!reset_value))
+		goto out;
+
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -136,6 +143,7 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
+out:
 	/* Only P6 based Pentium M need to re-unmask the apic vector but it
 	 * doesn't hurt other P6 variant */
 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
