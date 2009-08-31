Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZHaOQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZHaOQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZHaOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:16:15 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39440 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZHaOQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sef6WUvZq1DWbaCbybqLLw1WSprtoivSVZmXyCep+jOirhjHebdnGsEWaRuOxGG8RV
         3mDe3LEL4daVoZKH2VlRgz/e1OB5vDC+l53SM6OEm79aGP4H0f4sQvC5I4bsJGFDoNsn
         r8FXfiCH+qMPQq9eDwL7hmjHDTIm0c2qsa+Lg=
MIME-Version: 1.0
In-Reply-To: <1251722641.4254.46.camel@finisterre.sirena.org.uk>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
	 <1251722641.4254.46.camel@finisterre.sirena.org.uk>
Date: Mon, 31 Aug 2009 16:16:15 +0200
Message-ID: <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com>
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/31 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> On Sun, 2009-08-30 at 23:29 +0200, Linus Walleij wrote:
>
>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> It's probably better to only use this if someone's reviewed the driver
> and said it's OK.

Yeah OK sorry man, I wouldn't ever try to merge it until you say it's OK though.

> Overall this looks pretty good, it's addressed almost all of the issues
> I had last time. There's a few sticky bits below, though.
>
>> +     err = ab3100_get_register_interruptible(abreg->ab3100, abreg->regreg,
>> +                                             &regval);
>> +     if (err) {
>> +             if (err != -ERESTARTSYS)
>> +                     dev_err(&reg->dev, "unable to get register 0x%x\n",
>> +                             abreg->regreg);
>> +             else
>> +                     dev_info(&reg->dev,
>> +                              "interrupted while getting register 0x%x\n",
>> +                              abreg->regreg);
>> +             return err;
>> +     }
>
> I did query last time if having these operations be interruptible is a
> good idea - I can't see it helping robustness, it's not something that
> other drivers are doing and it'd complicate things for all API users to
> add handling for the error. I don't recall any discussion of the
> thinking here?

OK sorry for missing this, I was planning to follow up on the previous
mail but forgot.

I recently renamed all the ab3100 accessor functions to *_interruptible
to reflect the fact that the accessor mutex on ab3100 uses
mutex_lock_interruptible() so this suffix should propagate so it is
clear that stuff like -ERESTARTSYS can be returned.
So the above errorcheck is probably bogus.

That said, I think the regulator paths are entirely in-kernel and
under such circumstances that signals from userspace are blocked
anyway. The problem is that the ab3100 is accessed by complex
userspace programs and I2C is sometimes slow so there is a need
for being able to interrupt it, but I *could* go in and use an
uniterruptable mutex if you prefer that, I'll ask around here if
we should do this. Can the function name stand as it is for the time being?

>> +     bestmatch = INT_MAX;
>> +     bestindex = -1;
>> +     for (i = 0; i < abreg->voltages_len; i++) {
>> +             if (abreg->typ_voltages[i] <= max_uV &&
>> +                 abreg->typ_voltages[i] >= min_uV &&
>> +                 abreg->typ_voltages[i] < bestmatch) {
>> +                     bestmatch = abreg->typ_voltages[i];
>> +                     bestindex = i;
>> +             }
>> +     }
>> +
>> +     if (i < 0) {
>> +             dev_warn(&reg->dev, "requested %d<=x<=%d uV, out of range!\n",
>> +                      min_uV, max_uV);
>
> That should be a check for bestindex, not i - i will always be
> abreg->voltages_len.

How embarrassing. Will fix in v3. Thanks Mark.

>> +/*
>> + * The external regulator just calls back into the platform
>> + * board setup to get/set the regulator.
>> + */
>> +static int ab3100_get_voltage_regulator_external(struct regulator_dev *reg)
>> +{
>> +     struct ab3100_regulator *abreg = reg->reg_data;
>> +
>> +     if (abreg->plfdata->get_ext_voltage)
>> +             return abreg->plfdata->get_ext_voltage();
>> +     return -ENXIO;
>> +}
>
> Hrm.  I suspect that you either want to add some platform data to
> specify the voltage as a plain number or just have boards use the
> regulator supply mechanism with a fixed voltage regulator supplied by
> this one if they need to specify the voltage of the supply.

I was designing for it to be controllable but not controllable by the
AB3100 driver, perhaps it is a regulator somewhere else here,
defined in the board data. But I went for a fixed int member
voltage setting for the time being, we can discuss that stuff later
when I have some practical use for it.

>> +     /* Set up regulators */
>> +     for (i = 0; i < ARRAY_SIZE(ab3100_regulators); i++) {
>> +             /* This regulator is special and has to be set last */
>> +             if (ab3100_regulators[i].regreg == AB3100_LDO_D) {
>> +                     ldo_d_val = plfdata->reg_initvals[i];
>> +                     continue;
>> +             }
>> +
>> +             err = ab3100_set_register_interruptible(ab3100,
>> +                                     ab3100_regulators[i].regreg,
>> +                                     plfdata->reg_initvals[i]);
>> +             if (err) {
>> +                     dev_err(&pdev->dev, "regulator initialization failed with error %d\n",
>> +                             err);
>> +                     return err;
>> +             }
>> +     }
>
> It is a big improvement to have the configuration be specified as
> platform data but I'm still a bit concerned about the idea of providing
> this power sequencing as a driver-local feature.
>
> The regulator API already has mechanisms for setting the default state
> for regulators and the general problem of sequencing the initial setup
> isn't specific to this chip. There's currently no sequencing support in
> the API, largely because most systems have some explicit power
> sequencing in the hardware and a specific way of signalling the PMIC to
> kick off the powerdown or suspend sequences so it's not a big deal. I
> suspect that with the implementation you've got here you might run into
> trouble with systems which need some sequencing beyond just ordering
> everything else with respect to LDO D, which I suspect is more likely to
> occur if you need this level of soft implementation. I'd also be worried
> that any core sequencing that is introduced (I expect we will need it at
> some point - possibly soon, Mike Rappaport has some issues that look
> like they might need to be fixed sequencing support) might break your
> systems, though I think that may just be an excess of caution.
>
> I've been having a bit of a think about the best way to handle this;
> it'd mean that we'd need to have some way for a machine driver to
> provide sequences for the power on and off transitions that we might
> need to do. Working out how to actually run the sequences would be
> slightly tricky - we could wait for all the mentioned regulators to be
> registered but that'd create issues if some of the later regulators in
> the sequence depend on the earlier parts of the sequence for
> registration.
>
> Have you looked at the possibility of integrating this into the core?

I wish I could... I'm a bit newcomer on the regulator API, I'm learning
as we speak.

I can promise to go in and use such a framework once it's available.

If this sequence is a dependency graph of regulators that need to
have deps in all strange directions you get a directed graph
http://en.wikipedia.org/wiki/Directed_graph
Or you could limit yourself to a directed acyclic graph
http://en.wikipedia.org/wiki/Directed_acyclic_graph
in either case it's rather a delicate computational problem
but I guess you're after a simple linear sequence here, like
switch on A, B, C, D ... N in a special order?

In my case it's actually not the switching-on or of that is
the problem, it's more of putting some magic numbers
into some registers in a special order (well, any order
actually except for one register that is special).

I'll see if I can think of something more elegant to
make this more appealing, like tagging each default
register value with a sequence number or so.

Yours,
Linus Walleij
