Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbZENMif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbZENMif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZENMi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:38:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:43003 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZENMiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QMFWyoz1GrkMHJM1Ac45dVfBuHQE/4gX8Qtx43urNzURmWuUaYuQE8GoZtc58uZLNj
         cmWnKj3BuQpY2R1ysudqt+ierX1CMQGhxOlyqcHsQf1xv4kk4i2/1DspgsUeL3JGDoyA
         tSD2o+VcvpNmbVy8HVa82kxho0nQ0UzAbuZ3Q=
MIME-Version: 1.0
In-Reply-To: <a8e1da0905140504x1d1d99ebq911018d5aaa80a16@mail.gmail.com>
References: <a8e1da0905102316v1037c89cs48cb052924c250a9@mail.gmail.com>
	 <a8e1da0905140504x1d1d99ebq911018d5aaa80a16@mail.gmail.com>
Date: Thu, 14 May 2009 20:38:26 +0800
Message-ID: <d82e647a0905140538s63ae1b23g93bf3b473767e6d8@mail.gmail.com>
Subject: Re: [PATCH 1/3] kobject : kobject_set_name_vargs leak fix
From: Ming Lei <tom.leiming@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/14 Dave Young <hidave.darkstar@gmail.com>:
> On Mon, May 11, 2009 at 2:16 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> kobject_set_name_vargs will leak the old_name when return -ENOMEM,
>> move the kfree(old_name) before the return path.
>
> Hi, greg
>
> I rethought about this problem, does such issue exist really? I means
> that kobject->name != NULL scenario.
>
> there's following comments of this function:
>
>  * This sets the name of the kobject.  If you have already added the
>  * kobject to the system, you must call kobject_rename() in order to
>  * change the name of the kobject
>
> So what if something like :
>
> if (kobject->name) {
>  WARN(1, KERN_WARNING, "there's name for kobject already!");
>  return -EINVAL;
> }
>
> if (!fmt)
>  return 0;
>
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>> lib/kobject.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -uprN linux.old/lib/kobject.c linux.new/lib/kobject.c
>> --- linux.old/lib/kobject.c     2009-05-11 13:59:01.000000000 +0800
>> +++ linux.new/lib/kobject.c     2009-05-11 13:59:34.000000000 +0800
>> @@ -221,6 +221,7 @@ int kobject_set_name_vargs(struct kobjec
>>        if (kobj->name && !fmt)
>>                return 0;
>>
>> +       kfree(old_name);
>>        kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>>        if (!kobj->name)
>>                return -ENOMEM;

IMO, Greg means it is better that the fix should be :
        if (!kobj->name) {
                kobj->name = old_name;
                return -ENOMEM;
        }

Right?

>> @@ -229,7 +230,6 @@ int kobject_set_name_vargs(struct kobjec
>>        while ((s = strchr(kobj->name, '/')))
>>                s[0] = '!';
>>
>> -       kfree(old_name);
>>        return 0;
>>  }
>>
>
>
>
> --
> Regards
> dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Lei Ming
