Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbZE1TBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbZE1TBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZE1TBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:01:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61275 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZE1TBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lNV8tgEhnBt+WTYWdh795abk6UvMAkKdxhaQsGN2ohUsR82GhaQ7xk3CULSU3aP6ib
         kCOGn7On5IyoVVVvOa2Farc8agtlbv+c4uXJmHlOXFW124iazsfL3ViEZ95yMHYfUD4P
         Q4X7sdR4iltilNY7UC0C3DeMAzq8JP5YEdGn4=
MIME-Version: 1.0
In-Reply-To: <87skip2gxu.fsf@free.fr>
References: <878wkibmv9.fsf@free.fr>
	 <1243487718-5423-2-git-send-email-philipp.zabel@gmail.com>
	 <87skip2gxu.fsf@free.fr>
Date: Thu, 28 May 2009 21:01:26 +0200
Message-ID: <74d0deb30905281201k1eda2bcg39d2c1989533cbc8@mail.gmail.com>
Subject: Re: [PATCH 1/3] regulator/max1586: support increased V3 voltage range
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Eric Miao <eric.miao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 8:58 PM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Philipp Zabel <philipp.zabel@gmail.com> writes:
>
> <snip>
>> @@ -164,14 +184,25 @@ static int max1586_pmic_probe(struct i2c_client *client,
>>  {
>>       struct regulator_dev **rdev;
>>       struct max1586_platform_data *pdata = client->dev.platform_data;
>> -     int i, id, ret = 0;
>> +     struct max1586_data *max1586;
>> +     int i, id, ret = -ENOMEM;
>> +
>> +     max1586 = kzalloc(sizeof(struct max1586_data) +
>> +                     sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
>> +                     GFP_KERNEL);
>> +     if (!max1586)
>> +             goto out;
>>
>> -     rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
>> -                    GFP_KERNEL);
>> -     if (!rdev)
>> -             return -ENOMEM;
>> +     max1586->client = client;
>>
>> -     ret = -EINVAL;
>> +     if (!pdata->v3_gain) {
>> +             ret = -EINVAL;
>> +             goto out_unmap;
>> +     }
>
>> +     max1586->min_uV = MAX1586_V3_MIN_UV * pdata->v3_gain / 1000000;
>> +     max1586->max_uV = MAX1586_V3_MAX_UV * pdata->v3_gain / 1000000;
> My last comment : you'll overflow an integer capacity here, and will get
> min_uV=max_uV=0.
>
> Please replace by :
>       max1586->min_uV = MAX1586_V3_MIN_UV / 1000 * (pdata->v3_gain / 1000);
>       max1586->max_uV = MAX1586_V3_MAX_UV / 1000 * (pdata->v3_gain / 1000);
>
> And then add my :
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Wow, thanks. I literally sent a patch to that effect a few seconds
ago. Would you be ok with that one, too? I'd like not to lose too much
resolution in the v3_gain parameter.

regards
Philipp
