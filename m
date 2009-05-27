Return-Path: <linux-kernel-owner+w=401wt.eu-S1764453AbZE0PNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764453AbZE0PNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbZE0PNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:13:11 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:50809 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZE0PNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:13:10 -0400
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator/max1586: support increased V3 voltage range
References: <1243366748-8428-1-git-send-email-philipp.zabel@gmail.com>
	<87zlczblfx.fsf@free.fr>
	<74d0deb30905261640s44271836oe695b38fe280a8c5@mail.gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 27 May 2009 17:12:58 +0200
Message-ID: <878wkibmv9.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pHilipp Zabel <philipp.zabel@gmail.com> writes:

>>> -#define MAX1586_V3_MIN_UV   700000
>>> -#define MAX1586_V3_MAX_UV  1475000
>>> -#define MAX1586_V3_STEP_UV   25000
>> These 3 should be kept I think, see below.
>
> The nice thing about the switch statement below was that I just had to
> take the nominal values from the datasheet and not think about the
> actual mechanism at all.
I know. But board with funky resistor values can come (or worst, a voltage
regulator providing reference voltage to pin FB3 : watch the "chicken and egg"
problem comming :))

>>>  /*
>>>   * V3 voltage
>>>   * On I2C bus, sending a "x" byte to the max1586 means :
>>> - *   set V3 to 0.700V + (x & 0x1f) * 0.025V
>>> + *   set V3 to 0.700V + (x & 0x1f) * 0.025V,
>>> + *   set V3 to 0.730V + (x & 0x1f) * 0.026V,
>>> + *   set V3 to 0.750V + (x & 0x1f) * 0.027V or
>>> + *   set V3 to 0.780V + (x & 0x1f) * 0.028V
>>> + * depending on the external resistance R24.
>> That's not really the full truth.
>
> Hm, right. My MAX1586A/MAX1586B/MAX1587A data sheet only has  this
> information in (Figure 9. Adding R24 and R25 to Increase Core Voltage
> Programming Range):
>
> R24 = 3.32kOhm, V3: 0.73V TO 1.55V, 26mV/STEP
> R24 = 5.11kOhm, V3: 0.75V TO 1.60V, 27mV/STEP
> R24 = 7.5kkOhm, V3: 0.78V TO 1.65V, 28mV/STEP
>
> With R25 = 100kOhm. There's no mention of 185.5(kOhm?) anywhere.
That's an internal resistor of the MAX158x, connected from FB3 pin to ground.

>> The real V3 is (0.700V + (x & 0x1f) * 0.025V) * gain, where :
>>  - if R24 is not connected, gain = 1
>>  - if R24 and R25 are connected, gain = 1 + R24/R25 + R24/185.5
>
> Ok, so for example:
> R24 = 3.32kOhm --> gain = 1.051098 --> 735768uV ... 1550369uV
> But the nominal values from the datasheet for this R24 resistor are
> 730mV and 1550mV. Should we trust this calculation over the nominal
> values?
I'd rather trust the calculation, as it seems related to the electronics. From
what I see, R24 forms a voltage divisor with the resultant resistor formed by
R25 and 185.5 kOhms in parallel formation.

>
>>   Here, it should be assumed that R25 >> 10k.ohm, which means that R24/R25
>>   becomes meaningless compared to R24/185.5.
>>   Therefore, the formula becomes:
>>     gain = 1 + R24/185.5
>
> That is not true. For this formula to make sense, 185.5 has to be
> given in kΩ, so R24/R25 is actually the bigger contribution.
Ah, specification british touch. The formula was written with R24/185,500, and I
took the comma for ... the decimal separator, while it was 185.5 k.ohms as you
say. You're right.

And so, the formula has to take into accound R25 as well, and become :
  gain = 1 + R24/185500 + R24/R25

>> For reference, R24 and R25 are described in Max1586 datasheet, in figure7
>> (extending the maximum core voltage range).
>>
>> I'd like that put in the comment please.
>
> Yes, it would be better to document this.

>>>
>>>  static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
>>>  {
>>> -     struct i2c_client *client = rdev_get_drvdata(rdev);
>>> +     struct max1586_data *max1586 = rdev_get_drvdata(rdev);
>>> +     struct i2c_client *client = max1586->client;
>>> +     unsigned range_uV = max1586->max_uV - max1586->min_uV;
>>>       unsigned selector;
>>>       u8 v3_prog;
>>>
>>> -     if (min_uV < MAX1586_V3_MIN_UV || min_uV > MAX1586_V3_MAX_UV)
>>> -             return -EINVAL;
>>> -     if (max_uV < MAX1586_V3_MIN_UV || max_uV > MAX1586_V3_MAX_UV)
>>> +     if (min_uV > max1586->max_uV || max_uV < max1586->min_uV)
>>>               return -EINVAL;
>>> +     if (min_uV < max1586->min_uV)
>>> +             min_uV = max1586->min_uV;
>>>
>>> -     selector = (min_uV - MAX1586_V3_MIN_UV) / MAX1586_V3_STEP_UV;
>>> -     if (max1586_v3_calc_voltage(selector) > max_uV)
>>> +     selector = (min_uV - max1586->min_uV) * 31 / range_uV;
>>                                                \-> ???
>> Why 31 ? Could I have a define here, and probably that define would be a value
>> of 32 (as there are 32 different steps, not 31).
>
> We have 32 steps, 0 to 31. The difference between the smallest and
> largest value is still 31. I should have used MAX1586_V3_MAX_VSEL here
> to avoid confusion.
OK, that's right.

>>> @@ -71,9 +84,11 @@ static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
>>>
>>>  static int max1586_v3_list(struct regulator_dev *rdev, unsigned selector)
>>>  {
>>> +     struct max1586_data *max1586 = rdev_get_drvdata(rdev);
>>> +
>>>       if (selector > MAX1586_V3_MAX_VSEL)
>>>               return -EINVAL;
>>> -     return max1586_v3_calc_voltage(selector);
>>> +     return max1586_v3_calc_voltage(max1586, selector);
>>>  }
>>>
>>>  /*
>>> @@ -164,12 +179,33 @@ static int max1586_pmic_probe(struct i2c_client *client,
>>>  {
>>>       struct regulator_dev **rdev;
>>>       struct max1586_platform_data *pdata = client->dev.platform_data;
>>> -     int i, id, ret = 0;
>>> +     struct max1586_data *max1586;
>>> +     int i, id, ret = -ENOMEM;
>>>
>>>       rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
>>>                      GFP_KERNEL);
>>>       if (!rdev)
>>> -             return -ENOMEM;
>>> +             goto out;
>>> +
>>> +     max1586 = kzalloc(sizeof(struct max1586_data *), GFP_KERNEL);
>>> +     if (!max1586)
>>> +             goto out_unmap;
>>> +
>>> +     max1586->client = client;
>>
>>> +     switch (pdata->r24) {
>>> +     case MAX1586_R24_3k32:
>>> +             max1586->min_uV = 730000;
>>> +             max1586->max_uV = 1550000;
>>> +             break;
>>> +     case MAX1586_R24_5k11:
>>> +             max1586->min_uV = 750000;
>>> +             max1586->max_uV = 1600000;
>>> +             break;
>>> +     case MAX1586_R24_7k5:
>>> +             max1586->min_uV = 780000;
>>> +             max1586->max_uV = 1650000;
>>> +             break;
>>> +     }

>> I would like that changed to something more or less like :
>> if (pdata->r24 == 0)
>>        gain = 1;
>> else
>>        gain = 1 + R24/185.5;
What do you think of putting directly the gain in the pdata structure ?
Something like pdata->gain_e6, which is equal to :
  1000000 * (1 + R24/185000 + R24/R25).

That way, whatever the electronics do (say someone crazy puts a voltage
regulator providing voltage reference for FB3 pin), the system still works.

>
> No floating point in the kernel, so let's say I do some ugly rounding:
>
>         e6 = 1000000;
>         gain = e6 + e6*r24/100000 + e6*r24/185500;
>         min_uV = ((MAX1586_V3_MIN_UV/1000 * gain) / e6) / 10 * 10000;
>         max_uV = ((MAX1586_V3_MAX_UV/1000 * gain) / e6 + 9) / 10 * 10000;
>
> Then I get all the (nominal) values for R24 = 3220, 5110, 7500.
> But of course not for values inbetween, which kind of defeats the
> purpose of calculating it in the first place...
OK. Maybe would be easier if gain was in pdata ?

> If I don't round up the max values, I get something like 1.548V
> instead of the nominal 1.55V for max, so requests to set the voltage
> to 1.55V will fail even though it's in the 1.5% tolerance.


>>> diff --git a/include/linux/regulator/max1586.h b/include/linux/regulator/max1586.h
>>> index 2056973..cdf2010 100644
>>> --- a/include/linux/regulator/max1586.h
>>> +++ b/include/linux/regulator/max1586.h
>>> @@ -26,6 +26,10 @@
>>>  #define MAX1586_V3 0
>>>  #define MAX1586_V6 1
>>>
>>> +#define MAX1586_R24_3k32 3320
>>> +#define MAX1586_R24_5k11 5110
>>> +#define MAX1586_R24_7k5  7500
>> This could be gone, as R24 will define the exact value of R24 in ohms.
>
> I thought it would be good to have the values given in the datasheet
> as a reference somewhere.
True. What would you think of defining something like :
#define MAX1586_GAIN_R24_3k32 <your_computed_value>
and so on ?

>>>  /**
>>>   * max1586_subdev_data - regulator data
>>>   * @id: regulator Id (either MAX1586_V3 or MAX1586_V6)
>>> @@ -43,10 +47,13 @@ struct max1586_subdev_data {
>>>   * @num_subdevs: number of regultors used (may be 1 or 2)
>>>   * @subdevs: regulator used
>>>   *           At most, there will be a regulator for V3 and one for V6 voltages.
>>> + * @r24: external regulator to increase V3 range
>> Rather :
>> + * @r24: external resistor value to increase V3 range (in ohms), or 0 if none
>
> As Mark noted, it is probably a good idea not to allow a value of 0 here.
And replacing with a gain ?

Cheers.

--
Robert
