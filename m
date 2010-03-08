Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0CHPnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:43:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:51612 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0CHPno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:43:44 -0500
Message-ID: <4B951B0E.3000801@windriver.com>
Date: Mon, 08 Mar 2010 09:43:10 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-serial: Fix usb serial console open/close regression
References: <Pine.LNX.4.44L0.1003081028400.1596-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003081028400.1596-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2010 15:43:11.0331 (UTC) FILETIME=[0EC15330:01CABED6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 8 Mar 2010, Jason Wessel wrote:
>
>   
>> Commit e1108a63e10d344284011cccc06328b2cd3e5da3 ("usb_serial: Use the
>> shutdown() operation") breaks the ability to use a usb console
>> starting in 2.6.32.  This was observed when using
>> console=ttyUSB0,115200 as a boot argument with an FTDI device.  The
>> error is:
>>
>> ftdi_sio ttyUSB0: ftdi_submit_read_urb - failed submitting read urb, error -22
>>
>> The handling of the ASYNCB_INITIALIZED changed in 2.6.32 such that in
>> tty_port_shutdown() it always clears the flag if it is set.  As a work
>> around the usb console must reset this flag, in order for the hw to
>> stay open.
>>
>> CC: Greg Kroah-Hartman <gregkh@suse.de>
>> CC: Alan Cox <alan@linux.intel.com>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>> CC: Oliver Neukum <oliver@neukum.org>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: linux-usb@vger.kernel.org
>> CC: linux-kernel@vger.kernel.org
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>>
>> ---
>>  drivers/usb/serial/usb-serial.c |    7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> --- a/drivers/usb/serial/usb-serial.c
>> +++ b/drivers/usb/serial/usb-serial.c
>> @@ -287,10 +287,13 @@ static void serial_down(struct tty_port 
>>  	struct usb_serial_driver *drv = port->serial->type;
>>  	/*
>>  	 * The console is magical.  Do not hang up the console hardware
>> -	 * or there will be tears.
>> +	 * or there will be tears.  If this is a console the initialized
>> +	 * flag is reset.
>>  	 */
>> -	if (port->console)
>> +	if (port->console) {
>> +		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
>>  		return;
>> +	}
>>  	if (drv->close)
>>  		drv->close(port);
>>  }
>>     
>
> This is a little unfortunate.  It would be better to prevent
> tty_port_shutdown() from clearing ASYNCB_INITIALIZED in the first
> place.  The problem is that the tty core doesn't know when the port is
> being used as a console.  There ought to be a way to tell it.
>   

I agree, but presently there is no way to do so.   Up until 2.6.33 the
ASYNCB_INITIALIZED was being used to track this, but now it is used a
bit differently.

We still also have the same sort of issue for the passing in the initial
baud.  I don't know if you want to go for a short term approach this
way, or try to implement something different right now.  When you do
consider something longer term, I would like it to incorporate the other
serial settings as well, such that if the console initializes them first
the get correctly inherited by the tty open().

Jason.
