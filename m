Return-Path: <linux-kernel-owner+w=401wt.eu-S1751169AbZG3Nja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbZG3Nja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZG3Nj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:39:29 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:44743 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZG3Nj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AlP+8JCek8Z3qzMB4HCdyeJfLsKuD2WgSeYAYUYzFtZnAOMkRMHobX3ovTpDIVp8hG
         n1N159AJR0hxVKaT1mI3Z3UP6yUAPX7NrpEbHdym4otZBgubuA7tGdn7uXHRCTnSxNdV
         uqRSI5USk75kGNiFjlQDc1HfzkwftoFTGRtBA=
MIME-Version: 1.0
In-Reply-To: <4A719A27.8050509@linutronix.de>
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu> 
	<4A719A27.8050509@linutronix.de>
From: vimal singh <vimal.newwork@gmail.com>
Date: Thu, 30 Jul 2009 19:09:09 +0530
Message-ID: <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com>
Subject: Re: [PATCH] [mtd] fixed faulty check
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stoyan Gaydarov <sgayda2@uiuc.edu>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, sr@denx.de, kay.sievers@vrfy.org,
       gregkh@suse.de, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 6:33 PM, Sebastian Andrzej
Siewior<bigeasy@linutronix.de> wrote:
> Stoyan Gaydarov wrote:
>>
>> Resubmit of a patch with some additions, see
>> http://lkml.org/lkml/2009/7/30/97
>>
> Please add a description of the path here. That's the place where people
> are looking for them. The link might be a an additional reference.
>
>> Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
>> ---
>>  drivers/mtd/maps/physmap_of.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
>> index 39d357b..e7ab5f0 100644
>> --- a/drivers/mtd/maps/physmap_of.c
>> +++ b/drivers/mtd/maps/physmap_of.c
>> @@ -215,7 +215,8 @@ static int __devinit of_flash_probe(struct of_device
>> *dev,
>>                goto err_out;
>>          mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
>> -       if (!info)
>> +       if (!mtd_list)
>> +               kfree(info);
>>                goto err_out;

What if you go to 'err_out' due to some other error?? Do not you need
to free 'info'?
So, better free it in at the label.

Currently label is like below, which is again incorrect.
-----code snippet (line 339)-----
err_out:
        kfree(mtd_list);
        of_flash_remove(dev);
-------------------------------------------
Think about when you get jump to this label even before 'mtd_list' is
allocated. This is the scenario of null pointer dereferencing.

So, this requires two separate labels:
-one label for errors which occur before 'mtd_list' memory allocation
-and, another for then onward errors

something like below:

err_out2:
        kfree(info);
        kfree(mtd_list);
err_out1:
        of_flash_remove(dev);

-vimal

>
> This is not python, you have to be explicit about braces. Now your code
> looks like this:
>
>        mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
>        if (!mtd_list)
>                kfree(info);
>        goto err_out;
>>
>>          dev_set_drvdata(&dev->dev, info);
>
>
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
---
Regards,
\/ | |\/| /-\ |_

____      __o
------   -\<,
-----  ( )/ ( )
