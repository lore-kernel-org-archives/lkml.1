Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbZFBN1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbZFBN1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZFBN1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:27:05 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:48298 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZFBN1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fM5QX0kIXcY6F9Kt2dalvNdF/4RiW3x1bZlL7ud1s941HwSuZHhqIQo7HwsXtIYWRH
         RujJ9zj64Tt8hm6P2a9xacb3UqOPvAHz3zC5SJDcVgp3zGqwlvKDAv9pYMnDw6tYiLwV
         TPLyI6Yevp0UOO3kObtE4lhIiU9uRTHl3s0DA=
MIME-Version: 1.0
In-Reply-To: <20090602105609.GA9182@elte.hu>
References: <a8e1da0906020254s34dd0cd9id1b88655cab6d72d@mail.gmail.com>
	 <20090602105609.GA9182@elte.hu>
Date: Tue, 2 Jun 2009 21:27:05 +0800
Message-ID: <a8e1da0906020627u148c3904qb5b792260a0169cf@mail.gmail.com>
Subject: Re: [PATCH] printk: add halt_delay parameter for printk delay in halt 
	phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 6:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Add a halt_delay module parameter in printk.c used to read the printk
>> messages in halt/poweroff/restart phase, delay each printk messages
>> by halt_delay milliseconds. It is useful for debugging if there's no
>> other way to dump kernel messages that time.
>
> nice idea! We frequently have kernel-death warnings/messages that
> scroll off too fast and which cannot be captured.

Thanks! It is for this case indeed.

>
>> halt_delay default value is 0, change it by:
>>
>> echo xxx > /sys/module/printk/parameters/halt_delay
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>> kernel/printk.c   |   21 +++++++++++++++++++++
>> lib/Kconfig.debug |   10 ++++++++++
>> 2 files changed, 31 insertions(+)
>>
>> --- linux-2.6.orig/kernel/printk.c    2009-04-09 16:23:03.000000000 +0800
>> +++ linux-2.6/kernel/printk.c 2009-06-02 17:45:54.000000000 +0800
>> @@ -250,6 +250,26 @@ static inline void boot_delay_msec(void)
>>  }
>>  #endif
>>
>> +#ifdef CONFIG_HALT_PRINTK_DELAY
>
> (this #ifdef is ugly - see below.)
>
>> +/* msecs delay after each halt/poweroff/restart phase printk */
>> +static unsigned int halt_delay;
>> +
>> +static inline void halt_delay_msec(void)
>> +{
>> +     if (halt_delay == 0 || !(system_state == SYSTEM_HALT
>> +                             || system_state == SYSTEM_POWER_OFF
>> +                             || system_state == SYSTEM_RESTART))
>> +             return;
>> +
>> +     mdelay(halt_delay);
>
>>
>>       boot_delay_msec();
>> +     halt_delay_msec();
>
>
> i think it should be done in boot_delay_msec() and the function
> should be renamed to print_delay_msec() or so.

I have two concerns:

1. boot_delay use a busy looping with lpj preset because it's too
early that mdelay is probably not ready yet. Furthermore the delay is
not accurate. For halt issue we can just use mdelay()

2. boot_delay is set by kernel boot paramenter, but IMHO, for halt
delay use sysfs file is more convenient.

>
>>       preempt_disable();
>>       /* This stops the holder of console_sem just where we want him */
>> --- linux-2.6.orig/lib/Kconfig.debug  2009-05-12 11:27:22.000000000 +0800
>> +++ linux-2.6/lib/Kconfig.debug       2009-06-02 17:50:15.000000000 +0800
>> @@ -647,6 +647,16 @@ config BOOT_PRINTK_DELAY
>>         BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
>>         what it believes to be lockup conditions.
>>
>> +config HALT_PRINTK_DELAY
>> +     bool "Delay halt/poweroff/restart printk message by N milliseconds"
>> +     depends on DEBUG_KERNEL && PRINTK && SYSFS
>> +     default n
>> +     help
>> +       This build option allows you to read kernel messages in
>> +       halt/poweroff/restart phase by inserting a short delay after
>> +       each one.  The delay is specified in milliseconds on the
>> +       module parameter: /sys/module/printk/halt_delay.
>
> No need for a Kconfig option - this should be an unconditional
> feature like boot-delay.
>
> This will further simplify the patch and will get rid of that ugly
> #ifdef.

What do you think removing the Kconfig option, then unconditionally
 use halt_delay functions?

>
>        Ingo
>



-- 
Regards
dave
