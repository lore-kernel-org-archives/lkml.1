Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbZHaWCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbZHaWCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 18:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZHaWCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 18:02:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40137 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZHaWCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 18:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MGOj2y77LevTRTu3TkEzdaY53m/LKAcU6C35er1QRYOoauvfGFefSZ87v9He8k7DHP
         SJKINWvFFlS2ud2NEGxw5W3wfDo1/jpfjHthhQe+Rz4sRYsRrheSZD0e/xe/XWWOshOh
         AhdluJBjDPaAcBHHdyMVCtfbs1r4uSFoS7zcw=
MIME-Version: 1.0
In-Reply-To: <1251724267.4254.73.camel@finisterre.sirena.org.uk>
References: <1251667855-31806-1-git-send-email-linus.walleij@stericsson.com>
	 <1251724267.4254.73.camel@finisterre.sirena.org.uk>
Date: Tue, 1 Sep 2009 00:02:11 +0200
Message-ID: <63386a3d0908311502v386339d2oc13b5fd880444b18@mail.gmail.com>
Subject: Re: [PATCH 2/2] U300 AB3100 boardinfo
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       linux-arm-kernel@lists.infradead.org,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/31 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> On Sun, 2009-08-30 at 23:30 +0200, Linus Walleij wrote:
>
>>  arch/arm/mach-u300/Makefile    |    1 +
>>  arch/arm/mach-u300/i2c.c       |  304 ++++++++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-u300/regulator.c |  150 ++++++++++++++++++++
>
> Is mach-u300 for all machines with a given processor or is it for a
> specific system?

It is a series of systems (U330, U365, U335) but they all feature the same
connections and rails to the AB3100 circuit so regulator-wise they are
identical.

>> +static struct regulator_consumer_supply supply_ldo_c[] = {
>> +     {
>> +             .dev_name = "ab3100-codec",
>> +             .supply = "vaudio", /* Powers the codec */
>> +     },
>> +};
>
> Does the CODEC really take a single supply called vaudio or are there
> several inputs to the CODEC?

It's only one actually.

>> +             /* Buck converter in sleep mode routing and constraints */
>> +             {
>> +                     .constraints = {
>> +                             .min_uV = 0,
>> +                             .max_uV = 1800000,
>> +                             .valid_modes_mask = REGULATOR_MODE_NORMAL,
>> +                             .valid_ops_mask =
>> +                             REGULATOR_CHANGE_VOLTAGE |
>> +                             REGULATOR_CHANGE_STATUS,
>> +                     },
>> +                     .num_consumer_supplies = ARRAY_SIZE(supply_buck_sleep),
>> +                     .consumer_supplies = supply_buck_sleep,
>> +             },
>
> Hrm, I didn't pick this up when reading the regulator driver but does
> this mean that you're registering two different regulators for the same
> buck convertor?

Yeah I did. So I removed the sleep mode "regulators" and added
the set_suspend_voltage() hook instead. Works like a charm.

>> +/*
>> + * Hog the regulators needed to power up the board.
>> + */
>> +static int __init u300_init_boardpower(void)
>> +{
>> +     int err;
>> +     u32 val;
>> +
>> +     pr_info("U300: setting up board power\n");
>> +     radio_power = regulator_get(NULL, "vrad");
>> +     if (IS_ERR(radio_power)) {
>> +             pr_err("could not get vrad\n");
>> +             return PTR_ERR(radio_power);
>> +     }
>> +     err = regulator_enable(radio_power);
>> +     if (err) {
>> +             pr_err("could not enable vrad\n");
>> +             return err;
>> +     }
>
> This all looks like it can be supported with the existing constraints
> code; look at boot_on and always_on. Normally the only thing that should
> need deviceless supplies like you have here is cpufreq (due to the fact
> that there's no struct device available for cpufreq to use).

I switched to using always_on and boot_on and it's just as good.
Though I kept one of them: vana15, because disabling that
regulator is what I use for shutdown hook for the system.

Thanks for all the great comments Mark, v3 is due in a minute.

Yours,
Linus Walleij
