Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbZJIQNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbZJIQNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbZJIQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:13:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:63985 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933772AbZJIQNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:13:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,533,1249282800"; 
   d="scan'208";a="558074540"
Date: Fri, 9 Oct 2009 18:14:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: tony@atomide.com, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       felipe.balbi@nokia.com
Subject: Re: [PATCH v2] twl4030: Fix boot with twl4030 usb transceiver
 enabled
Message-ID: <20091009161408.GC7523@sortiz.org>
References: <1254385536-26912-1-git-send-email-ext-roger.quadros@nokia.com>
 <b90c0690910090532y60cced09j2c805a5a04dbcbb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b90c0690910090532y60cced09j2c805a5a04dbcbb7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Fri, Oct 09, 2009 at 03:32:12PM +0300, Roger Quadros wrote:
> Hi Samuel,
> 
> What is the status of this patch?
> Without this patch we are unable to boot on systems using musb usb controller.
I'm applying that patch to my for-next branch. And I will also try to have
Linus pulling it too, as it seems to prevent your machines from booting.

Cheers,
Samuel.


> cheers,
> -roger.
> 
> On Thu, Oct 1, 2009 at 11:25 AM, Roger Quadros
> <ext-roger.quadros@nokia.com> wrote:
> > The usb regulator supplies (usb1v5, usb1v8 & usb3v1) must be available
> > before adding the twl4030_usb child, else twl4030_usb_ldo_init() will
> > always fail thus causing boot lock-up.
> >
> > This patch fixes boot on OMAP systems using the twl4030 usb transceiver.
> > CONFIG_TWL4030_USB=y
> >
> > Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> > ---
> >  drivers/mfd/twl4030-core.c |   89 ++++++++++++++++++++++---------------------
> >  1 files changed, 46 insertions(+), 43 deletions(-)
> >
> > diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> > index e424cf6..e832e97 100644
> > --- a/drivers/mfd/twl4030-core.c
> > +++ b/drivers/mfd/twl4030-core.c
> > @@ -480,7 +480,6 @@ static int
> >  add_children(struct twl4030_platform_data *pdata, unsigned long features)
> >  {
> >        struct device   *child;
> > -       struct device   *usb_transceiver = NULL;
> >
> >        if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
> >                child = add_child(3, "twl4030_bci",
> > @@ -532,16 +531,61 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
> >        }
> >
> >        if (twl_has_usb() && pdata->usb) {
> > +
> > +               static struct regulator_consumer_supply usb1v5 = {
> > +                       .supply =       "usb1v5",
> > +               };
> > +               static struct regulator_consumer_supply usb1v8 = {
> > +                       .supply =       "usb1v8",
> > +               };
> > +               static struct regulator_consumer_supply usb3v1 = {
> > +                       .supply =       "usb3v1",
> > +               };
> > +
> > +       /* First add the regulators so that they can be used by transceiver */
> > +               if (twl_has_regulator()) {
> > +                       /* this is a template that gets copied */
> > +                       struct regulator_init_data usb_fixed = {
> > +                               .constraints.valid_modes_mask =
> > +                                       REGULATOR_MODE_NORMAL
> > +                                       | REGULATOR_MODE_STANDBY,
> > +                               .constraints.valid_ops_mask =
> > +                                       REGULATOR_CHANGE_MODE
> > +                                       | REGULATOR_CHANGE_STATUS,
> > +                       };
> > +
> > +                       child = add_regulator_linked(TWL4030_REG_VUSB1V5,
> > +                                                     &usb_fixed, &usb1v5, 1);
> > +                       if (IS_ERR(child))
> > +                               return PTR_ERR(child);
> > +
> > +                       child = add_regulator_linked(TWL4030_REG_VUSB1V8,
> > +                                                     &usb_fixed, &usb1v8, 1);
> > +                       if (IS_ERR(child))
> > +                               return PTR_ERR(child);
> > +
> > +                       child = add_regulator_linked(TWL4030_REG_VUSB3V1,
> > +                                                     &usb_fixed, &usb3v1, 1);
> > +                       if (IS_ERR(child))
> > +                               return PTR_ERR(child);
> > +
> > +               }
> > +
> >                child = add_child(0, "twl4030_usb",
> >                                pdata->usb, sizeof(*pdata->usb),
> >                                true,
> >                                /* irq0 = USB_PRES, irq1 = USB */
> >                                pdata->irq_base + 8 + 2, pdata->irq_base + 4);
> > +
> >                if (IS_ERR(child))
> >                        return PTR_ERR(child);
> >
> >                /* we need to connect regulators to this transceiver */
> > -               usb_transceiver = child;
> > +               if (twl_has_regulator() && child) {
> > +                       usb1v5.dev = child;
> > +                       usb1v8.dev = child;
> > +                       usb3v1.dev = child;
> > +               }
> >        }
> >
> >        if (twl_has_watchdog()) {
> > @@ -580,47 +624,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
> >                        return PTR_ERR(child);
> >        }
> >
> > -       if (twl_has_regulator() && usb_transceiver) {
> > -               static struct regulator_consumer_supply usb1v5 = {
> > -                       .supply =       "usb1v5",
> > -               };
> > -               static struct regulator_consumer_supply usb1v8 = {
> > -                       .supply =       "usb1v8",
> > -               };
> > -               static struct regulator_consumer_supply usb3v1 = {
> > -                       .supply =       "usb3v1",
> > -               };
> > -
> > -               /* this is a template that gets copied */
> > -               struct regulator_init_data usb_fixed = {
> > -                       .constraints.valid_modes_mask =
> > -                                 REGULATOR_MODE_NORMAL
> > -                               | REGULATOR_MODE_STANDBY,
> > -                       .constraints.valid_ops_mask =
> > -                                 REGULATOR_CHANGE_MODE
> > -                               | REGULATOR_CHANGE_STATUS,
> > -               };
> > -
> > -               usb1v5.dev = usb_transceiver;
> > -               usb1v8.dev = usb_transceiver;
> > -               usb3v1.dev = usb_transceiver;
> > -
> > -               child = add_regulator_linked(TWL4030_REG_VUSB1V5, &usb_fixed,
> > -                               &usb1v5, 1);
> > -               if (IS_ERR(child))
> > -                       return PTR_ERR(child);
> > -
> > -               child = add_regulator_linked(TWL4030_REG_VUSB1V8, &usb_fixed,
> > -                               &usb1v8, 1);
> > -               if (IS_ERR(child))
> > -                       return PTR_ERR(child);
> > -
> > -               child = add_regulator_linked(TWL4030_REG_VUSB3V1, &usb_fixed,
> > -                               &usb3v1, 1);
> > -               if (IS_ERR(child))
> > -                       return PTR_ERR(child);
> > -       }
> > -
> >        /* maybe add LDOs that are omitted on cost-reduced parts */
> >        if (twl_has_regulator() && !(features & TPS_SUBSET)) {
> >                child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2);
> > --
> > 1.6.0.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
