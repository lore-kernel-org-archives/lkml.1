Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYJ3WEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYJ3WEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYJ3WDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:03:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56429 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbYJ3WDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:03:55 -0400
Date: Thu, 30 Oct 2008 23:03:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [VOYAGER] fix smp_intr_init() compile breakage
Message-ID: <20081030220338.GJ30303@elte.hu>
References: <1225400572.19324.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225400572.19324.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> >From 4d4d1ebea1e30d0ea51784139f18aa15acbff5d9 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 29 Oct 2008 11:13:33 -0500
> Subject: [VOYAGER] x86: fix smp_intr_init() compile breakage
> 
> Looks like this became static on the rest of x86.  Fix it up by adding
> an external definition to mach-voyager/setup.c
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  arch/x86/mach-voyager/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
> index 6bbdd63..7c6ff1a 100644
> --- a/arch/x86/mach-voyager/setup.c
> +++ b/arch/x86/mach-voyager/setup.c
> @@ -24,6 +24,7 @@ static struct irqaction irq2 = {
>  	.name = "cascade",
>  };
>  
> +extern void smp_intr_init(void);
>  void __init intr_init_hook(void)

please add function prototypes to the proper .h file. 
(arch/x86/include/asm/voyager.h in this case)

I'd also suggest to rename the function to voyager_smp_intr_init(). 

Note that Voyager already has a voyager_smp_intr_init() prototype in 
voyager.h. Something like the (completely untested) patch below.

	Ingo

---
 arch/x86/mach-voyager/setup.c       |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 6bbdd63..a580b95 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -27,7 +27,7 @@ static struct irqaction irq2 = {
 void __init intr_init_hook(void)
 {
 #ifdef CONFIG_SMP
-	smp_intr_init();
+	voyager_smp_intr_init();
 #endif
 
 	setup_irq(2, &irq2);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index ff2b2ed..95c9035 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1250,7 +1250,7 @@ static void handle_vic_irq(unsigned int irq, struct irq_desc *desc)
 #define QIC_SET_GATE(cpi, vector) \
 	set_intr_gate((cpi) + QIC_DEFAULT_CPI_BASE, (vector))
 
-void __init smp_intr_init(void)
+void __init voyager_smp_intr_init(void)
 {
 	int i;
 
