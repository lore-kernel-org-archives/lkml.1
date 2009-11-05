Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbZKEJIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbZKEJIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 04:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZKEJIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 04:08:30 -0500
Received: from smtp.nokia.com ([192.100.105.134]:44477 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZKEJI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 04:08:27 -0500
Subject: Re: [PATCH v2] TWL4030: Initial support for TWL5031
From: "Kauppi Ari (EXT-Ixonos/Oulu)" <ext-ari.kauppi@nokia.com>
To: "Koskinen Ilkka (Nokia-D/Tampere)" <ilkka.koskinen@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       ext Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20091104160832.GD3607@sortiz.org>
References: <1255702360-2143-1-git-send-email-ilkka.koskinen@nokia.com>
	 <20091104160832.GD3607@sortiz.org>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 11:08:01 +0200
Message-Id: <1257412081.25273.23.camel@kauppi-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2009 09:08:03.0726 (UTC) FILETIME=[7B1CA2E0:01CA5DF7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 17:08 +0100, ext Samuel Ortiz wrote:
> Hi Ilkka,
> 
> Some comments below:

One additional comment. Sorry for replying to Samuel's email, I don't
have the original one.

> On Fri, Oct 16, 2009 at 05:12:40PM +0300, Ilkka Koskinen wrote:
> > TWL5031 introduces two new interrupts in PIH. Moreover, BCI
> > has changed remarkably and, thus, it's disabled when TWL5031
> > is in use.
> >
> > Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> > ---
> >  drivers/mfd/twl4030-core.c  |   12 ++++-
> >  drivers/mfd/twl4030-irq.c   |  127 +++++++++++++++++++++++++++++++++++++++++--
> >  include/linux/i2c/twl4030.h |   47 ++++++++++++++--
> >  3 files changed, 173 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> > index 5596bb4..5dc5062 100644
> > --- a/drivers/mfd/twl4030-core.c
> > +++ b/drivers/mfd/twl4030-core.c
> > @@ -152,6 +152,9 @@
> >  #define TWL4030_BASEADD_PWMB         0x00F1
> >  #define TWL4030_BASEADD_KEYPAD               0x00D2
> >
> > +#define TWL5031_BASEADD_ACCESSORY    0x0074 /* Replaces Main Charge */
> > +#define TWL5031_BASEADD_INTERRUPTS   0x00B9 /* Different to TWL4030's one */
> Should be "Different than..."
> 
> 
> > +
> >  /* subchip/slave 3 - POWER ID */
> >  #define TWL4030_BASEADD_BACKUP               0x0014
> >  #define TWL4030_BASEADD_INT          0x002E
> > @@ -183,6 +186,7 @@
> >  /* chip-specific feature flags, for i2c_device_id.driver_data */
> >  #define TWL4030_VAUX2                BIT(0)  /* pre-5030 voltage ranges */
> >  #define TPS_SUBSET           BIT(1)  /* tps659[23]0 have fewer LDOs */
> > +#define TWL5031                      BIT(2)  /* twl5031 has different registers */
> >
> >  /*----------------------------------------------------------------------*/
> >
> > @@ -235,6 +239,8 @@ static struct twl4030mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
> >       { 2, TWL4030_BASEADD_PWM1 },
> >       { 2, TWL4030_BASEADD_PWMA },
> >       { 2, TWL4030_BASEADD_PWMB },
> > +     { 2, TWL5031_BASEADD_ACCESSORY },
> > +     { 2, TWL5031_BASEADD_INTERRUPTS },
> >
> >       { 3, TWL4030_BASEADD_BACKUP },
> >       { 3, TWL4030_BASEADD_INT },
> > @@ -483,7 +489,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
> >       struct device   *child;
> >       struct device   *usb_transceiver = NULL;
> >
> > -     if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
> > +     if (twl_has_bci() && pdata->bci &&
> > +         !((features & TPS_SUBSET) || (features & TWL5031))) {
> could be simpler: !((features & (TPS_SUBSET | TWL5031))
> 
> 
> >               child = add_child(3, "twl4030_bci",
> >                               pdata->bci, sizeof(*pdata->bci),
> >                               false,
> > @@ -743,6 +750,7 @@ static void clocks_init(struct device *dev,
> >
> >  int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end);
> >  int twl_exit_irq(void);
> > +int twl_init_chip_irq(const char *chip);
> >
> >  static int twl4030_remove(struct i2c_client *client)
> >  {
> > @@ -820,6 +828,7 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >       if (client->irq
> >                       && pdata->irq_base
> >                       && pdata->irq_end > pdata->irq_base) {
> > +             twl_init_chip_irq(id->name);
> >               status = twl_init_irq(client->irq, pdata->irq_base, pdata->irq_end);
> >               if (status < 0)
> >                       goto fail;
> > @@ -835,6 +844,7 @@ fail:
> >  static const struct i2c_device_id twl4030_ids[] = {
> >       { "twl4030", TWL4030_VAUX2 },   /* "Triton 2" */
> >       { "twl5030", 0 },               /* T2 updated */
> > +     { "twl5031", TWL5031 },         /* TWL5030 updated */
> >       { "tps65950", 0 },              /* catalog version of twl5030 */
> >       { "tps65930", TPS_SUBSET },     /* fewer LDOs and DACs; no charger */
> >       { "tps65920", TPS_SUBSET },     /* fewer LDOs; no codec or charger */
> > diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> > index fb194fe..a64994e 100644
> > --- a/drivers/mfd/twl4030-irq.c
> > +++ b/drivers/mfd/twl4030-irq.c
> > @@ -61,6 +61,7 @@
> >
> >  /* Linux could (eventually) use either IRQ line */
> >  static int irq_line;
> > +static int chip_is_twl5031;
> >
> >  struct sih {
> >       char    name[8];
> > @@ -82,6 +83,9 @@ struct sih {
> >       /* + 2 bytes padding */
> >  };
> >
> > +static const struct sih *sih_modules;
> > +static int nr_sih_modules;
> > +
> >  #define SIH_INITIALIZER(modname, nbits) \
> >       .module         = TWL4030_MODULE_ ## modname, \
> >       .control_offset = TWL4030_ ## modname ## _SIH_CTRL, \
> > @@ -107,7 +111,8 @@ struct sih {
> >  /* Order in this table matches order in PIH_ISR.  That is,
> >   * BIT(n) in PIH_ISR is sih_modules[n].
> >   */
> > -static const struct sih sih_modules[6] = {
> > +/* sih_modules_twl4030 is used for twl4030 and twl5030 */
> > +static const struct sih sih_modules_twl4030[6] = {
> >       [0] = {
> >               .name           = "gpio",
> >               .module         = TWL4030_MODULE_GPIO,
> > @@ -164,6 +169,84 @@ static const struct sih sih_modules[6] = {
> >               /* there are no SIH modules #6 or #7 ... */
> >  };
> >
> > +static const struct sih sih_modules_twl5031[8] = {
> > +     [0] = {
> > +             .name           = "gpio",
> > +             .module         = TWL4030_MODULE_GPIO,
> > +             .control_offset = REG_GPIO_SIH_CTRL,
> > +             .set_cor        = true,
> > +             .bits           = TWL4030_GPIO_MAX,
> > +             .bytes_ixr      = 3,
> > +             /* Note: *all* of these IRQs default to no-trigger */
> > +             .edr_offset     = REG_GPIO_EDR1,
> > +             .bytes_edr      = 5,
> > +             .mask = { {
> > +                     .isr_offset     = REG_GPIO_ISR1A,
> > +                     .imr_offset     = REG_GPIO_IMR1A,
> > +             }, {
> > +                     .isr_offset     = REG_GPIO_ISR1B,
> > +                     .imr_offset     = REG_GPIO_IMR1B,
> > +             }, },
> > +     },
> > +     [1] = {
> > +             .name           = "keypad",
> > +             .set_cor        = true,
> > +             SIH_INITIALIZER(KEYPAD_KEYP, 4)
> > +     },
> > +     [2] = {
> > +             .name           = "bci",
> > +             .module         = TWL5031_MODULE_INTERRUPTS,
> > +             .control_offset = TWL5031_INTERRUPTS_BCISIHCTRL,
> > +             .bits           = 7,
> > +             .bytes_ixr      = 1,
> > +             .edr_offset     = TWL5031_INTERRUPTS_BCIEDR1,
> > +             /* Note: most of these IRQs default to no-trigger */
> > +             .bytes_edr      = 2,
> > +             .mask = { {
> > +                     .isr_offset     = TWL5031_INTERRUPTS_BCIISR1,
> > +                     .imr_offset     = TWL5031_INTERRUPTS_BCIIMR1,
> > +             }, {
> > +                     .isr_offset     = TWL5031_INTERRUPTS_BCIISR2,
> > +                     .imr_offset     = TWL5031_INTERRUPTS_BCIIMR2,
> > +             }, },
> > +     },
> > +     [3] = {
> > +             .name           = "madc",
> > +             SIH_INITIALIZER(MADC, 4)
> > +     },
> > +     [4] = {
> > +             /* USB doesn't use the same SIH organization */
> > +             .name           = "usb",
> > +     },
> > +     [5] = {
> > +             .name           = "power",
> > +             .set_cor        = true,
> > +             SIH_INITIALIZER(INT_PWR, 8)
> > +     },
> > +     [6] = {
> > +             /* ACI doesn't use the same SIH organization */
> > +             .name           = "aci",
> > +     },
> > +     [7] = {
> > +             /* Accessory */
> > +             .name           = "acc",
> > +             .module         = TWL5031_MODULE_ACCESSORY,
> > +             .control_offset = TWL5031_ACCSIHCTRL,
> > +             .bits           = 2,
> > +             .bytes_ixr      = 1,
> > +             .edr_offset     = TWL5031_ACCEDR1,
> > +             /* Note: most of these IRQs default to no-trigger */
> > +             .bytes_edr      = 1,
> > +             .mask = { {
> > +                     .isr_offset     = TWL5031_ACCISR1,
> > +                     .imr_offset     = TWL5031_ACCIMR1,
> > +             }, {
> > +                     .isr_offset     = TWL5031_ACCISR2,
> > +                     .imr_offset     = TWL5031_ACCIMR2,
> > +             }, },
> > +     },
> > +};
> > +
> >  #undef TWL4030_MODULE_KEYPAD_KEYP
> >  #undef TWL4030_MODULE_INT_PWR
> >  #undef TWL4030_INT_PWR_EDR
> > @@ -284,11 +367,20 @@ static int twl4030_init_sih_modules(unsigned line)
> >       /* disable all interrupts on our line */
> >       memset(buf, 0xff, sizeof buf);
> >       sih = sih_modules;
> > -     for (i = 0; i < ARRAY_SIZE(sih_modules); i++, sih++) {
> > +     for (i = 0; i < nr_sih_modules; i++, sih++) {
> >
> >               /* skip USB -- it's funky */
> > -             if (!sih->bytes_ixr)
> > +             /* But don't skip TWL5031's ACI */
> > +             if (!sih->bytes_ixr) {
> > +                     if (chip_is_twl5031 && !strcmp(sih->name, "aci")) {
> > +                             twl4030_i2c_write(TWL5031_MODULE_ACCESSORY,
> > +                                               buf, TWL5031_ACIIMR_LSB, 1);
> > +                             twl4030_i2c_write(TWL5031_MODULE_ACCESSORY,
> > +                                               buf, TWL5031_ACIIMR_MSB, 1);
> > +                     }
> > +
> A few comments on this:
> - Why do we have to do that for the accessory ? Some comments would be
> appropriate.
> - You could use twl4030_i2c_write_u8(), couldnt you ?
> - I'd like it to be more generic: TWL5031_MODULE_ACCESSORY should be replaced
> by sih->module, and the TWL5031_ACII* register should be somehow integrated in
> the sih struct. The idea is to get rid of this chip_is_twl5031.
> >                       continue;
> > +             }
> >
> >               status = twl4030_i2c_write(sih->module, buf,
> >                               sih->mask[line].imr_offset, sih->bytes_ixr);
> > @@ -314,13 +406,22 @@ static int twl4030_init_sih_modules(unsigned line)
> >       }
> >
> >       sih = sih_modules;
> > -     for (i = 0; i < ARRAY_SIZE(sih_modules); i++, sih++) {
> > +     for (i = 0; i < nr_sih_modules; i++, sih++) {
> >               u8 rxbuf[4];
> >               int j;
> >
> >               /* skip USB */
> > -             if (!sih->bytes_ixr)
> > +             /* But don't skip TWL5031's ACI */
> > +             if (!sih->bytes_ixr) {
> > +                     if (chip_is_twl5031 && !strcmp(sih->name, "aci")) {
> > +                             twl4030_i2c_write(TWL5031_MODULE_ACCESSORY,
> > +                                               buf, TWL5031_ACIIDR_LSB, 1);
> > +                             twl4030_i2c_write(TWL5031_MODULE_ACCESSORY,
> > +                                               buf, TWL5031_ACIIDR_MSB, 1);
> > +                     }
> > +
> >                       continue;
> > +             }

I found out yesterday that with the above code the interrupts aren't
actually masked/cleared as expected, at least with some TWL5031
revisions. If 0xff is written to ACIIDR_MSB (as is done above) some
interrupts are still not masked/cleared properly and I'm seeing:

irq 374: nobody cared (try booting with the "irqpoll" option) 
[<8003144c>] (dump_stack+0x0/0x14) from [<80084b14>] (__report_bad_irq+0x38/0x90)
[<80084adc>] (__report_bad_irq+0x0/0x90) from [<80084cc0>] (note_interrupt+0x154/0x1c8) r5:00000000 r4:8038076c
[<80084b6c>] (note_interrupt+0x0/0x1c8) from [<801b0a8c>] (twl4030_irq_thread+0xdc/0x150)
[<801b09b0>] (twl4030_irq_thread+0x0/0x150) from [<8006d68c>] (kthread+0x54/0x80) r7:00000000 r6:00000000 r5:801b09b0 r4:00000007
[<8006d638>] (kthread+0x0/0x80) from [<8005a7d0>] (do_exit+0x0/0x778) r5:00000000 r4:00000000
handlers:
Disabling IRQ #374

Writing 0x01 (proper value according to TRM) to ACIIDR_MSB instead of
0xff seems to fix the issue. Writing 0xff or 0x01 to ACIIMR_MSB does not
seem to make any difference, though.

--
Ari


