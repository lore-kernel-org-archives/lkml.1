Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZHXMdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZHXMdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 08:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZHXMdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 08:33:52 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:53524 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZHXMdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:33:51 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Z/gvbdcnQmW2t/DANZunF
Date: Mon, 24 Aug 2009 15:33:46 +0300
From: Tony Lindgren <tony@atomide.com>
To: Samuel Ortiz <sameo@linux.intel.com>, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       "Peter 'p2' De Schrijver" <peter.de-schrijver@nokia.com>
Subject: Re: [PATCH 3/3] MFD: TWL4030: OMAP: Board-specifc DPS scripts for
	RX51 board
Message-ID: <20090824123346.GG7069@atomide.com>
References: <1247050179-31187-1-git-send-email-amit.kucheria@verdurent.com> <20090804180304.GI8601@sortiz.org> <20090817114651.GD5007@everest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817114651.GD5007@everest>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Amit Kucheria <amit.kucheria@verdurent.com> [090817 14:47]:
> On 09 Aug 04, Samuel Ortiz wrote:
> > Hi Amit,
> > 
> > On Wed, Jul 08, 2009 at 01:49:39PM +0300, Amit Kucheria wrote:
> > > Add support for Dynamic Power Switching (DPS) for the RX51 board.
> > Could I have an Acked-by from Tony or someone from Nokia maintaining this
> > board (e.g. Lauri) ?
> > 
> 
> I'll cc Tony in the refreshed patches. Please note that this is not the
> final version of the script. As the scripts are optimised, I'll send in
> fixes.

I'm fine with these, for the board specific configuration for twl4030,
Amit and Peter are the people to ack them.

Acked-by: Tony Lindgren <tony@atomide.com>



