Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbXKBBsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbXKBBsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbXKBBsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:48:39 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:5121 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXKBBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s5124U2H1UjdDkWFaE0yXAg1rglBE8z8tU0QT8QemGc1ZYh9hy1fAGG43BXeKE4sqL+U/gAey4K0gZw04o84PrGXZ4OdZ3JVNwhqXARW2mRpr02cGkBuBjPoHw6svSEBVmM54kaSdPIWK/8tfWoxBSnBjBy6CvwmRjZkePT5Wgs=
Message-ID: <386072610711011848x578dd4d8r6b530e5dfc33f4a8@mail.gmail.com>
Date: Fri, 2 Nov 2007 09:48:37 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/2] Blackfin I2C/TWI driver: add missing pin mux operation
Cc: "Bryan Wu" <bryan.wu@analog.com>, khali@linux-fr.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0711011051o6d52f635i76c3a63b478ac817@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193736797-9005-1-git-send-email-bryan.wu@analog.com>
	 <1193736797-9005-3-git-send-email-bryan.wu@analog.com>
	 <8bd0f97a0711011051o6d52f635i76c3a63b478ac817@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On 10/30/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > --- a/drivers/i2c/busses/i2c-bfin-twi.c
> > +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> > +static int setup_pin_mux(int action, struct bfin_twi_iface *iface)
> > +{
> > +
> > +       u16 pin_req[2][3] = {
> > +               {P_TWI0_SCL, P_TWI0_SDA, 0},
> > +               {P_TWI1_SCL, P_TWI1_SDA, 0},
> > +       };
>
> might be better to have this in the boards file ... consider the
> scenario on the BF54x where the user wants to use I2C0 and not I2C1 or
> vice versa so that they can use the set of pins for something else ...
> this would prevent such a setup
>

Yes, I plan to use new style I2C driver interface as Jean suggested before.
The whole hard coded pin_req list can be passed to the i2c-bfin-twi.c
dynamically.

> > +       if (action) {
> > +               if (peripheral_request_list(pin_req[iface->bus_num], DRV_NAME))
> > +                       return -EFAULT;
> > +       } else {
> > +               peripheral_free_list(pin_req[iface->bus_num]);
> > +       }
> > +
> > +       return 0;
> > +}
>
> EFAULT is incorrect i think ... want to pass back the actual value
> from peripheral_request_list()
>
It will be removed in the new style interface.

> > --- a/drivers/i2c/busses/i2c-bfin-twi.c
> > +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> > +static int setup_pin_mux(int action, struct bfin_twi_iface *iface)
> > +{
> > +
> > +       u16 pin_req[2][3] = {
> > +               {P_TWI0_SCL, P_TWI0_SDA, 0},
> > +               {P_TWI1_SCL, P_TWI1_SDA, 0},
> > +       };
>
> might be better to have this in the boards file ... consider the
> scenario on the BF54x where the user wants to use I2C0 and not I2C1 or
> vice versa so that they can use the set of pins for something else ...
> this would prevent such a setup
>
>        if (action)
>                return peripheral_request_list(pin_req[iface->bus_num],
> DRV_NAME);
>        else
>                peripheral_free_list(pin_req[iface->bus_num]);
>
>        return 0;
> -mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
