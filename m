Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZESQYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZESQYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZESQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:23:53 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:64113 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbZESQXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U0/UWCG4J2yX8JL1McUiKFPO+7EamHp13cDQhceqkOhKXAVZO9CmiUynzdko3IbiNF
         Hun3UOixWUHBFMwb8ND96vWOY6xY5q3TcuLSwrn8lhH835AB1mhwGUfwZxEL4nfyLBCq
         02yrZ+qG3iYu4PzEnJXOEIVaPHGNIyxQputg8=
MIME-Version: 1.0
In-Reply-To: <4A12C3B5.2050100@compulab.co.il>
References: <63386a3d0905181340y42ad1868k6b2978e586abc18d@mail.gmail.com>
	 <4A12C3B5.2050100@compulab.co.il>
Date: Tue, 19 May 2009 18:23:49 +0200
Message-ID: <63386a3d0905190923t36d301c5hf245c06db00b6127@mail.gmail.com>
Subject: Re: [PATCH 1/1] MFD: Add U300 AB3100 core support v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
       linux-i2c@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm I shouldn't been so trigger-happy as to send v3 out so soon... :-/

Thanks for you quick review Mike!

2009/5/19 Mike Rapoport <mike@compulab.co.il>:

>> +     /* Set a pointer back to the container in device data */
>> +     for (i = 0; i < ARRAY_SIZE(ab3100_platform_devs); i++)
>> +             platform_set_drvdata(ab3100_platform_devs[i], ab3100_local);
>> +
>> +     /* Register the platform devices */
>> +     platform_add_devices(ab3100_platform_devs,
>> +                          ARRAY_SIZE(ab3100_platform_devs));
>
> If you register sub-devices this way, they won't appear as ab3100 children.

I'll set the parent in the first loop then (will test that this works) because I
really like that device table. (Similar to how the board setup does things.)

> Besides, setting the sub-devices drvdata to point to the master device makes it
> impossible for sub-device drivers to use this field for their needs.

Not really... It's just a pointer back to the AB3100 parent that can
be discarded
after copying it to a local driver struct. So the driver can actually:

foo_probe(platform_device *pdev) {
  foo = kmalloc(...);
  foo->ab_pointer = platform_get_drvdata(pdev);
  ...
  platform_set_drvdata(pdev, foo);
}

I could use platform_device_add_data() instead but that will start
kmalloc():ing and such...

>> +/*
>> + * This struct is PRIVATE and devices using it should NOT
>> + * access ANY fields. It is used as a token for calling the
>> + * AB3100 functions.
>> + */
>
> If the struct is private, probably it should be placed rather in the ".c" file?

>From one point of view, yes, but from another point of view it feels bad to
pass around a (void *) as token for ab3100 operations. This is loosely
modeled on how wm8350 does it, so shouldn't be too controversial I think.

Yours,
Linus Walleij
