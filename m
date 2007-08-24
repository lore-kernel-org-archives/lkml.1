Return-Path: <linux-kernel-owner+w=401wt.eu-S1764002AbXHXHaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764002AbXHXHaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXHXHaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:30:05 -0400
Received: from za-gw.sanpeople.com ([196.211.225.226]:35318 "EHLO
	za-gw.sanpeople.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXHXHaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:30:02 -0400
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
From: Andrew Victor <andrew@sanpeople.com>
To: Michel Benoit <murpme@gmail.com>
Cc: Pierre Savary <pierre.savary@kerlink.fr>,
       Marc Pignat <marc.pignat@hevs.ch>,
       =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       trivial@kernel.org, linux-kernel@vger.kernel.org,
       Andy Herzig <andrew.herzig@ngc.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <c88e466f0708100300l401ef479sbce5eed22b869de2@mail.gmail.com>
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com>
	 <018a01c7dad3$10ca8190$dcc4af0a@atmel.com>
	 <200708100912.35485.hjk@linutronix.de>
	 <200708100933.46235.marc.pignat@hevs.ch> <3858727143598039860@unknownmsgid>
	 <c88e466f0708100300l401ef479sbce5eed22b869de2@mail.gmail.com>
Content-Type: text/plain
Organization: Multenet Technologies (Pty) Ltd
Message-Id: <1187939507.28770.130.camel@fuzzie.sanpeople.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 
Date: 24 Aug 2007 09:11:48 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> > About SDRAm self refresh mode on at91sam926x, in fact AT91_SDRAMC_SRR
> > doesn't exist but the new register is AT91_SDRAMC_LPR. So for instance, you
> > can replace at91_sys_write(AT91_SDRAMC_SRR, 1) by
> > at91_sys_write(AT91_SDRAMC_LPR, AT91_SDRAMC_LPCB_SELF_REFRESH).
> 
> I have also made that change in pm.c.

I think we will go with the following change for now.
We need to pull in different header files anyway.

(This file will need to be re-looked at if we ever allow compiling a
single kernel image that supports multiple AT91 processors)


--- pm.c	6 Jul 2007 09:18:01 -0000	1.5
+++ pm.c	24 Aug 2007 07:22:13 -0000
@@ -27,12 +27,24 @@
 #include <asm/mach-types.h>
 
 #include <asm/arch/at91_pmc.h>
-#include <asm/arch/at91rm9200_mc.h>
 #include <asm/arch/gpio.h>
 #include <asm/arch/cpu.h>
 
 #include "generic.h"
 
+#ifdef CONFIG_ARCH_AT91RM9200
+#include <asm/arch/at91rm9200_mc.h>
+
+#define sdram_selfrefresh_enable()	at91_sys_write(AT91_SDRAMC_SRR, 1)
+#define sdram_selfrefresh_disable()
+
+#else
+#include <asm/arch/at91sam926x_mc.h>
+
+#define sdram_selfrefresh_enable()	at91_sys_write(AT91_SDRAMC_LPR, AT91_SDRAMC_LPCB_SELF_REFRESH)
+#define sdram_selfrefresh_disable()	at91_sys_write(AT91_SDRAMC_LPR, AT91_SDRAMC_LPCB_DISABLE)
+
+#endif
 
 static int at91_pm_valid_state(suspend_state_t state)
 {
@@ -172,7 +184,7 @@
 			 */
 			asm("b 1f; .align 5; 1:");
 			asm("mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */
-			at91_sys_write(AT91_SDRAMC_SRR, 1);	/* self-refresh mode */
+			sdram_selfrefresh_enable();		/* self-refresh mode */
 			/* fall though to next state */
 
 		case PM_SUSPEND_ON:
@@ -188,6 +200,7 @@
 			at91_sys_read(AT91_AIC_IPR) & at91_sys_read(AT91_AIC_IMR));
 
 error:
+	sdram_selfrefresh_disable();
 	target_state = PM_SUSPEND_ON;
 	at91_irq_resume();
 	at91_gpio_resume();


Regards,
  Andrew Victor


