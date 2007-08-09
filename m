Return-Path: <linux-kernel-owner+w=401wt.eu-S939277AbXHIQXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939277AbXHIQXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934583AbXHIQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:23:31 -0400
Received: from mail.hevs.ch ([153.109.23.15]:56382 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934526AbXHIQXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:23:30 -0400
X-Greylist: delayed 1327 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 12:23:30 EDT
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
Date: Thu, 9 Aug 2007 18:01:19 +0200
User-Agent: KMail/1.9.5
Cc: =?iso-8859-15?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       Andy Herzig <andrew.herzig@ngc.com>, andrew@sanpeople.com,
       trivial@kernel.org, linux-kernel@vger.kernel.org
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com> <200708091653.35226.hjk@linutronix.de>
In-Reply-To: <200708091653.35226.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708091801.20077.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Thursday 09 August 2007 16:53, Hans-Jürgen Koch wrote:
> (added linux-arm-kernel to CC)
> 
> Am Donnerstag 09 August 2007 14:10 schrieb Andy Herzig:
> > Hello all,
> > 
> > This patch is intended to fix compilation errors when I tried to add in
> > power management to my Atmel AT91SAM9260 board. First, there is no
> > separate memory controller in the 9260 as there is in the 9200, so calls
> > to do anything with it in pm.c fail.
> 
> Correct. I made the same discovery with my AT91SAM9263 board.
> 
> > 
> > Secondly, at91_suspend_entering_slow_clock() is not declared extern by
> > drivers that use it. This used to cause only a warning, but in
> > 2.6.23-rc1 and beyond, it is an error.
> 
> Patch looks good to me. Kernel compiles for my 9263. Didn't test
> suspend/resume yet, though.
> 
> > 
> > Signed-off-by: Andrew J. Herzig <andrew.herzig@ngc.com>
> 
> Acked-by: Hans J. Koch <hjk@linutronix.de>
> 
> 
> > ---
> > arch/arm/mach-at91/pm.c       |    5 ++++-
> > drivers/serial/atmel_serial.c |    2 ++
> > drivers/usb/gadget/at91_udc.c |    2 ++
> > drivers/usb/host/ohci-at91.c  |    1 +
> > 4 files changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff -uprN -X linux-2.6.23-rc2/Documentation/dontdiff
> > linux-2.6.23-rc2-vanilla/arch/arm/mach-at91/pm.c
> > linux-2.6.23-rc2/arch/arm/mach-at91/pm.c
> > --- linux-2.6.23-rc2-vanilla/arch/arm/mach-at91/pm.c    2007-08-08
> > 13:28:37.000000000 -0400
> > +++ linux-2.6.23-rc2/arch/arm/mach-at91/pm.c    2007-08-08
> > 13:36:43.000000000 -0400
> > @@ -176,7 +176,9 @@ static int at91_pm_enter(suspend_state_t
> >                          */
> >                         asm("b 1f; .align 5; 1:");
> >                         asm("mcr p15, 0, r0, c7, c10, 4");      /* drain
> > write buffer */
> > +#if defined(CONFIG_ARCH_AT91RM9200)
> >                         at91_sys_write(AT91_SDRAMC_SRR, 1);     /*
> > self-refresh mode */
Why don't use:
if (cpu_is_at91rm9200())
	at91_sys_write(AT91_SDRAMC_SRR, 1);

> > +#endif
> >                         /* fall though to next state */
> >  
> >                 case PM_SUSPEND_ON:
> > @@ -218,8 +220,9 @@ static int __init at91_pm_init(void)
> >  #endif
> >  
> >         /* Disable SDRAM low-power mode.  Cannot be used with
> > self-refresh. */
> > +#if defined(CONFIG_ARCH_AT91RM9200)
> >         at91_sys_write(AT91_SDRAMC_LPR, 0);
> > -
> > +#endif
same comment

...
> > --- linux-2.6.23-rc2-vanilla/drivers/serial/atmel_serial.c
> > 2007-08-08 13:28:33.000000000 -0400
> > +++ linux-2.6.23-rc2/drivers/serial/atmel_serial.c      2007-08-08
> > 13:32:52.000000000 -0400
> > @@ -916,6 +916,8 @@ static struct uart_driver atmel_uart = {
> >  };
> >  
> >  #ifdef CONFIG_PM
> > +extern int at91_suspend_entering_slow_clock(void);
> > +
> >  static int atmel_serial_suspend(struct platform_device *pdev,
> > pm_message_t state)
> >  {
> >         struct uart_port *port = platform_get_drvdata(pdev);
> > diff -uprN -X linux-2.6.23-rc2/Documentation/dontdiff
> > linux-2.6.23-rc2-vanilla/drivers/usb/gadget/at91_udc.c
> > linux-2.6.23-rc2/drivers/usb/gadget/at91_udc.c 
> > --- linux-2.6.23-rc2-vanilla/drivers/usb/gadget/at91_udc.c
> > 2007-08-08 13:28:27.000000000 -0400
> > +++ linux-2.6.23-rc2/drivers/usb/gadget/at91_udc.c      2007-08-08
> > 13:33:21.000000000 -0400
> > @@ -1770,6 +1770,8 @@ static int __exit at91udc_remove(struct 
> >  }
> >  
> >  #ifdef CONFIG_PM
> > +extern int at91_suspend_entering_slow_clock(void);
> > +
> >  static int at91udc_suspend(struct platform_device *pdev, pm_message_t
> > mesg)
> >  {
> >         struct at91_udc *udc = platform_get_drvdata(pdev);
> > diff -uprN -X linux-2.6.23-rc2/Documentation/dontdiff
> > linux-2.6.23-rc2-vanilla/drivers/usb/host/ohci-at91.c
> > linux-2.6.23-rc2/drivers/usb/host/ohci-at91.c
> > --- linux-2.6.23-rc2-vanilla/drivers/usb/host/ohci-at91.c
> > 2007-08-08 13:28:27.000000000 -0400
> > +++ linux-2.6.23-rc2/drivers/usb/host/ohci-at91.c       2007-08-08
> > 13:32:45.000000000 -0400
> > @@ -282,6 +282,7 @@ static int ohci_hcd_at91_drv_remove(stru
> >  }
> >  
> >  #ifdef CONFIG_PM
> > +extern int at91_suspend_entering_slow_clock(void);
Why do you define 3 times this function?
Can't you place it in a .h?

Regards

Marc