> 
> Regards,
> Amit
> 
> > > Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> > > ---
> > >  arch/arm/mach-omap2/board-rx51-peripherals.c |  122 +++++++++++++++++++++++++-
> > >  1 files changed, 120 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > index 9a0bf67..f7ebec8 100644
> > > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > @@ -1,5 +1,5 @@
> > >  /*
> > > - * linux/arch/arm/mach-omap2/board-rx51-flash.c
> > > + * linux/arch/arm/mach-omap2/board-rx51-peripherals.c
> > >   *
> > >   * Copyright (C) 2008-2009 Nokia
> > >   *
> > > @@ -278,7 +278,124 @@ static struct twl4030_gpio_platform_data rx51_gpio_data = {
> > >  	.setup			= rx51_twlgpio_setup,
> > >  };
> > >  
> > > -static struct twl4030_platform_data rx51_twldata = {
> > > +static struct twl4030_ins sleep_on_seq[] __initdata = {
> > > +/*
> > > + * Turn off VDD1 and VDD2.
> > > + */
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_OFF), 4},
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_OFF), 2},
> > > +/*
> > > + * And also turn off the OMAP3 PLLs and the sysclk output.
> > > + */
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_OFF), 3},
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_OFF), 3},
> > > +};
> > > +
> > > +static struct twl4030_script sleep_on_script __initdata = {
> > > +	.script = sleep_on_seq,
> > > +	.size   = ARRAY_SIZE(sleep_on_seq),
> > > +	.flags  = TRITON_SLEEP_SCRIPT,
> > > +};
> > > +
> > > +static struct twl4030_ins wakeup_seq[] __initdata = {
> > > +/*
> > > + * Reenable the OMAP3 PLLs.
> > > + * Wakeup VDD1 and VDD2.
> > > + * Reenable sysclk output.
> > > + */
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_ACTIVE), 0x30},
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_ACTIVE), 0x30},
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_ACTIVE), 0x37},
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0x19, RES_STATE_ACTIVE), 3},
> > > +};
> > > +
> > > +static struct twl4030_script wakeup_script __initdata = {
> > > +	.script	= wakeup_seq,
> > > +	.size	= ARRAY_SIZE(wakeup_seq),
> > > +	.flags	= TRITON_WAKEUP12_SCRIPT,
> > > +};
> > > +
> > > +static struct twl4030_ins wakeup_p3_seq[] __initdata = {
> > > +/*
> > > + * Wakeup VDD1 (dummy to be able to insert a delay)
> > > + * Enable CLKEN
> > > + */
> > > +	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_ACTIVE), 3},
> > > +};
> > > +
> > > +static struct twl4030_script wakeup_p3_script __initdata = {
> > > +	.script	= wakeup_p3_seq,
> > > +	.size	= ARRAY_SIZE(wakeup_p3_seq),
> > > +	.flags	= TRITON_WAKEUP3_SCRIPT,
> > > +};
> > > +
> > > +static struct twl4030_ins wrst_seq[] __initdata = {
> > > +/*
> > > + * Reset twl4030.
> > > + * Reset VDD1 regulator.
> > > + * Reset VDD2 regulator.
> > > + * Reset VPLL1 regulator.
> > > + * Enable sysclk output.
> > > + * Reenable twl4030.
> > > + */
> > > +	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_OFF), 2},
> > > +	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 0, 1, RES_STATE_ACTIVE),
> > > +		0x13},
> > > +	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 2, RES_STATE_WRST), 0x13},
> > > +	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 3, RES_STATE_OFF), 0x13},
> > > +	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD1, RES_STATE_WRST), 0x13},
> > > +	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD2, RES_STATE_WRST), 0x13},
> > > +	{MSG_SINGULAR(DEV_GRP_NULL, RES_VPLL1, RES_STATE_WRST), 0x35},
> > > +	{MSG_SINGULAR(DEV_GRP_P1, RES_HFCLKOUT, RES_STATE_ACTIVE), 2},
> > > +	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_ACTIVE), 2},
> > > +};
> > > +
> > > +static struct twl4030_script wrst_script __initdata = {
> > > +	.script = wrst_seq,
> > > +	.size   = ARRAY_SIZE(wrst_seq),
> > > +	.flags  = TRITON_WRST_SCRIPT,
> > > +};
> > > +
> > > +static struct twl4030_script *twl4030_scripts[] __initdata = {
> > > +	/* wakeup12 script should be loaded before sleep script, otherwise a
> > > +	   board might hit retention before loading of wakeup script is
> > > +	   completed. This can cause boot failures depending on timing issues.
> > > +	*/
> > > +	&wakeup_script,
> > > +	&sleep_on_script,
> > > +	&wakeup_p3_script,
> > > +	&wrst_script,
> > > +};
> > > +
> > > +static struct twl4030_resconfig twl4030_rconfig[] __initdata = {
> > > +	{ .resource = RES_VINTANA1, .devgroup = -1, .type = -1, .type2 = 1 },
> > > +	{ .resource = RES_VINTANA2, .devgroup = -1, .type = -1, .type2 = 1 },
> > > +	{ .resource = RES_VINTDIG, .devgroup = -1, .type = -1, .type2 = 1 },
> > > +	{ .resource = RES_VMMC1, .devgroup = -1, .type = -1, .type2 = 3},
> > > +	{ .resource = RES_VMMC2, .devgroup = DEV_GRP_NULL, .type = -1,
> > > +	  .type2 = 3},
> > > +	{ .resource = RES_VAUX1, .devgroup = -1, .type = -1, .type2 = 3},
> > > +	{ .resource = RES_VAUX2, .devgroup = -1, .type = -1, .type2 = 3},
> > > +	{ .resource = RES_VAUX3, .devgroup = -1, .type = -1, .type2 = 3},
> > > +	{ .resource = RES_VAUX4, .devgroup = -1, .type = -1, .type2 = 3},
> > > +	{ .resource = RES_VPLL2, .devgroup = -1, .type = -1, .type2 = 3},
> > > +	{ .resource = RES_VDAC, .devgroup = -1, .type = -1, .type2 = 3},
> > > +	{ .resource = RES_VSIM, .devgroup = DEV_GRP_NULL, .type = -1,
> > > +	  .type2 = 3},
> > > +	{ .resource = RES_CLKEN, .devgroup = DEV_GRP_P3, .type = -1,
> > > +		.type2 = 1 },
> > > +	{ 0, 0},
> > > +};
> > > +
> > > +static struct twl4030_power_data rx51_t2scripts_data __initdata = {
> > > +	.scripts        = twl4030_scripts,
> > > +	.size   = ARRAY_SIZE(twl4030_scripts),
> > > +	.resource_config = twl4030_rconfig,
> > > +};
> > > +
> > > +
> > > +
> > > +static struct twl4030_platform_data rx51_twldata __initdata = {
> > >  	.irq_base		= TWL4030_IRQ_BASE,
> > >  	.irq_end		= TWL4030_IRQ_END,
> > >  
> > > @@ -286,6 +403,7 @@ static struct twl4030_platform_data rx51_twldata = {
> > >  	.gpio			= &rx51_gpio_data,
> > >  	.keypad			= &rx51_kp_data,
> > >  	.madc			= &rx51_madc_data,
> > > +	.power			= &rx51_t2scripts_data,
> > >  
> > >  	.vaux1			= &rx51_vaux1,
> > >  	.vaux2			= &rx51_vaux2,
> > > -- 
> > > 1.6.3.3
> > > 
> > 
> > -- 
> > Intel Open Source Technology Centre
> > http://oss.intel.com/
> 
> -- 
> -------------------------------------------------------------------------
> Amit Kucheria,				 Kernel Developer, Verdurent
> -------------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
