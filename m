Return-Path: <linux-kernel-owner+w=401wt.eu-S965586AbXCGUIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbXCGUIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965597AbXCGUIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:08:21 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:2642 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965586AbXCGUIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:08:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 07 Mar 2007 20:08:18.0686 (UTC) FILETIME=[591F51E0:01C760F4]
Content-class: urn:content-classes:message
Subject: Re: Sleeping thread not receive signal until it wakes up
Date: Wed, 7 Mar 2007 15:08:18 -0500
Message-ID: <Pine.LNX.4.61.0703071457060.13923@chaos.analogic.com>
In-Reply-To: <1b2aacd80703071128v5227382do2277d0b85ca3b20c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Sleeping thread not receive signal until it wakes up
Thread-Index: Acdg9FkoZ3xMXnJ/QWut1X8fNBrDzw==
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com> <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com> <1b2aacd80703071128v5227382do2277d0b85ca3b20c@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Luong Ngo" <luong.ngo@gmail.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>
> On 3/7/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>
>> On Wed, 7 Mar 2007, Luong Ngo wrote:
>>
>>> Hi all,
>>>
>>> I am having this problem. I have a process with 2 threads created. One
>>> of the thread will keep calling IOCTL  to get information from the
>>> kernel and will be blocked if there is no new information. If there is
>>> information retured, the thread will be checked to see if any error
>>> happens and trigger an action. Since we have no way to know if the
>>> error is gone (Hardware provides no signal), so what we do is when
>>> trigger an action for the error, we will set an timer using alarm()
>>> and register a SIGALRM handler in the thread by using sigaction. After
>>> setting the alarm, the thread will loop back and call IOCTL, which
>>> could cause it to be put to sleep. The problem is the SIGALRM handler
>>> does not receive the SIGALRM while the thread is being blocked by
>>> IOCTL. And if we generated some event so that the IOCTL is returned
>>> with new information, the SIGALRM handler is invoked right away.
>>> However, as I read the manual, which says a thread/process should be
>>> waken up even when it sleeps if there is a signal delivered to it. Am
>>> I right?
>>> One thing I don't know it mattters or not is that I am not using
>>> sigwait to block the process and wait for signal because the thread
>>> need to go back to the IOCTL call and be slept on that. So I used
>>> sigaction to register the signal handler in hope that this handler wil
>>> be invoked by the kernel when there is an SIGALRM delivered to the
>>> thread.
>>> Could anyone tell me if I did something wrong and what is the correct
>>> way to achieve this task? I tried to avoid creating another thread
>>> which will call sigwait and block until the IOCTL thread send it
>>> explicitly a signal because I want to use timer.
>>>
>>>
>>> Thank you in advance,
>>> LNgo
>>> -
>>
>> Later versions of the kernel lock the kernel when an ioctl() is
>> entered. This means that if you sleep in the ioctl(), nothing
>> will get scheduled.
>>
>> You can do the following (possibly unsafe) in your ioctl():
>>
>>     int locked = kernel_locked();
>>
>>     ......... code
>>     ......... code
>>
>>     if(locked)  // Before sleeping section
>>        unlock_kernel();
>>     .......... sleeping code
>>     if(locked)  // After sleeping section
>>         lock_kernel();
>>
>>
>>
>> Cheers,
>> Dick Johnson
>> Penguin : Linux version 2.6.16.24 on an i686 machine (5592.71 BogoMips).
>> New book: http://www.AbominableFirebug.com/
>> _
>>
>> Thank you.
>>
On Wed, 7 Mar 2007, Luong Ngo wrote:

> Hi Dick,
> Thanks for your response. In my ioctl in the kernel, I use
> interruptible_sleep_on to sleep on a queue and will be wake up by the
> the ISR routine when interrupt happens, so  isn't
> interruptible_sleep_on supposed to be interruptable, from its name? I
> am using kernel 2.6.14.
>
> Thanks again,
> LNgo

Please don't "top post," you need to put answers at the bottom.

Interruptible_sleep_on is interruptible, but for your task to
actually be awakened and your alarm handler to get some CPU,
it needs to be scheduled. If the BKL (big kernel lock) is
held, it won't be scheduled until it is released.

So, even though the semaphore that the "wake_up_interruptible()"
function called, has been enabled, not a lot will happen until the
kernel lock is released. The ISR code that executed
wake_up_interruptible() doesn't schedule. It just returns to your
interrupt handler.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.71 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
