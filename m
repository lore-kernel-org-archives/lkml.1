Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842Ab0ASK1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0ASK1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 05:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606Ab0ASK1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 05:27:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:5255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0ASK1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 05:27:02 -0500
Subject: Re: [PATCH] regulator: mc13783: consider Power Gates as digital
 regulators.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1263848512.3632.74.camel@realization>
References: <1263830523.3632.22.camel@realization>
	 <20100118190445.GA16989@pengutronix.de>
	 <1263848512.3632.74.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 10:26:56 +0000
Message-ID: <1263896816.3089.40.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks a lot better. Just one question below.

On Mon, 2010-01-18 at 22:01 +0100, Alberto Panizzo wrote:
> On lun, 2010-01-18 at 20:04 +0100, Uwe Kleine-König wrote:
> > Hello Alberto,
> Hello Uwe!
> 
> > 
> > Can you post an updated patch addressing the discussion with Mark,
> > please?
> > 
> > From the first look I don't like the name
> > MC13783_REG_POWERMISC_PWGTSPI_M as I don't understand it's purpose
> 
> >From now the present driver naming schema is mask ends in _M.
> 
> > 
> > What is the base for your patch?  (Hm, it seems next could work.
> 
> Yes, this patch is based on: 
> git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-next
> 
> > mc13783-regulator seems to have gotten some more #defines ending in _M.
> > You seem to mean "mask".  IMHO it's a bit unfortunate, because the
> > nameing scheme doesn't match the already existing names :-()
> 
> If the naming schema adopted, conflicts other I will propose a correction..
> 
> > 
> > Shouldn't mc13783_state_powermisc_pwgt be a per-device variable instead
> > of a static variable?
> 
> Thanks for point me out this. It should.
> 
> 
> the new patch below:
> 
> --------------------------------------------------------------------------
> GPO regulators are digital outputs that can be enabled or disabled by a
> dedicated bit in mc13783 POWERMISC register.
> In this family can be count in also Power Gates (PWGT1 and 2): enabled by
> a dedicated pin a Power Gate is an hardware driven supply where the output
> (PWGTnDRV) follow this law:
> 
>  Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
>    0 = default  |             |          | PWGTxSPIEN
>  ---------------+-------------+----------+------------
>        1        |      x      |   Low    |     0
>        0        |      0      |   High   |     1
>        0        |      1      |   Low    |     0
> 
> As read back value of control bit reflects the PWGTxDRV state (not the
> control value previously written) and mc13783 POWERMISC register contain
> only regulator related bits, a dedicated function to manage these bits is 
> created here with the aim of tracing the real value of PWGTxSPIEN bits
> and reproduce it on next writes.
> 
> All POWERMISC users _must_ use the new function to not accidentally
> disable Power Gates supplies.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
>  drivers/regulator/mc13783-regulator.c |  109 ++++++++++++++++++++++++++++++++-
>  include/linux/mfd/mc13783.h           |    2 +
>  2 files changed, 110 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
> index a40e35a..555eb29 100644
> --- a/drivers/regulator/mc13783-regulator.c
> +++ b/drivers/regulator/mc13783-regulator.c
> @@ -82,6 +82,11 @@
>  #define MC13783_REG_POWERMISC_GPO2EN			(1 << 8)
>  #define MC13783_REG_POWERMISC_GPO3EN			(1 << 10)
>  #define MC13783_REG_POWERMISC_GPO4EN			(1 << 12)
> +#define MC13783_REG_POWERMISC_PWGT1SPIEN		(1 << 15)
> +#define MC13783_REG_POWERMISC_PWGT2SPIEN		(1 << 16)
> +
> +#define MC13783_REG_POWERMISC_PWGTSPI_M			(3 << 15)
> +
>  
>  struct mc13783_regulator {
>  	struct regulator_desc desc;
> @@ -163,6 +168,7 @@ static const int const mc13783_vrf_val[] = {
>  
>  static struct regulator_ops mc13783_regulator_ops;
>  static struct regulator_ops mc13783_fixed_regulator_ops;
> +static struct regulator_ops mc13783_gpo_regulator_ops;
>  
>  #define MC13783_DEFINE(prefix, _name, _reg, _vsel_reg, _voltages)	\
>  	[MC13783_ ## prefix ## _ ## _name] = {				\
> @@ -201,7 +207,7 @@ static struct regulator_ops mc13783_fixed_regulator_ops;
>  	[MC13783_ ## prefix ## _ ## _name] = {				\
>  		.desc = {						\
>  			.name = #prefix "_" #_name,			\
> -			.ops = &mc13783_regulator_ops,			\
> +			.ops = &mc13783_gpo_regulator_ops,		\
>  			.type = REGULATOR_VOLTAGE,			\
>  			.id = MC13783_ ## prefix ## _ ## _name,		\
>  			.owner = THIS_MODULE,				\
> @@ -253,10 +259,13 @@ static struct mc13783_regulator mc13783_regulators[] = {
>  	MC13783_GPO_DEFINE(REGU, GPO2, POWERMISC),
>  	MC13783_GPO_DEFINE(REGU, GPO3, POWERMISC),
>  	MC13783_GPO_DEFINE(REGU, GPO4, POWERMISC),
> +	MC13783_GPO_DEFINE(REGU, PWGT1SPI, POWERMISC),
> +	MC13783_GPO_DEFINE(REGU, PWGT2SPI, POWERMISC),
>  };
>  
>  struct mc13783_regulator_priv {
>  	struct mc13783 *mc13783;
> +	u32 powermisc_pwgt_state;
>  	struct regulator_dev *regulators[];
>  };
>  
> @@ -445,6 +454,104 @@ static struct regulator_ops mc13783_fixed_regulator_ops = {
>  	.get_voltage = mc13783_fixed_regulator_get_voltage,
>  };
>  
> +int mc13783_powermisc_rmw(struct mc13783_regulator_priv *priv, u32 mask,
> +									u32 val)
> +{
> +	struct mc13783 *mc13783 = priv->mc13783;
> +	int ret;
> +	u32 valread;
> +
> +	BUG_ON(val & ~mask);
> +
> +	ret = mc13783_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
> +	if (ret)
> +		return ret;
> +
> +	/* Update the stored state for Power Gates. */
> +	priv->powermisc_pwgt_state =
> +				(priv->powermisc_pwgt_state & ~mask) | val;
> +	priv->powermisc_pwgt_state &= MC13783_REG_POWERMISC_PWGTSPI_M;
> +
> +	/* Construct the new register value */
> +	valread = (valread & ~mask) | val;
> +	/* Overwrite the PWGTxEN with the stored version */
> +	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
> +						priv->powermisc_pwgt_state;
> +
> +	return mc13783_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
> +}
> +
> +static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
> +{
> +	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +	int ret;
> +	u32 en_val = mc13783_regulators[id].enable_bit;
> +
> +	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
> +
> +	/* Power Gate enable value is 0 */
> +	if (id == MC13783_REGU_PWGT1SPI ||
> +	    id == MC13783_REGU_PWGT2SPI)
> +		en_val = 0;
> +
> +	mc13783_lock(priv->mc13783);
> +	ret = mc13783_powermisc_rmw(priv, mc13783_regulators[id].enable_bit,
> +					en_val);
> +	mc13783_unlock(priv->mc13783);
> +
> +	return ret;
> +}
> +
> +static int mc13783_gpo_regulator_disable(struct regulator_dev *rdev)
> +{
> +	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
> +	int ret;
> +	u32 dis_val = 0;
> +
> +	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
> +
> +	/* Power Gate disable value is 1 */
> +	if (id == MC13783_REGU_PWGT1SPI ||
> +	    id == MC13783_REGU_PWGT2SPI)
> +		dis_val = mc13783_regulators[id].enable_bit;
> +
> +	mc13783_lock(priv->mc13783);
> +	ret = mc13783_powermisc_rmw(priv, mc13783_regulators[id].enable_bit,
> +					dis_val);
> +	mc13783_unlock(priv->mc13783);
> +
> +	return ret;
> +}
> +
> +static int mc13783_gpo_regulator_is_enabled(struct regulator_dev *rdev)
> +{
> +	struct mc13783_regulator_priv *priv = rdev_get_drvdata(rdev);
> +	int ret, id = rdev_get_id(rdev);
> +	unsigned int val;
> +
> +	mc13783_lock(priv->mc13783);
> +	ret = mc13783_reg_read(priv->mc13783, mc13783_regulators[id].reg, &val);
> +	mc13783_unlock(priv->mc13783);
> +
> +	if (ret)
> +		return ret;
> +
> +	/* Power Gates state is stored in powermisc_pwgt_state
> +	 * where the meaning of bits is negated */
> +	val = (val & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
> +	      (priv->powermisc_pwgt_state ^ MC13783_REG_POWERMISC_PWGTSPI_M);
> +
> +	return (val & mc13783_regulators[id].enable_bit) != 0;
> +}
> +
> +static struct regulator_ops mc13783_gpo_regulator_ops = {
> +	.enable = mc13783_gpo_regulator_enable,
> +	.disable = mc13783_gpo_regulator_disable,
> +	.is_enabled = mc13783_gpo_regulator_is_enabled,

How is the voltage output on the GPO regulator governed. Is it
controlled by a parent regulator or fixed ?

We probably want a way to query the voltage here or specify the parent
relationship. 


> +};
> +
>  static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
>  {
>  	struct mc13783_regulator_priv *priv;
> diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
> index 3568040..94cb51a 100644
> --- a/include/linux/mfd/mc13783.h
> +++ b/include/linux/mfd/mc13783.h
> @@ -108,6 +108,8 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
>  #define	MC13783_REGU_V2		28
>  #define	MC13783_REGU_V3		29
>  #define	MC13783_REGU_V4		30
> +#define	MC13783_REGU_PWGT1SPI	31
> +#define	MC13783_REGU_PWGT2SPI	32
>  
>  #define MC13783_IRQ_ADCDONE	0
>  #define MC13783_IRQ_ADCBISDONE	1


