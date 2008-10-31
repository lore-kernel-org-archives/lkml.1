Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYJaWET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYJaWET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 18:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYJaWEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 18:04:08 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37935 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbYJaWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 18:04:05 -0400
Subject: Re: [VOYAGER] fix smp_intr_init() compile breakage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081030220338.GJ30303@elte.hu>
References: <1225400572.19324.13.camel@localhost.localdomain>
	 <20081030220338.GJ30303@elte.hu>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 13:59:49 -0400
Message-Id: <1225475989.3264.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 23:03 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > >From 4d4d1ebea1e30d0ea51784139f18aa15acbff5d9 Mon Sep 17 00:00:00 2001
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date: Wed, 29 Oct 2008 11:13:33 -0500
> > Subject: [VOYAGER] x86: fix smp_intr_init() compile breakage
> > 
> > Looks like this became static on the rest of x86.  Fix it up by adding
> > an external definition to mach-voyager/setup.c
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  arch/x86/mach-voyager/setup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
> > index 6bbdd63..7c6ff1a 100644
> > --- a/arch/x86/mach-voyager/setup.c
> > +++ b/arch/x86/mach-voyager/setup.c
> > @@ -24,6 +24,7 @@ static struct irqaction irq2 = {
> >  	.name = "cascade",
> >  };
> >  
> > +extern void smp_intr_init(void);
> >  void __init intr_init_hook(void)
> 
> please add function prototypes to the proper .h file. 
> (arch/x86/include/asm/voyager.h in this case)
> 
> I'd also suggest to rename the function to voyager_smp_intr_init(). 
> 
> Note that Voyager already has a voyager_smp_intr_init() prototype in 
> voyager.h. Something like the (completely untested) patch below.
> 
> 	Ingo
> 
> ---
>  arch/x86/mach-voyager/setup.c       |    2 +-
>  arch/x86/mach-voyager/voyager_smp.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
> index 6bbdd63..a580b95 100644
> --- a/arch/x86/mach-voyager/setup.c
> +++ b/arch/x86/mach-voyager/setup.c
> @@ -27,7 +27,7 @@ static struct irqaction irq2 = {
>  void __init intr_init_hook(void)
>  {
>  #ifdef CONFIG_SMP
> -	smp_intr_init();
> +	voyager_smp_intr_init();
>  #endif
>  
>  	setup_irq(2, &irq2);
> diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
> index ff2b2ed..95c9035 100644
> --- a/arch/x86/mach-voyager/voyager_smp.c
> +++ b/arch/x86/mach-voyager/voyager_smp.c
> @@ -1250,7 +1250,7 @@ static void handle_vic_irq(unsigned int irq, struct irq_desc *desc)
>  #define QIC_SET_GATE(cpi, vector) \
>  	set_intr_gate((cpi) + QIC_DEFAULT_CPI_BASE, (vector))
>  
> -void __init smp_intr_init(void)
> +void __init voyager_smp_intr_init(void)
>  {
>  	int i;

Not quite: still get the undeclared function in setup.c.  However, this
should work (also untested: I'm in flight at the moment).

James

---

diff --git a/arch/x86/include/asm/voyager.h b/arch/x86/include/asm/voyager.h
index 9c811d2..b3e6473 100644
--- a/arch/x86/include/asm/voyager.h
+++ b/arch/x86/include/asm/voyager.h
@@ -520,6 +520,7 @@ extern void voyager_restart(void);
 extern void voyager_cat_power_off(void);
 extern void voyager_cat_do_common_interrupt(void);
 extern void voyager_handle_nmi(void);
+extern void voyager_smp_intr_init(void);
 /* Commands for the following are */
 #define	VOYAGER_PSI_READ	0
 #define VOYAGER_PSI_WRITE	1
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
index 0f6e8a6..593967b 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1248,7 +1248,7 @@ static void handle_vic_irq(unsigned int irq, struct irq_desc *desc)
 #define QIC_SET_GATE(cpi, vector) \
 	set_intr_gate((cpi) + QIC_DEFAULT_CPI_BASE, (vector))
 
-void __init smp_intr_init(void)
+void __init voyager_smp_intr_init(void)
 {
 	int i;
 


