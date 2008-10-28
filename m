Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbYJ1BDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbYJ1BDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYJ1BCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:02:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:15746 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYJ1BCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SnJ/r8g9iP4lieZtQD/U0C3Wk46DHZWhQ219IT1F6Qgcf/Kw2ZBfKR5R71O0EA/Q8z
         Jra4V1Bs+dKrgjI8lmQuip2j2m9OAwH7e/UqUyo3NTyM30s2NmhfNqhuOx2RXfXEXLzs
         G6QePnZRsuTfSqayp620bDaXz5X15aEGJzQNI=
Message-ID: <f17812d70810271802v75b08712l4ab243802f59ecce@mail.gmail.com>
Date: Tue, 28 Oct 2008 09:02:52 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Jonathan Cameron" <Jonathan.Cameron@gmail.com>
Subject: Re: [PATCH] da903x regulator bug fix
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       "Liam Girdwood" <lrg@kernel.org>
In-Reply-To: <f17812d70810271801t47830712h431df82baee11654@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4901EE0F.5000508@cam.ac.uk> <4905DE3D.1010101@gmail.com>
	 <f17812d70810271801t47830712h431df82baee11654@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend with corrected e-mail address of Liam)

I'd suggest making this a static inline function then,
e.g. to_da903x_dev(rdev), which will help both
readability and future modifications.

> On Mon, Oct 27, 2008 at 11:29 PM, Jonathan Cameron
> <Jonathan.Cameron@gmail.com> wrote:
>> Changes the device registration part of the probe function to supply the
>> regulator device rather than its parent (the mfd device) as this caused
>> problems when the regulator core attempted to find constraints associated
>> with the regulators.
>>
>> Signed-of-by: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> --
>> This is quickest and simplest way to fix this bug. There may be better
>> ways of doing it, but they all require considerably more substantial
>> changes to the driver.
>>
>> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
>> index 3688e33..f928aa1 100644
>> --- a/drivers/regulator/da903x.c
>> +++ b/drivers/regulator/da903x.c
>> @@ -93,7 +93,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev
>> *rdev,
>>                   int min_uV, int max_uV)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>     uint8_t val, mask;
>>
>>     if (check_range(info, min_uV, max_uV)) {
>> @@ -111,7 +111,7 @@ static int da903x_set_ldo_voltage(struct
>> regulator_dev *rdev,
>>  static int da903x_get_voltage(struct regulator_dev *rdev)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>     uint8_t val, mask;
>>     int ret;
>>
>> @@ -128,7 +128,7 @@ static int da903x_get_voltage(struct regulator_dev
>> *rdev)
>>  static int da903x_enable(struct regulator_dev *rdev)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>
>>     return da903x_set_bits(da9034_dev, info->enable_reg,
>>                     1 << info->enable_bit);
>> @@ -137,7 +137,7 @@ static int da903x_enable(struct regulator_dev *rdev)
>>  static int da903x_disable(struct regulator_dev *rdev)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>
>>     return da903x_clr_bits(da9034_dev, info->enable_reg,
>>                     1 << info->enable_bit);
>> @@ -146,7 +146,7 @@ static int da903x_disable(struct regulator_dev *rdev)
>>  static int da903x_is_enabled(struct regulator_dev *rdev)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>     uint8_t reg_val;
>>     int ret;
>>
>> @@ -238,7 +238,7 @@ static int da9034_set_dvc_voltage(struct
>> regulator_dev *rdev,
>>                   int min_uV, int max_uV)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>     uint8_t val, mask;
>>     int ret;
>>
>> @@ -264,7 +264,7 @@ static int da9034_set_ldo12_voltage(struct
>> regulator_dev *rdev,
>>                     int min_uV, int max_uV)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>     uint8_t val, mask;
>>
>>     if (check_range(info, min_uV, max_uV)) {
>> @@ -283,7 +283,7 @@ static int da9034_set_ldo12_voltage(struct
>> regulator_dev *rdev,
>>  static int da9034_get_ldo12_voltage(struct regulator_dev *rdev)
>>  {
>>     struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
>> -    struct device *da9034_dev = rdev_get_dev(rdev)->parent;
>> +    struct device *da9034_dev = rdev_get_dev(rdev)->parent->parent;
>>     uint8_t val, mask;
>>     int ret;
>>
>> @@ -466,7 +466,7 @@ static int __devinit da903x_regulator_probe(struct
>> platform_device *pdev)
>>     if (ri->desc.id == DA9030_ID_LDO1 || ri->desc.id == DA9030_ID_LDO15)
>>         ri->desc.ops = &da9030_regulator_ldo1_15_ops;
>>
>> -    rdev = regulator_register(&ri->desc, pdev->dev.parent, ri);
>> +    rdev = regulator_register(&ri->desc, &pdev->dev, ri);
>>     if (IS_ERR(rdev)) {
>>         dev_err(&pdev->dev, "failed to register regulator %s\n",
>>                 ri->desc.name);
>>
>>
>>
>>
>>
>
>
>
> --
> Cheers
> - eric
>



-- 
Cheers
- eric
