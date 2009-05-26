Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbZEZV0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbZEZV0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZEZV0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:26:33 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56031 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZEZV0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AQnGrVNV1oUmlI7ZMp8AolPK+VseK6y36tNJh3dM5kVVspcZPHo8lVyNplTyo9ASQX
         ud0L17vg7ECH8WlFLyPw7b+/K3xObXjMfSMs7WmWK2HHiV15Tw0fD+gdDlyMa7ZfxSZn
         V5wSOWcJCeohZQ4N2j/wDhu9Zy1NwShAttOoo=
MIME-Version: 1.0
In-Reply-To: <20090526204302.GB4951@sirena.org.uk>
References: <1243366748-8428-1-git-send-email-philipp.zabel@gmail.com>
	 <20090526204302.GB4951@sirena.org.uk>
Date: Tue, 26 May 2009 23:26:32 +0200
Message-ID: <74d0deb30905261426w7739c394ge3246c80890f1de6@mail.gmail.com>
Subject: Re: [PATCH] regulator/max1586: support increased V3 voltage range
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

thanks for the review.

On Tue, May 26, 2009 at 10:43 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, May 26, 2009 at 09:39:08PM +0200, Philipp Zabel wrote:
>
> Please don't use my @wolfsonmicro.com address for anything kernel
> related - use @opensource.wolfsonmicro.com or @sirena.org.uk.

Copy&paste error, won't happen again.

>> -#define MAX1586_V3_MIN_UV   700000
>> -#define MAX1586_V3_MAX_UV  1475000
>> -#define MAX1586_V3_STEP_UV   25000
>
> I don't see these values being re-added elsewhere in the code?

Ouh, strange thinko. For some reason I left them out of the switch
statement because they felt like default values. And why wouldn't the
structure be initialised with default values, right? Will add them
there.

>> +     selector = (min_uV - max1586->min_uV) * 31 / range_uV;
>> +     if (max1586_v3_calc_voltage(max1586, selector) > max_uV)
>>               return -EINVAL;
>
> Might be nice to have a #define for the 31 but then it's the only
> reference to it.

There is a "#define MAX1586_V3_MAX_VSEL 31" already, I'll use that.
(And there's a second reference in _calc_voltage)

>>       rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
>>                      GFP_KERNEL);
>>       if (!rdev)
>> -             return -ENOMEM;
>> +             goto out;
>> +
>> +     max1586 = kzalloc(sizeof(struct max1586_data *), GFP_KERNEL);
>> +     if (!max1586)
>> +             goto out_unmap;
>
> Could perhaps make these one struct?  But either way is fine.

Yes, I could put the struct regulator_dev[] at the end of max1586_data.

>> +       switch (pdata->r24) {
>> +       case MAX1586_R24_3k32:
>
> This switch statement doesn't reject invalid values which I'd expect it
> to and...
>
>> + * @r24: external regulator to increase V3 range
>> + *       (0, MAX1586_R24_3k32, MAX1586_R24_5k11 or MAX1586_R24_7k5)
>
> ...I think I'd be more comfortable if an explicit configuration were
> required for the no feedback case since otherwise the driver will
> happily start up and begin producing the wrong output voltages by
> default on platforms which have this feedback resistor fitted.  This
> could make the system non-obviously unstable and in the worst case
> possibly lead to long term hardware damage if something is consistently
> driven over voltage.

Ok. I'll add something like "#define MAX1586_NO_R24 -1" and reject
everything else with -EINVAL.

regards
Philipp
