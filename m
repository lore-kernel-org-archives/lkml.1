Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab0BYSx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:53:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60711 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759356Ab0BYSxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:53:55 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Tony Lindgren <tony@atomide.com>, Thomas Weber <swirl@gmx.li>,
       "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Pandita, Vikram" <vikram.pandita@ti.com>,
       "Syed, Rafiuddin" <rafiuddin.syed@ti.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Weber <weber@corscience.de>
Date: Fri, 26 Feb 2010 00:23:30 +0530
Subject: RE: [RESEND][PATCH/RFC] OMAP2: serial.c: Fix number of uarts in
 early_init
Thread-Topic: [RESEND][PATCH/RFC] OMAP2: serial.c: Fix number of uarts in
 early_init
Thread-Index: Acq2SmCutHQ58pUlSdCS62ooI7Cv8QAAN4jQ
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C43BF5EC@dbde02.ent.ti.com>
References: <1267090819-17796-1-git-send-email-swirl@gmx.li>
 <20100225184355.GF28173@atomide.com>
In-Reply-To: <20100225184355.GF28173@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Tony Lindgren [mailto:tony@atomide.com]
> Sent: Friday, February 26, 2010 12:14 AM
> To: Thomas Weber; Aguirre, Sergio
> Cc: linux-omap@vger.kernel.org; Russell King; Kevin Hilman; Shilimkar, Santosh; Pandita, Vikram;
> Syed, Rafiuddin; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Thomas Weber
> Subject: Re: [RESEND][PATCH/RFC] OMAP2: serial.c: Fix number of uarts in early_init
> 
> * Thomas Weber <swirl@gmx.li> [100225 01:36]:
> >
> > The omap_serial_early_init prints the following errors:
> >
> > Could not get uart4_ick
> > Could not get uart4_fck
> >
> > because all the uarts available in omap_uart[] will be initialized.
> > Only omap4430 and omap3630 have 4 uarts at the moment.
> > This patch reduces the number of uarts when cpu is not omap4430 or
> > omap3630.
> 
> ..and I only patched omap_serial_init and forgot about
> the omap_serial_early_init..
> 
> Looks good to me, Sergio, care to test and Ack this? Also, sounds
> like we still need to patch omap4 for uart4 for the clocks.
> 
Clocks will be take care automatically by "nr_ports" for omap4 too
with this patch. Below clock changes are just cosmetic ones, isn't it ?

Am I missing something?

> Regards,
> 
> Tony
> 
> > Signed-off-by: Thomas Weber <weber@corscience.de>
> > ---
> >  arch/arm/mach-omap2/serial.c |   15 ++++++++++-----
> >  1 files changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
> > index b79bc89..da77930 100644
> > --- a/arch/arm/mach-omap2/serial.c
> > +++ b/arch/arm/mach-omap2/serial.c
> > @@ -644,16 +644,21 @@ static void serial_out_override(struct uart_port *up, int offset, int value)
> >  }
> >  void __init omap_serial_early_init(void)
> >  {
> > -	int i;
> > +	int i, nr_ports;
> >  	char name[16];
> >
> > +	if (!(cpu_is_omap3630() || cpu_is_omap4430()))
> > +		nr_ports = 3;
> > +	else
> > +		nr_ports = ARRAY_SIZE(omap_uart);
> > +
> >  	/*
> >  	 * Make sure the serial ports are muxed on at this point.
> >  	 * You have to mux them off in device drivers later on
> >  	 * if not needed.
> >  	 */
> >
> > -	for (i = 0; i < ARRAY_SIZE(omap_uart); i++) {
> > +	for (i = 0; i < nr_ports; i++) {
> >  		struct omap_uart_state *uart = &omap_uart[i];
> >  		struct platform_device *pdev = &uart->pdev;
> >  		struct device *dev = &pdev->dev;
> > @@ -669,17 +674,17 @@ void __init omap_serial_early_init(void)
> >  			continue;
> >  		}
> >
> > -		sprintf(name, "uart%d_ick", i+1);
> > +		sprintf(name, "uart%d_ick", i + 1);
> >  		uart->ick = clk_get(NULL, name);
> >  		if (IS_ERR(uart->ick)) {
> > -			printk(KERN_ERR "Could not get uart%d_ick\n", i+1);
> > +			printk(KERN_ERR "Could not get uart%d_ick\n", i + 1);
> >  			uart->ick = NULL;
> >  		}
> >
> >  		sprintf(name, "uart%d_fck", i+1);
> >  		uart->fck = clk_get(NULL, name);
> >  		if (IS_ERR(uart->fck)) {
> > -			printk(KERN_ERR "Could not get uart%d_fck\n", i+1);
> > +			printk(KERN_ERR "Could not get uart%d_fck\n", i + 1);
> >  			uart->fck = NULL;
> >  		}
> >
> > --
> > 1.6.4.4
> >
