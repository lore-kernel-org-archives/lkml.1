Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbZLNRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbZLNRqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbZLNRqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:46:24 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:10881 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932252AbZLNRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:46:23 -0500
Message-ID: <4B26799F.1020507@ru.mvista.com>
Date: Mon, 14 Dec 2009 20:45:03 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion between
 read and write value of two bits in POWER_MISCELLANEUS register.
References: <1260808880.2022.98.camel@climbing-alby> <1260810776.2022.130.camel@climbing-alby>
In-Reply-To: <1260810776.2022.130.camel@climbing-alby>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Panizzo wrote:
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
> PWGTnSPIEN, the behaviour chosen is to let always the hardware
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
> +#define MC13783_REG_POWER_MISCELLANEOUS	34
> +#define MC13783_REGCTRL_PWGT1SPIEN	(1 << 15)
> +#define MC13783_REGCTRL_PWGT2SPIEN	(1 << 16)
>  int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
>  {
>  	u32 buf;
> @@ -187,6 +190,13 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
>  
>  	buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
>  
> +	/* Take care of table 4-24 in Freescale MC13783IGPLDRM.pdf making
> +	 * the assumption that PWGTnDRV signals controls core power supplies
> +	 * that software must not disable. */
> +	if (offset == MC13783_REG_POWER_MISCELLANEOUS)
> +		buf &= !(MC13783_REGCTRL_PWGT1SPIEN |
>   

   Are you sure ! shouldn't be ~ here?

> +			 MC13783_REGCTRL_PWGT2SPIEN);
>   

   !(MC13783_REGCTRL_PWGT1SPIEN | MC13783_REGCTRL_PWGT2SPIEN) would 
evaluate to 0 which is most probably not what you want.

WBR, Sergei

