Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYA3Kad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYA3Kad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYA3KaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:30:25 -0500
Received: from ms01.sssup.it ([193.205.80.99]:47436 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754565AbYA3KaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:30:24 -0500
Message-ID: <47A051A7.7030004@gandalf.sssup.it>
Date: Wed, 30 Jan 2008 11:29:59 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	<479FB2D7.4020804@gandalf.sssup.it> <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
> On Wed, 30 Jan 2008 00:12:23 +0100
> michael <trimarchi@gandalf.sssup.it> wrote:
>
>   
>> - Voluntary Kernel Preemption the system (crash)
>> - Preemptible  Kernel (crash)
>>     
>
> Ouch. I'm assuming this is with DMA disabled?
>
>   
Yes, is with DMA disabled
>> /*
>>  * Drop the lock here since it might end up calling
>>  * uart_start(), which takes the lock.
>>    spin_unlock(&port->lock);
>>  */
>>     tty_flip_buffer_push(port->info->tty);
>> /*
>>     spin_lock(&port->lock);
>>  */
>> The same code with this comments out runs
>>     
>
> Now, _that_ is strange. I can't see anything that needs protection
> across that call; in fact, I think we can lock a lot less than what we
> currently do.
>
>   
I explain it bad:
- with spin_lock the system seems, there is no problem with Valuntary 
Preeption and
Preemptible Kernel
- with full preemption  it runs but the serial line can't be used for 
receiving at
high bit rate (using lrz)
>> Complete Preemption (Real-Time) ok but the serials is just unusable due
>> to too many overruns (just using lrz)
>>     
>
> Is it worse than before? IIRC Remy mentioned something about
> IRQF_NODELAY being the reason for moving all this code to softirq
> context in the first place; does the interrupt handler run in hardirq
> context?
>
>   
In the complete preemption yes.
>> The system is stable and doesn't crash reverting this patch.
>> I don't test with the thread hardirqs active.
>>     
>
> Ok.
>
>   
>> Is the kmalloc correct?
>> maybe:
>> data = kmalloc(ATMEL_SERIAL_RINGSIZE * sizeof(struct atmel_uart_char), 
>> GFP_KERNEL);
>>     
>
> I think you're right. Can you change it and see if it helps?
>
>   
I just change it because I have corruption on receiving buffer. All
my test are done with this fix
> I guess I didn't test it thoroughly enough with DMA
> disabled...slub_debug ought to catch such things, but not until we
> receive enough data to actually overflow the buffer.
>
>   
I just test it I don't have
buffer overflow.

I protect with a spinlock the access to the register when we sending
from the tasklet. It is correct?
>
> Why should it be? If it should, we must move the call to tasklet_init
> into atmel_startup too, and I don't really see the point.
>
>   
Ok


Regards Michael
