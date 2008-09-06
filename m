Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYIFWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYIFWU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYIFWUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 18:20:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:12656 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYIFWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A8XDrulXxnNXbPl2hY25MRMabyfVRcWvd1YC93kaexrMCqkuuOVl3mrYra3rRLRTyP
         k2qN78mQrHcR+rNE4jU19/QLdxLJaWW4ByShonrdjkYvFLe31WA+KX1030xPvM1oYeUe
         at357Lt5pODABstLth331c/5EiqzEddu/0Kro=
Message-ID: <ef1cd66f0809061520scafdeb0w957322029273f7ee@mail.gmail.com>
Date: Sat, 6 Sep 2008 18:20:12 -0400
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [GIT pull] timer fixes for 2.6.27
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Venkatesch Pallipadi" <venkatesh.pallipadi@intel.com>
In-Reply-To: <alpine.LFD.1.10.0809061708240.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0809061708240.3243@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/9/6 Thomas Gleixner <tglx@linutronix.de>:
> Dominik Brodowski (2):
>      [...]
>      clocksource, acpi_pm.c: check for monotonicity
I made some comments about this patch which were never answered:

    http://lkml.org/lkml/2008/8/23/28

Not sure whether this was because they were irrelevant or overlooked.
Just to make sure, I replicate them below:

> diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
> index 5ca1d80..4eee533 100644
> --- a/drivers/clocksource/acpi_pm.c
> +++ b/drivers/clocksource/acpi_pm.c
> @@ -21,6 +21,7 @@
>  #include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/pci.h>
> +#include <linux/delay.h>
>  #include <asm/io.h>
>
>  /*
> @@ -151,13 +152,13 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
>  */
>  static int verify_pmtmr_rate(void)
>  {
> -       u32 value1, value2;
> +       cycle_t value1, value2;
>        unsigned long count, delta;
>
>        mach_prepare_counter();
> -       value1 = read_pmtmr();
> +       value1 = clocksource_acpi_pm.read();
>        mach_countup(&count);
> -       value2 = read_pmtmr();
> +       value2 = clocksource_acpi_pm.read();
>        delta = (value2 - value1) & ACPI_PM_MASK;
>
>        /* Check that the PMTMR delta is within 5% of what we expect */
> @@ -175,10 +176,13 @@ static int verify_pmtmr_rate(void)
>  #define verify_pmtmr_rate() (0)
>  #endif
>
> +/* Number of monotonicity checks to perform during initialization */
> +#define ACPI_PM_MONOTONICITY_CHECKS 10
> +
>  static int __init init_acpi_pm_clocksource(void)
>  {
> -       u32 value1, value2;
> -       unsigned int i;
> +       cycle_t value1, value2;
> +       unsigned int i, j, good = 0;
>
>        if (!pmtmr_ioport)
>                return -ENODEV;
> @@ -187,24 +191,32 @@ static int __init init_acpi_pm_clocksource(void)
>                                                clocksource_acpi_pm.shift);
>
>        /* "verify" this timing source: */
> -       value1 = read_pmtmr();
> -       for (i = 0; i < 10000; i++) {
> -               value2 = read_pmtmr();
> -               if (value2 == value1)
> -                       continue;
> -               if (value2 > value1)
> -                       goto pm_good;
> -               if ((value2 < value1) && ((value2) < 0xFFF))
> -                       goto pm_good;
> -               printk(KERN_INFO "PM-Timer had inconsistent results:"
> -                       " 0x%#x, 0x%#x - aborting.\n", value1, value2);
> -               return -EINVAL;
> +       for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
> +               value1 = clocksource_acpi_pm.read();
> +               for (i = 0; i < 10000; i++) {
> +                       value2 = clocksource_acpi_pm.read();
> +                       if (value2 == value1)
> +                               continue;
> +                       if (value2 > value1)
> +                               good++;
> +                               break;
> +                       if ((value2 < value1) && ((value2) < 0xFFF))
The brackets arout value2 are not needed and look strange.

> +                               good++;
> +                               break;
> +                       printk(KERN_INFO "PM-Timer had inconsistent results:"
> +                              " 0x%#llx, 0x%#llx - aborting.\n",
> +                              value1, value2);
> +                       return -EINVAL;
> +               }
> +               udelay(300 * i);
300*10000 microseconds seems like a long time to me.  Is this the
intended maximal delay?

> +       }
> +
> +       if (good != ACPI_PM_MONOTONICITY_CHECKS) {
> +               printk(KERN_INFO "PM-Timer failed consistency check "
> +                      " (0x%#llx) - aborting.\n", value1);
> +               return -ENODEV;
If the inner loop runs out once, you alreay know that you will later
abort here.  Maybe move the check directly after the inner loop to
avoid the additional delay (10*10000*300 microseconds = 30 seconds) in
case of failure?

>        }
> -       printk(KERN_INFO "PM-Timer had no reasonable result:"
> -                       " 0x%#x - aborting.\n", value1);
> -       return -ENODEV;
>
> -pm_good:
>        if (verify_pmtmr_rate() != 0)
>                return -ENODEV;

I hope this helps,
Jochen
-- 
http://seehuhn.de/
