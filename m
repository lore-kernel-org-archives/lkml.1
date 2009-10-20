Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZJTJTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZJTJTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 05:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZJTJTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 05:19:37 -0400
Received: from mga06.intel.com ([134.134.136.21]:61494 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750781AbZJTJTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 05:19:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,590,1249282800"; 
   d="scan'208";a="561374913"
Date: Tue, 20 Oct 2009 11:21:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       Tero Kristo <tero.kristo@nokia.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: twl4030-power: Optimised power scripts for
 the rx51
Message-ID: <20091020092133.GA5563@sortiz.org>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
 <1255954268-29162-1-git-send-email-amit.kucheria@verdurent.com>
 <20091019191536.GB30203@sortiz.org>
 <20091019232238.GX12576@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019232238.GX12576@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 04:22:39PM -0700, Tony Lindgren wrote:
> * Samuel Ortiz <sameo@linux.intel.com> [091019 12:15]:
> > Hi Amit,
> > 
> > On Mon, Oct 19, 2009 at 03:11:08PM +0300, Amit Kucheria wrote:
> > > The power scripts optimisation was mainly done by:
> > > Tero Kristo <tero.kristo@nokia.com> and
> > > Arnaud Mandy <ext-arnaud.2.mandy@nokia.com>
> > > 
> > > I'm only refactoring and testing it against the mainline kernel.
> > Fine with me but if you want me to carry this patch, I'd like to get an ACK
> > from Tony or one of the 2 above mentioned Nokia developers.
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
Thanks Amit, Tony. Patch applied.

Cheers,
Samuel.
  
> > Cheers,
> > Samuel.
> > 
> > 
> > > Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > Cc: Tero Kristo <tero.kristo@nokia.com>
> > > Cc: linux-omap@vger.kernel.org
> > > ---
> > >  arch/arm/mach-omap2/board-rx51-peripherals.c |  118 ++++++++++++++++++--------
> > >  1 files changed, 82 insertions(+), 36 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > index c1af532..d933050 100644
> > > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > @@ -292,15 +292,9 @@ static struct twl4030_usb_data rx51_usb_data = {
> > >  
> > >  static struct twl4030_ins sleep_on_seq[] __initdata = {
> > >  /*
> > > - * Turn off VDD1 and VDD2.
> > > + * Turn off everything
> > >   */
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_OFF), 4},
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_OFF), 2},
> > > -/*
> > > - * And also turn off the OMAP3 PLLs and the sysclk output.
> > > - */
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_OFF), 3},
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_OFF), 3},
> > > +	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 1, 0, RES_STATE_SLEEP), 2},
> > >  };
> > >  
> > >  static struct twl4030_script sleep_on_script __initdata = {
> > > @@ -311,14 +305,9 @@ static struct twl4030_script sleep_on_script __initdata = {
> > >  
> > >  static struct twl4030_ins wakeup_seq[] __initdata = {
> > >  /*
> > > - * Reenable the OMAP3 PLLs.
> > > - * Wakeup VDD1 and VDD2.
> > > - * Reenable sysclk output.
> > > + * Reenable everything
> > >   */
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_ACTIVE), 0x30},
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_ACTIVE), 0x30},
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_ACTIVE), 0x37},
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0x19, RES_STATE_ACTIVE), 3},
> > > +	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 1, 0, RES_STATE_ACTIVE), 2},
> > >  };
> > >  
> > >  static struct twl4030_script wakeup_script __initdata = {
> > > @@ -329,10 +318,9 @@ static struct twl4030_script wakeup_script __initdata = {
> > >  
> > >  static struct twl4030_ins wakeup_p3_seq[] __initdata = {
> > >  /*
> > > - * Wakeup VDD1 (dummy to be able to insert a delay)
> > > - * Enable CLKEN
> > > + * Reenable everything
> > >   */
> > > -	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_ACTIVE), 3},
> > > +	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 1, 0, RES_STATE_ACTIVE), 2},
> > >  };
> > >  
> > >  static struct twl4030_script wakeup_p3_script __initdata = {
> > > @@ -353,12 +341,11 @@ static struct twl4030_ins wrst_seq[] __initdata = {
> > >  	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_OFF), 2},
> > >  	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 0, 1, RES_STATE_ACTIVE),
> > >  		0x13},
> > > -	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 2, RES_STATE_WRST), 0x13},
> > >  	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 3, RES_STATE_OFF), 0x13},
> > >  	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD1, RES_STATE_WRST), 0x13},
> > >  	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD2, RES_STATE_WRST), 0x13},
> > >  	{MSG_SINGULAR(DEV_GRP_NULL, RES_VPLL1, RES_STATE_WRST), 0x35},
> > > -	{MSG_SINGULAR(DEV_GRP_P1, RES_HFCLKOUT, RES_STATE_ACTIVE), 2},
> > > +	{MSG_SINGULAR(DEV_GRP_P3, RES_HFCLKOUT, RES_STATE_ACTIVE), 2},
> > >  	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_ACTIVE), 2},
> > >  };
> > >  
> > > @@ -380,22 +367,81 @@ static struct twl4030_script *twl4030_scripts[] __initdata = {
> > >  };
> > >  
> > >  static struct twl4030_resconfig twl4030_rconfig[] __initdata = {
> > > -	{ .resource = RES_VINTANA1, .devgroup = -1, .type = -1, .type2 = 1 },
> > > -	{ .resource = RES_VINTANA2, .devgroup = -1, .type = -1, .type2 = 1 },
> > > -	{ .resource = RES_VINTDIG, .devgroup = -1, .type = -1, .type2 = 1 },
> > > -	{ .resource = RES_VMMC1, .devgroup = -1, .type = -1, .type2 = 3},
> > > -	{ .resource = RES_VMMC2, .devgroup = DEV_GRP_NULL, .type = -1,
> > > -	  .type2 = 3},
> > > -	{ .resource = RES_VAUX1, .devgroup = -1, .type = -1, .type2 = 3},
> > > -	{ .resource = RES_VAUX2, .devgroup = -1, .type = -1, .type2 = 3},
> > > -	{ .resource = RES_VAUX3, .devgroup = -1, .type = -1, .type2 = 3},
> > > -	{ .resource = RES_VAUX4, .devgroup = -1, .type = -1, .type2 = 3},
> > > -	{ .resource = RES_VPLL2, .devgroup = -1, .type = -1, .type2 = 3},
> > > -	{ .resource = RES_VDAC, .devgroup = -1, .type = -1, .type2 = 3},
> > > -	{ .resource = RES_VSIM, .devgroup = DEV_GRP_NULL, .type = -1,
> > > -	  .type2 = 3},
> > > -	{ .resource = RES_CLKEN, .devgroup = DEV_GRP_P3, .type = -1,
> > > -		.type2 = 1 },
> > > +	{ .resource = RES_VDD1, .devgroup = -1,
> > > +	  .type = 1, .type2 = -1, .remap_off = RES_STATE_OFF,
> > > +	  .remap_sleep = RES_STATE_OFF
> > > +	},
> > > +	{ .resource = RES_VDD2, .devgroup = -1,
> > > +	  .type = 1, .type2 = -1, .remap_off = RES_STATE_OFF,
> > > +	  .remap_sleep = RES_STATE_OFF
> > > +	},
> > > +	{ .resource = RES_VPLL1, .devgroup = -1,
> > > +	  .type = 1, .type2 = -1, .remap_off = RES_STATE_OFF,
> > > +	  .remap_sleep = RES_STATE_OFF
> > > +	},
> > > +	{ .resource = RES_VPLL2, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VAUX1, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VAUX2, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VAUX3, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VAUX4, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VMMC1, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VMMC2, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VDAC, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VSIM, .devgroup = -1,
> > > +	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VINTANA1, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
> > > +	  .type = -1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VINTANA2, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VINTDIG, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
> > > +	  .type = -1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_VIO, .devgroup = DEV_GRP_P3,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_CLKEN, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
> > > +	  .type = 1, .type2 = -1 , .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_REGEN, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_NRES_PWRON, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_SYSEN, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_HFCLKOUT, .devgroup = DEV_GRP_P3,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_32KCLKOUT, .devgroup = -1,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_RESET, .devgroup = -1,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > > +	{ .resource = RES_Main_Ref, .devgroup = -1,
> > > +	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
> > > +	},
> > >  	{ 0, 0},
> > >  };
> > >  
> > > -- 
> > > 1.6.3.3
> > > 
> > 
> > -- 
> > Intel Open Source Technology Centre
> > http://oss.intel.com/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
