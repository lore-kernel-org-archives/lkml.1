Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbZJKFt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbZJKFt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 01:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZJKFt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 01:49:58 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:33844 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZJKFt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 01:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain>
References: <1255165747.6385.117.camel@doodleydee> <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain>
From: Jeremy Leibs <leibs@willowgarage.com>
Date: Sat, 10 Oct 2009 22:48:59 -0700
Message-ID: <92be2ef30910102248t70d5e683tc525580fbf902af1@mail.gmail.com>
Subject: Re: ERESTARTSYS escaping from sem_wait with RTLinux patch
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Blaise Gassend <blaise@willowgarage.com>,
       LKML <linux-kernel@vger.kernel.org>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 10:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Blaise,
>
> On Sat, 10 Oct 2009, Blaise Gassend wrote:
>> 1) Where is the ERESTARTSYS being prevented from getting to user space?
>>
>> The only likely place I see for preventing ERESTARTSYS from escaping to
>> user space is in arch/*/kernel/signal*.c. However, I don't see how the
>> code there is being called if there no signal pending. Is that a path
>> for ERESTARTSYS to escape from the kernel?
>>
>> The following comment in kernel/futex.h in futex_wait makes me wonder if
>> two threads are getting marked as ERESTARTSYS. The first one to leave
>> the kernel processes the signal and restarts. The second one doesn't
>> have a signal to handle, so it returns to user space without getting
>> into signal*.c and wreaks havoc.
>>
>>     (...)
>>         /*
>>          * We expect signal_pending(current), but another thread may
>>          * have handled it for us already.
>>          */
>>         if (!abs_time)
>>                 return -ERESTARTSYS;
>>     (...)
>
> If the task is woken by a signal, then the task private flag
> TIF_SIGPENDING is set, but in case of a process wide signal the signal
> might have been handled by another thread of the same process before
> that thread reaches the signal handling code, but then ERESTARTSYS is
> handled gracefully. So you seem to trigger a code path which does not
> go through do_signal.
>
>> 2) Why would this be happening only with RT kernels?
>
> Slightly different timing and locking semantics.
>
>> 3) Any suggestions on the best place to patch/workaround this?
>>
>> My understanding is that if I was to treat ERESTARTSYS as an EAGAIN,
>> most applications would be perfectly happy. Would bad things happen if I
>> replaced the ERESTARTSYS in futex_wait with an EAGAIN?
>
> No workarounds please. We really want to know what's wrong.
>
> Two things to look at:
>
> 1) Does that happen with 2.6.31.2-rt13 as well ?
>
> 2) Add a check to the code path where ERESTARTSYS is returned:
>
>   if (!signal_pending(current))
>      printk(KERN_ERR ".....");
>

Ok, in 2.6.31.2-rt13, I modified futex.c as:
-----
        /*
         * We expect signal_pending(current), but another thread may
         * have handled it for us already.
         */
        ret = -ERESTARTSYS;
        if (!abs_time)
          {
            if (!signal_pending(current))
              printk(KERN_ERR ".....");
            goto out_put_key;
          }
-----

Then when I cause the crash:

leibs@c1:~$ python threadprocs8.py
sem_wait: Unknown error 512
Segmentation fault

dmesg shows me the corresponding:
[   82.232999] .....
[   82.233177] python[2834]: segfault at 48 ip 00000000004b0177 sp
00007f9429788ad8 error 4 in python2.6[400000+216000]


--Jeremy
