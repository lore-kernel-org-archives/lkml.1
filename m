Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbXJXSLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbXJXSLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbXJXSLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:11:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39294 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbXJXSL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:11:29 -0400
Date: Wed, 24 Oct 2007 20:11:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] kvm: fix !SMP build error
Message-ID: <20071024181107.GA15250@elte.hu>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org> <471F03F5.7090608@qumranet.com> <20071024123258.GA28653@elte.hu> <20071024123650.GA31562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024123650.GA31562@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i have triggered this and fixed it the right way - see the patch 
> > below. This fixes the 2.6.24-rc1 build error.
> 
> and this followup patch is needed too if my patch is applied.

plus the patch below is needed too in addition.

	Ingo

------------->
Subject: x86: fix build error in arch/x86/kernel/nmi_32.c
From: Ingo Molnar <mingo@elte.hu>

nmi_cpu_busy() must be available on !SMP too.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/nmi_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/nmi_32.c
===================================================================
--- linux.orig/arch/x86/kernel/nmi_32.c
+++ linux/arch/x86/kernel/nmi_32.c
@@ -53,13 +53,13 @@ static int unknown_nmi_panic_callback(st
 
 static int endflag __initdata = 0;
 
-#ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
  * the CPU is idle. To make sure the NMI watchdog really ticks on all
  * CPUs during the test make them busy.
  */
 static __init void nmi_cpu_busy(void *data)
 {
+#ifdef CONFIG_SMP
 	local_irq_enable_in_hardirq();
 	/* Intentionally don't use cpu_relax here. This is
 	   to make sure that the performance counter really ticks,
@@ -69,8 +69,8 @@ static __init void nmi_cpu_busy(void *da
 	   care if they get somewhat less cycles. */
 	while (endflag == 0)
 		mb();
-}
 #endif
+}
 
 static int __init check_nmi_watchdog(void)
 {
