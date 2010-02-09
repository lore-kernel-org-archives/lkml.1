Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0BIF4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 00:56:38 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:55165 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0BIF4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 00:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hLkMA1OWNx09sTp/RlmkdT9lLNlOwh3uKAJRihoUNxPIbO4hjqrFdrpIdZv87pritu
         xRynDEACs8VgWagnKH8lCkilaH/nJTHX1mEEbTSVPD8+FGFuhibkDaxJLlwikx2JWHH+
         yz2E5z7QBvhYmlqAceXcldtlO3MaIXV1uPSu4=
MIME-Version: 1.0
In-Reply-To: <a8e1da1002081831j6fdea8a7v41cc07b635ab7dda@mail.gmail.com>
References: <20100206134056.GB2562@darkstar>
	 <20100208135654.04b79bbc.akpm@linux-foundation.org>
	 <a8e1da1002081831j6fdea8a7v41cc07b635ab7dda@mail.gmail.com>
Date: Tue, 9 Feb 2010 13:56:34 +0800
Message-ID: <a8e1da1002082156s3145a775o7424bc47ac503636@mail.gmail.com>
Subject: Re: [PATCH 2/2] allow printk delay after multi lines
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 10:31 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Tue, Feb 9, 2010 at 5:56 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Sat, 6 Feb 2010 21:40:56 +0800
>> Dave Young <hidave.darkstar@gmail.com> wrote:
>>
>>> printk delay help us to capture printk messages on some unconvenient senarios,
>>> but it is still not easy to read.
>>>
>>> Add another sysctl variable printk_delay_per_lines to make it more readable.
>>> We can set the lines according to screen height, then take pictures by camera.
>>>
>>> kmesg will delay printk_delay_per_lines * printk_delay_msecs milliseconds
>>> after every printk_delay_per_lines lines when printk_delay is enabled.
>>>
>>> Setting the lines by proc/sysctl interface:
>>> /proc/sys/kernel/printk_delay_per_lines
>>>
>>> Andrew, sorry, I have not find time to cleanup the kernel.h sysctl variables.
>>> If I'm free I will try to do it.
>>>
>>> The value range from 1 - 100, default value is 1
>>>
>>> ...
>>>
>>> --- linux-2.6.orig/include/linux/kernel.h     2010-02-02 13:38:09.537495564 +0800
>>> +++ linux-2.6/include/linux/kernel.h  2010-02-02 13:40:47.657480122 +0800
>>> @@ -246,6 +246,7 @@ extern bool printk_timed_ratelimit(unsig
>>>                                  unsigned int interval_msec);
>>>
>>>  extern int printk_delay_msec;
>>> +extern int printk_delay_per_lines;
>>>
>>>  /*
>>>   * Print a one-time message (analogous to WARN_ONCE() et al):
>>> --- linux-2.6.orig/kernel/printk.c    2010-02-02 13:39:19.446657319 +0800
>>> +++ linux-2.6/kernel/printk.c 2010-02-02 13:40:47.660813615 +0800
>>> @@ -656,16 +656,26 @@ static int new_text_line = 1;
>>>  static char printk_buf[1024];
>>>
>>>  int printk_delay_msec __read_mostly;
>>> +int printk_delay_per_lines __read_mostly;
>>>
>>>  static inline void printk_delay(void)
>>>  {
>>>       if (unlikely(printk_delay_msec)) {
>>> -             int m = printk_delay_msec;
>>> +             static int m, l;
>>>
>>> +             if (!l)
>>> +                     l = printk_delay_per_lines;
>>> +
>>> +             if (--l) {
>>> +                     m += printk_delay_msec;
>>> +                     return;
>>> +             }
>>> +             m += printk_delay_msec;
>>>               while (m--) {
>>>                       mdelay(1);
>>>                       touch_nmi_watchdog();
>>>               }
>>> +             m = 0;
>>>       }
>>>  }
>>
>> - The default value is zero, not 1.  And zero will be treated as 4G.
>>  That's a bug.
>
> Will fix.
>
>>
>> - This feature would be a lot more useful if the user could specify
>>  printk_delay_per_lines on the boot command line.  Ditto
>>  printk_delay_msec.  So you can stop the important mesages from
>>  scrolling off.  (I think there's already a way to do that, but I'm
>>  too lazy to go remember what it was).
>
> I think it's the similar "boot_delay". It's a little different as
> calibration is not done on the early booting phase, so busy loop
> is used instead to delay. It's hard to make boot delay accurate.
>
> Maybe delay_per_lines can be done while booting as well,
> but it should be another patch,  isn't it?

Or merge the two in one function, so we can set the boot param,
ie. call boot_delay in boot phase, mdelay otherwise.

>
>>
>> - The permitted range of 1-100 for printk_delay_per_lines seems
>>  arbitrary and unneeded.  Why shouldn't I be able to set it to 10,000?
>>  I see no harm in permitting that.
>>
>> - If the user sets printk_delay_per_lines=N, the kernel will pause
>>  for N*printk_delay_msec every N lines.  This is odd, and unintuitive.
>>  And it'll really hurt if I set printk_delay_per_lines=10000!
>>
>>  I'd expect the kernel to pause for printk_delay_msec every N lines,
>>  and I think that would be better.
>
> Fine to me as well. Thanks for your comments.
>

BTW, for the sysctl variables. I found in kernel.h there's:
printk/console_loglevel/panic related extern variables for sysctl.

console_loglevel and panic related variables are used here and there,
not just for sysctl, so I think it should stay in kernel.h.

The printk related variables for sysctl and all the extern variables in
sysctl.c can be move to sysctl.h. Seems no need new head file.

Andrew, what's your opinion?

> --
> Regards
> dave
>



-- 
Regards
dave
