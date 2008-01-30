Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbYA3P0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbYA3P0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYA3P0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:26:41 -0500
Received: from ms01.sssup.it ([193.205.80.99]:35970 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752145AbYA3P0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:26:40 -0500
Message-ID: <47A09723.7020000@gandalf.sssup.it>
Date: Wed, 30 Jan 2008 16:26:27 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	<479FB2D7.4020804@gandalf.sssup.it>	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>	<47A051A7.7030004@gandalf.sssup.it> <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> On Wed, 30 Jan 2008 11:29:59 +0100
> michael <trimarchi@gandalf.sssup.it> wrote:
>   
>>> Now, _that_ is strange. I can't see anything that needs protection
>>> across that call; in fact, I think we can lock a lot less than what we
>>> currently do.
>>>
>>>   
>>>       
>> I explain it bad:
>> - with spin_lock the system seems, there is no problem with Valuntary 
>> Preeption and
>> Preemptible Kernel
>> - with full preemption  it runs but the serial line can't be used for 
>> receiving at
>> high bit rate (using lrz)
>>     
>
> ...but if you drop the spinlock across the call to
> tty_flip_buffer_push, you get an Oops?
>
> Could you post the Oops?
>
>   
So this code

/*
* Drop the lock here since it might end up calling
* uart_start(), which takes the lock.
*/
spin_unlock(&port->lock);

tty_flip_buffer_push(port->info->tty);

spin_lock(&port->lock);

Works with:
CONFIG_PREEMPT_RT=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_SOFTIRQS=y
CONFIG_PREEMPT_HARDIRQS=y
CONFIG_PREEMPT_BKL=y

but crash with:
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT_DESKTOP is not set
# CONFIG_PREEMPT_RT is not set
CONFIG_PREEMPT_SOFTIRQS=y
# CONFIG_PREEMPT_HARDIRQS is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_CLASSIC_RCU=y

Seems to work in the last config if I comment the spin_lock & 
spin_unlock call.
/*
* Drop the lock here since it might end up calling
* uart_start(), which takes the lock.

spin_unlock(&port->lock); */

tty_flip_buffer_push(port->info->tty);

/* spin_lock(&port->lock); */

It is not readable because I can't compile it with debugging information 
(poor memory system)
>>>> Complete Preemption (Real-Time) ok but the serials is just unusable due
>>>> to too many overruns (just using lrz)
>>>>     
>>>>         
>>> Is it worse than before? IIRC Remy mentioned something about
>>> IRQF_NODELAY being the reason for moving all this code to softirq
>>> context in the first place; does the interrupt handler run in hardirq
>>> context?
>>>
>>>   
>>>       
>> In the complete preemption yes.
>>     
>
> Which question did you answer "yes" to? That it's worse than before or
> that the interrupt handler runs in hardirq context (i.e. IRQF_NODELAY)?
>
>   
The interrupt handler run in IRQF_NODELAY context.
>>> I think you're right. Can you change it and see if it helps?
>>>
>>>   
>>>       
>> I just change it because I have corruption on receiving buffer. All
>> my test are done with this fix
>>     
>
> Ok.
>
>   
>>> I guess I didn't test it thoroughly enough with DMA
>>> disabled...slub_debug ought to catch such things, but not until we
>>> receive enough data to actually overflow the buffer.
>>>
>>>   
>>>       
>> I just test it I don't have
>> buffer overflow.
>>     
>
> No, I'd expect your allocation fix to take care of that. Or did you by
> any chance test without the fix and with slub_debug enabled?
>
>   
I just meant that the buffer never fills up to its size.
>> I protect with a spinlock the access to the register when we sending
>> from the tasklet. It is correct?
>>     
>
> I have no idea. Could you post some more specifics about what you
> modified, for example a diff?
>
>   

...
/* The interrupt handler does not take the lock */
spin_lock_irqsave(&port->lock, flags);
atmel_tx_chars(port);
spin_unlock_irqrestore(&port->lock, flags);

spin_lock(&port->lock);
...

The atmel_tx_chars using the serial device registers like the interrupt 
routine
and so I think that it is possible to have interference during send 
operation.

> Most of the tasklet is already protected by the spinlock, so you must
> be careful to avoid any lock recursion.
>
> Haavard
>
>   
Regards Michael
