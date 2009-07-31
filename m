Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZGaNZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZGaNZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZGaNZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:25:37 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41715 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZGaNZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bl/8e/L9nu5HSomQXk/kU/f0/qDHWtrnR4el9N1MNb6mNsRIrc56bIg09NP7xEZNrc
         asLoPt6KRkvcvhR6q1g65slZs0A2M0IaDvzHz3XfG15UCJ0hWHMhSe07/99QXF7sQaTd
         F/YQnBZB48FAsakXuad653N2/MYXEmZw0pdis=
MIME-Version: 1.0
In-Reply-To: <20090731131005.GE17091@sirena.org.uk>
References: <1249044918-695-1-git-send-email-quadros.roger@gmail.com>
	 <20090731131005.GE17091@sirena.org.uk>
Date: Fri, 31 Jul 2009 15:25:36 +0200
Message-ID: <74d0deb30907310625u128ea22cu6fecca53c4a23d40@mail.gmail.com>
Subject: Re: [PATCH] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Roger Quadros <quadros.roger@gmail.com>, lrg@slimlogic.co.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 3:10 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jul 31, 2009 at 03:55:18PM +0300, Roger Quadros wrote:
>
> Looks good, some relatively nitpicky issues:
>
>> +     int use_gpio_control;
>
> This isn't needed, just use an invalid GPIO value (zero or less).

Negative only, actually. Zero itself is a valid GPIO number (which is
a bit unfortunate because if you forget to initialize .gpio, it will
default to GPIO #0).

If you drop .use_gpio_control, use gpio_is_valid(data->gpio) for this check:

>> +       if (data->use_gpio_control) {
>> +               gpio_set_value(data->gpio,
>> +                               data->enable_high ? 1 : 0);
>
> Nicer to use the _cansleep() variants in case the GPIO is one on an
> I2C/SPI device of some kind.  The regulator API doesn't mind if drivers
> sleep so long as they don't do so excessively and it's not normally
> sufficiently performance critical to make the inlining worth it.
>
>> +             if (ret) {
>> +                     dev_err(&pdev->dev, "Could not obtain regulator " \
>> +                                     "enable GPIO %d\n", config->gpio);
>
> Please do something like:
>
>        dev_err(&pdev->dev,
>                "Could not obtain enable GPIO %d: %d\n",
>                config->gpio, ret);
>
> so that the error message is all in one in the source (so it's easier to
> find when grepping the kernel log.  You also don't need the \.
>
>> +                     goto err_name;
>> +             } else {
>
> No need for the else clause; you've got the goto above.
>
>> +                     ret = gpio_direction_output(config->gpio,
>> +                             config->enable_high ? 0 : 1);
>> +                     if (ret) {
>> +                             dev_err(&pdev->dev, "Could not configure " \
>> +                                     "enable GPIO %d direction\n",
>> +                                     config->gpio);
>> +                             gpio_free(config->gpio);
>> +                             goto err_name;
>> +                     }
>
> Same comment as above with regard to the error message.  It would be
> nice to have the default state passed in as platform data if you can't
> read it back to help avoid bouncing supplies at startup.  IIRC
> gpio_get_value() will generally take a good stab at giving the current
> state no matter if the GPIO is input our output but I'd need to check.

I think this is not clearly defined in the GPIO API document, so it
could be architecture dependent.

>> +       int use_gpio_control;   /* Use GPIO enable control */
>> +       int gpio;               /* GPIO to use for enable control */
>> +
>> +       int enable_high;        /* Polarity of enable GPIO
>> +                                * 1 = Active High, 0 = Active Low
>
> If you mark the comments with /** they'll get picked up by kerneldoc.

Maybe following the style in Documentation/kernel-doc-nano-HOWTO.txt
would be worthwhile, then.

regards
Philipp
