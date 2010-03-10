Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0CJW1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:27:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:54083 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab0CJW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:27:49 -0500
Message-ID: <4B981CD7.3060908@windriver.com>
Date: Wed, 10 Mar 2010 16:27:35 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 5/6] usb-hcd,usb-console: poll hcd device to force usb
 console writes
References: <Pine.LNX.4.44L0.1003091005080.1693-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003091005080.1693-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2010 22:27:42.0656 (UTC) FILETIME=[E66B1C00:01CAC0A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 9 Mar 2010, Jason Wessel wrote:
> 
>> This patch tries to solve the problem that data is lost because there
>> are too many outstanding transmit urb's while trying to execute
>> printk's to a console.  The same is true if you try something like
>> "echo t > /proc/sysrq-trigger".
>>
>> This patch takes the route of forcibly polling the hcd device to drain
>> the urb queue in order to initiate the bulk write call backs.  This
>> only happens if the device is a usb serial console device that sets
>> the max_in_flight_urbs to a non zero value in the serial device
>> structure.
>>
>> A few millisecond penalty will get incurred to allow the hcd controller
>> to complete a write urb, else the console data is thrown away.
>>
>> The max_in_flight_urbs was reduced in the usb_debug driver because it
>> is highly desired to push things out to the console in a timely
>> fashion and there is no need to have a queue that large for the
>> interrupt driven mode of operation when used through the tty
>> interface.
> 
>> --- a/drivers/usb/core/hcd.c
>> +++ b/drivers/usb/core/hcd.c
>> @@ -1973,6 +1973,7 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>>  	local_irq_restore(flags);
>>  	return rc;
>>  }
>> +EXPORT_SYMBOL_GPL(usb_hcd_irq);
> 
> Is there any reason for EXPORTing this?  It doesn't get used anywhere 
> else.
> 


Certainly not anymore.  The previous iteration of this code used this
function.  Thanks for catching that.

>> index a3cdb09..703f407 100644
>> --- a/drivers/usb/core/hcd.h
>> +++ b/drivers/usb/core/hcd.h
>> @@ -318,6 +318,7 @@ extern void usb_put_hcd(struct usb_hcd *hcd);
>>  extern int usb_add_hcd(struct usb_hcd *hcd,
>>  		unsigned int irqnum, unsigned long irqflags);
>>  extern void usb_remove_hcd(struct usb_hcd *hcd);
>> +extern void usb_hcd_poll_irq(struct usb_device *udev);
>>  
>>  struct platform_device;
>>  extern void usb_hcd_platform_shutdown(struct platform_device *dev);
> 
> It might be better to put this in a "public" header file; that is, 
> something under include/linux/usb or include/linux/usb.h.  You could 
> even take the "_hcd" part out of the name, because the interface uses 
> only a struct usb_device, not a struct usb_hcd.

If this is what you prefer, I have no problem with it.  I'll post a v2
of the series after some testing.

Jason.
