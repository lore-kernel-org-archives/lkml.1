Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbXGFBTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbXGFBTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761429AbXGFBTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:19:41 -0400
Received: from smtpout.mac.com ([17.250.248.184]:52558 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761072AbXGFBTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:19:40 -0400
In-Reply-To: <200707060935.12706.nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707060913.05644.nigel@nigel.suspend2.net> <1183677643.3388.105.camel@localhost.localdomain> <200707060935.12706.nigel@nigel.suspend2.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CF60EC03-0171-4052-924D-57555A393168@mac.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 21:19:32 -0400
To: Nigel Cunningham <nigel@nigel.suspend2.net>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 05, 2007, at 19:35:11, Nigel Cunningham wrote:
> On Friday 06 July 2007 09:20:43 Benjamin Herrenschmidt wrote:
>> No, the freezer creates all those places what are harmful for a  
>> task to block because they will break the freezer :-)
>
> Nice try :) Okay then, you remove the freezer, try hibernating,  
> then get back to me after you've fixed your filesystem because some  
> process that wasn't frozen started writing things after the atomic  
> copy (making the on disk filesystem inconsistent with the snapshot).

Umm, this thread is NOT ABOUT HIBERNATING!!!  Please go back and read  
the subject, specifically the "suspend to RAM" parts :-D.  When your  
hardware can put itself to sleep and atomically preserve memory as it  
does so, you don't need an atomic copy.  For Real Suspend(TM) (IE:  
Suspend-to-RAM), the list of things to do is short and simple:

1)  Stop DMA and put most hardware into low-power states (stops all  
interrupt sources)
2)  Ensure that the other CPUs have finished any trailing interrupt  
handlers and put them to sleep
3)  Put the interrupt-controllers into low-power state
4)  Go to sleep

> As Pavel rightly said, you can get rid of the freezer, but you're  
> only going to have to implement another one that does the  
> essentially the same thing, even if it is at some other level.

How about a freezer whose job it is to "wait for pending hard  
interrupts to complete when we have already guaranteed that we won't  
get any more"?  That part should be really *REALLY* easy.  You don't  
need to care about either userspace processes or kernel threads at  
all.  Specifically, Step 1 consists of:

suspend_device(dev)
{
	set_no_bind_flag(dev);
	for (dev->subdevices)
		suspend_device(dev);
	set_no_io_flag(dev);
	wait_for_in_progress_dma(dev);
	turn_off_interrupts(dev);
	go_to_low_power_state(dev);
}

After you've set the "no_bind" flag, you won't get any *new*  
subdevices trying to bind, therefore it's safe to iterate over the  
list of present sub-devices and suspend them.  Once those are  
suspended and in low-power states you can set a "no_io" flag to  
prevent the driver from submitting more IO.  At that point you can  
lazily wait for existing DMA/IO/interrupts to finish on the device,  
since *NOBODY* will be submitting them anymore, and we certainly  
aren't probing for new devices.  Then you can just turn off the power  
to the device.  When all the leaf devices are off, the parent device  
can be turned off because everything waiting on the leaf devices is  
blocked on them and won't unblock until the parent device *AND* the  
leaf device are turned on again, in that order.

Scheduling and userspace are all still fully enabled in this  
scenario.  Once all your devices are turned off, the only remaining  
running threads will be those which haven't done IO since the  
beginning of the suspend.  We can then disable preemption, turn off  
the timer interrupts, and tell the other CPUs to park all their  
remaining threads in schedule() and sleep.  Then we put the IRQ  
controller to sleep and go to sleep ourselves.  If our driver model  
locking is sufficient to handle putting a parent device to sleep  
while threads are sleeping on a child device then there are exactly 0  
problems.

Resuming is basically running the whole process in reverse.  Runtime- 
suspend is achieved by not setting the 'no_io' or 'no_bind' flags and  
putting selective device-subtrees to sleep without doing anything to  
the rest of the system.

Cheers,
Kyle Moffett

