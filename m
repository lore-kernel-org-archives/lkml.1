Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZATIWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZATIWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZATIV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:21:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:32778 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZATIV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:21:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nf2K4SN+EBwQj9KozYOGJI8wD0lIrBOYakispdC7SCMtFsK4rPzAAmajPumSk1FwrW
         gpQWJWZw0dI08V22ZtSaUOgPECTcPe7m2ecIULuWG1ih3KHnoJtP6oZxaxQbg/QggtE4
         m2jQJUHe4GviAF/K7cjcjjsstsb6RIR+/T1ZM=
MIME-Version: 1.0
In-Reply-To: <20090119215427.7f23a76f.krzysztof.h1@wp.pl>
References: <1232363044-8878-1-git-send-email-righi.andrea@gmail.com>
	 <20090119215427.7f23a76f.krzysztof.h1@wp.pl>
Date: Tue, 20 Jan 2009 09:21:55 +0100
Message-ID: <a2776ec50901200021y7583fa40h71d2ea56c89c44a6@mail.gmail.com>
Subject: Re: [PATCH] fbmem: copy_from/to_user() with mutex held (v2)
From: Andrea Righi <righi.andrea@gmail.com>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Jones <davej@redhat.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 9:54 PM, Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
> On Mon, 19 Jan 2009 12:04:04 +0100
> Andrea Righi <righi.andrea@gmail.com> wrote:
>
>> Avoid to call copy_from/to_user() with fb_info->lock mutex held in fbmem
>> ioctl().
>>
>> fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
>> fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
>> copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
>> deadlock.
>>
>> NOTE: it doesn't push down the fb_info->lock in each own driver's
>> fb_ioctl(), so there're still potential deadlocks somewhere.
>>
>
>> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
>> index 756efeb..fe6033e 100644
>> --- a/drivers/video/fbmem.c
>> +++ b/drivers/video/fbmem.c
>> @@ -1013,25 +1013,26 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
> (...)
>>       case FBIOPUT_VSCREENINFO:
>> -             if (copy_from_user(&var, argp, sizeof(var))) {
>> -                     ret =  -EFAULT;
>> -                     break;
>> -             }
>> +             if (copy_from_user(&var, argp, sizeof(var)))
>> +                     return -EFAULT;
>> +             if (!lock_fb_info(info))
>> +                     return -ENODEV;
>>               acquire_console_sem();
>>               info->flags |= FBINFO_MISC_USEREVENT;
>>               ret = fb_set_var(info, &var);
>> @@ -1041,104 +1042,109 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>>                       ret = -EFAULT;
>>               break;
>
> I don't see a call to unlock_fb_info(info) in the case for FBIOPUT_VSCREENINFO.
> Is it intentional?

No, it's a bug :(. I'll post a new patch soon.

Thanks for reviewing!
-Andrea

>
> Kind regards,
> Krzysztof
