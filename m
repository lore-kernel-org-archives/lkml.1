Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZLBQ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZLBQ7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZLBQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:59:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43772 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZLBQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:59:45 -0500
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Grazvydas Ignotas'" <notasas@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
       "'Anton Vorontsov'" <avorontsov@ru.mvista.com>,
       <linux-omap@vger.kernel.org>
References: <1259333060-24277-1-git-send-email-notasas@gmail.com> <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com> <6ed0b2680911301333p19b14d5dxac81f976d0c35c61@mail.gmail.com>
Subject: RE: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI charger
Date: Wed, 2 Dec 2009 10:59:35 -0600
Message-ID: <004201ca7370$d3c9ce70$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <6ed0b2680911301333p19b14d5dxac81f976d0c35c61@mail.gmail.com>
Thread-Index: AcpyBLN5GZorGEIcSv67v9WnElV4rQBalbAg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Grazvydas Ignotas [mailto:notasas@gmail.com]
> Sent: Monday, November 30, 2009 3:33 PM
> To: Madhusudhan
> Cc: linux-kernel@vger.kernel.org; Anton Vorontsov; linux-
> omap@vger.kernel.org
> Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
> charger
> 
> On Mon, Nov 30, 2009 at 8:45 PM, Madhusudhan <madhu.cr@ti.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: Grazvydas Ignotas [mailto:notasas@gmail.com]
> >> Sent: Friday, November 27, 2009 8:44 AM
> >> To: linux-kernel@vger.kernel.org
> >> Cc: Anton Vorontsov; Madhusudhan Chikkature; linux-
> omap@vger.kernel.org;
> >> Grazvydas Ignotas
> >> Subject: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
> charger
> >>
> >> TWL4030/TPS65950 is a multi-function device with integrated charger,
> >> which allows charging from AC or USB. This driver enables the
> >> charger and provides several monitoring functions.
> >>
> >> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> >> ---
> >> For this driver to work, TWL4030-core needs to be patched to use
> >> correct macros so that it registers twl4030_bci platform_device.
> >> I'll send patches for this later.
> >>
> >>  drivers/power/Kconfig           |    7 +
> >>  drivers/power/Makefile          |    1 +
> >>  drivers/power/twl4030_charger.c |  499
> >
> > Is the file name changed from twl4030_bci_battery.c to twl4030_charger.c
> because it mainly supports voltage monitoring only while charging? If yes,
> potentially we can add support for monitoring also in discharge state. Do
> we intend to change the file name then?
> 
> Does the hardware support any monitoring in discharge state? I'm
> unable to get any readings, only frozen values (that never update)
> from what it had when it was charging. Here is TI confirmation that at
> least temperature monitoring won't work while discharging:
> http://e2e.ti.com/forums/p/8202/31818.aspx#31818
> 
> For this reason I consider BCI a charger.
> 
In the discharge path BCI might not update the registers. It is worth
experiment to try and use MADC conversion to get the values. A driver for
madc is being currently discussed. See the patch:

http://patchwork.kernel.org/patch/62746/

We can try this once the madc driver is accepted in mainline and submit an
update patch to the BCI driver. As a first step I agree that the current BCI
patch should go upstream.

Reviewed-by: Madhusudhan Chikkature <madhu.cr@ti.com>

Thanks,
Madhu

> > Also adding the tested-on info could be helpful here.
> 
> ok
> 
> <snip>
> 
> >> +     case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> >> +             /* charging must be active for meaningful result */
> >> +             if (!is_charging) {
> >
> > How about putting a kern_info here?
> 
> That would potentially flood dmesg, will just return -EINVAL like
> Anton suggests.
> 
> >> +                     val->intval = 0;
> >> +                     break;
> >> +             }
> >> +             ret = twl4030_get_voltage(voltage_reg);
> >> +             if (ret < 0)
> >> +                     return ret;
> >> +             val->intval = ret;
> >> +             break;
> >> +     case POWER_SUPPLY_PROP_CURRENT_NOW:
> >> +             if (!is_charging) {
> >> +                     val->intval = 0;
> > Ditto
> >> +                     break;
> >> +             }
> >> +             /* current measurement is shared between AC and USB */
> >> +             ret = twl4030_charger_get_current();
> >> +             if (ret < 0)
> >> +                     return ret;
> >> +             val->intval = ret;
> >> +             break;
> >> +     case POWER_SUPPLY_PROP_ONLINE:
> > Does this indicate the source of charging like USB or AC??
> 
> There are 2 charging devices registered now, AC and USB, each returns
> it's state. This is what most other drivers do.
> 
> I'll send v2 later, it will also have more accurate voltage formulas I
> got from TI.

