Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZEFP77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZEFP77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZEFP7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:59:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:41277 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbZEFP7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:59:47 -0400
Message-ID: <4A01B3E4.6020408@windriver.com>
Date: Wed, 06 May 2009 10:59:32 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
References: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com> <Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org> <20090506152521.GA4603@kroah.com>
In-Reply-To: <20090506152521.GA4603@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2009 15:59:32.0795 (UTC) FILETIME=[A55958B0:01C9CE63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>>> This patch takes the route of forcibly polling the hcd device to drain
>>> the urb queue and initiate the bulk write call backs.
>>>
>>> NOTE this patch is not signed off, it is a question of what is the
>>> right way to do this?
>>>       
>> This patch is highly questionable.
>>     
>
> I agree.
>
>   

That is why there is no signed-off on this patch.  It is an
RFC/EXPERIMENTAL because it is not clear how to fix the problem.  See
below for more discussion.

>> Is the idea to force the HCD to search for completed URBs before the
>> host controller has issued a completion interrupt?  Wouldn't it be
>> better instead to use more URBs?
>>
>> Besides, why should there be too many outstanding transmit URBs?  A
>> normal serial debugging port running at 115200 baud can transmit no
>> more than 12 bytes per ms.  You should be able to surpass that using
>> only three URBs!  In fact, if you buffer up to 8 bytes per URB then
>> with only two URBs you could send 64 bytes per ms, which is equivalent
>> to 640000 baud.  Do you really need to go more than (say) ten times
>> faster than that?
>>     
>
> Yeah, something seems wrong here.
>
> Jason, why is this really needed?  With your ring buffer, you shouldn't
> need this at all anymore.
>
> Or if you do, just bump up the number outstanding urbs that are
> possible.  Or the urb buffer size.
>
>   

The URB queue has to be unacceptably large to make it work correctly
(>4000)   The issue here stems from the register_console() function.  
As a part of the registration with register_console, the usb_debug
device driver gets a huge flood of printk backlog.  Because the urb
queue is not that deep we loose valuable printk logs.  I would very much
like a way to force it to work correctly.

To answer Alan's question, the rs232 uart drivers don't process the
printk back log asynchronously.  It is a direct write to the hardware
(see serial8250_console_putchar - drivers/serial/8250.c).   That is why
there is no problem with lost printk data in the case of the uart drivers.

I could find no obvious safe way do to this synchronously with the USB
api, which is why I put together some way to "force it to work" with the
poll hook until we can figure out the right way to do this.  The
mechanism for a console write is not the same as the standard tty
service, or at least that is the way it is today in the kernel.

Essentially I am seeking a synchronous write and wait for the usb serial
drivers when used as a system console.  Right now in the usb serial API
there is no distinction between a console write and a tty write. 
Perhaps that is what needs to change, to allow for some synchronous
behavior in usb_console_write()?

The usb_debug driver is not the only usb serial device that loses data
from the printk backlog, the ftdi_sio driver suffers the same problem.

Jason.
