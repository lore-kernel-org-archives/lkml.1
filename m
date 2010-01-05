Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757Ab0AESOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0AESOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561Ab0AESOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:14:15 -0500
Received: from mga10.intel.com ([192.55.52.92]:23584 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754475Ab0AESOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:14:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,507,1257148800"; 
   d="scan'208";a="761522301"
Date: Tue, 5 Jan 2010 19:15:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion
 between read and write value of two bits in POWER_MISCELLANEUS register.
Message-ID: <20100105181541.GE4274@sortiz.org>
References: <1260808880.2022.98.camel@climbing-alby>
 <1260810776.2022.130.camel@climbing-alby>
 <4B26799F.1020507@ru.mvista.com>
 <1260813540.2022.174.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260813540.2022.174.camel@climbing-alby>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alberto,

On Mon, Dec 14, 2009 at 06:59:00PM +0100, Alberto Panizzo wrote:
> Il giorno lun, 14/12/2009 alle 20.45 +0300, Sergei Shtylyov ha scritto:
> > > +     if (offset == MC13783_REG_POWER_MISCELLANEOUS)
> > > +             buf &= !(MC13783_REGCTRL_PWGT1SPIEN |
> > >   
> > 
> >    Are you sure ! shouldn't be ~ here?
> > 
> > > +                      MC13783_REGCTRL_PWGT2SPIEN);
> > >   
> > 
> >    !(MC13783_REGCTRL_PWGT1SPIEN | MC13783_REGCTRL_PWGT2SPIEN) would 
> > evaluate to 0 which is most probably not what you want.
> > 
> > WBR, Sergei 
> 
> For sure, you are right. The correct patch below..
> 
> PWGT1DRV and PWGT1DRV are two digital output controlled by two corresponding
> hardware signals (Pin PWGTnEN) that are meant to be used to control core power
> supplies.
> The register MC13783_REG_POWER_MISCELLANEOUS contain the two control and
> status bit (PWGTnSPIEN) where write and read meaning is summarised by 
> the following table:
> 
>  Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
>    0 = default  |             |          | PWGTxSPIEN
>  ---------------+-------------+----------+------------
>        1        |      x      |   Low    |     0
>        0        |      0      |   High   |     1
>        0        |      1      |   Low    |     0
> 
> Writing a 1 to those bits will turn off the corresponding core
> power supply. As there is no way to read back the value of 
> PWGTnSPIEN, 
Nice hardware :(


> the behaviour chosen is to let always the hardware
> control itself leaving those bits at the default value.
> 
> This patch is especially needed for manipulate the other bits
> in the same register, where the read-modify-write operation
> can produce unwanted power fault.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
>  drivers/mfd/mc13783-core.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
> index a1ade23..3953297 100644
> --- a/drivers/mfd/mc13783-core.c
> +++ b/drivers/mfd/mc13783-core.c
> @@ -171,6 +171,9 @@ int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
>  }
>  EXPORT_SYMBOL(mc13783_reg_read);
>  
> +#define MC13783_REG_POWER_MISCELLANEOUS        34
> +#define MC13783_REGCTRL_PWGT1SPIEN     (1 << 15)
> +#define MC13783_REGCTRL_PWGT2SPIEN     (1 << 16)
>  int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
>  {
>         u32 buf;
> @@ -187,6 +190,13 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
>  
>         buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
>  
> +       /* Take care of table 4-24 in Freescale MC13783IGPLDRM.pdf making
> +        * the assumption that PWGTnDRV signals controls core power supplies
> +        * that software must not disable. */
> +       if (offset == MC13783_REG_POWER_MISCELLANEOUS)
> +               buf &= ~(MC13783_REGCTRL_PWGT1SPIEN |
> +                        MC13783_REGCTRL_PWGT2SPIEN);
> +
Although I see where you want to go, I dont really enjoy that solution.
I would prefere to have specific register write/rmw routines for
MC13783_REG_POWER_MISCELLANEOUS, and at the same time forbid to access the
latter from the current mc13783_reg_* API.

Cheers,
Samuel.


>         memset(&t, 0, sizeof(t));
>  
>         t.tx_buf = &buf;
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
