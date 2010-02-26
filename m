Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496Ab0BZReA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:34:00 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:59650 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461Ab0BZRd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GIe98yN9SoXwd/hYZuTAkTW4WYF+UCjTwmYeo+2GkI5gbbIfM9Yk0+izCVp8qzdTSS
         QtvTmMzQCylCWvGrJjPwUUs5XK/+OlvOvZPjluKw/h852Lz/tpQbA8g2nSKcwB5BRA4I
         qExcRvZJzxmHl13Ejz03as+Zz7wYWs3gdi7dY=
MIME-Version: 1.0
In-Reply-To: <20100226081418.5902446f.akpm@linux-foundation.org>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	 <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
	 <20100226081418.5902446f.akpm@linux-foundation.org>
Date: Fri, 26 Feb 2010 18:33:57 +0100
Message-ID: <b170af451002260933i6a7a5e1el619f8e71c3ae0bc8@mail.gmail.com>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep 
	(w. timeout) until wake_up
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26 lutego 2010 17:14 użytkownik Andrew Morton
<akpm@linux-foundation.org> napisał:
> On Fri, 26 Feb 2010 11:38:59 +0100 Rafa Miecki <zajec5@gmail.com> wrote:
>
>> +#define wait_interruptible_timeout(wq, timeout)
>>     \
>> +({                                   \
>> +    long ret = timeout;                      \
>> +                                    \
>> +    DEFINE_WAIT(wait);                      \
>> +    prepare_to_wait(&wq, &wait, TASK_INTERRUPTIBLE);       \
>> +    if (!signal_pending(current))                  \
>> +        ret = schedule_timeout(ret);            \
>> +    finish_wait(&wq, &wait);                   \
>> +                                    \
>> +    ret;                             \
>> +})
>
> It's often a mistake to use signals in-kernel.  Signals are more a
> userspace thing and it's better to use the lower-level kernel-specific
> messaging tools in-kernel.  Bear in mind that userspace can
> independently and asynchronously send, accept and block signals.

Can you point me to something kernel-level please?


> Can KMS use wait_event_interruptible_timeout()?

No. Please check definition of this:

#define wait_event_interruptible_timeout(wq, condition, timeout)	\
({									\
	long __ret = timeout;						\
	if (!(condition))						\
		__wait_event_interruptible_timeout(wq, condition, __ret); \
	__ret;								\
})

It uses condition there, but that's not a big issue. We just need to
pass 0 (false) there and it will work so far.

But then check __wait_event_interruptible_timeout definition, please.
It goes into sleep and after waking up it checks for value returned by
schedule_timeout. That's what breaks our (needed by radeon) sleeping.
If timeout didn't expire it does into sleep again!

What we need is continue reclocking after waking up. If this has
happend before timeout expired, that means we was woken up by VBLANK
interrupt handler. We love that situation and we do not want to go
sleep again.

On the other hand we need to have some timeout in case VBLANK
interrupt won't come.

-- 
Rafał
