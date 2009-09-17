Return-Path: <linux-kernel-owner+w=401wt.eu-S933554AbZIQDca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbZIQDca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbZIQDc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:32:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:57790 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284AbZIQDc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:32:29 -0400
Message-ID: <4AB1ADCD.9070407@windriver.com>
Date: Wed, 16 Sep 2009 22:32:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb console,usb-serial: fix regression use of serial->console
References: <Pine.LNX.4.44L0.0909162326270.24041-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909162326270.24041-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 03:32:29.0001 (UTC) FILETIME=[7BA3AB90:01CA3747]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 16 Sep 2009, Jason Wessel wrote:
>
>   
>> During the 2.6.32 development usb serial tty interface was changed.
>> This change caused the usb serial driver to crash when used as a
>> system console.
>>
>> The open and close of the raw hardware has to be protected by the
>> serial->console variable so either the console code does the open and
>> close or the higher level tty based driver executes the open and
>> close.
>>
>> * In serial_open() the raw open must be protected by serial->console
>> * In serial_down() the test_and_clear_bit must be executed before
>>   leaving the function if the device is a serial console
>> * serial_release() should no longer protect for the console condition
>>   due to the 2.6.32 interface changes.  The actual low level close
>>   protection is accounted for in serial_down()
>>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> Cc: Greg KH <gregkh@suse.de>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>>
>> ---
>>  drivers/usb/serial/usb-serial.c |   28 +++++++++++++---------------
>>  1 files changed, 13 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
>> index ff75a35..3d35ed2 100644
>> --- a/drivers/usb/serial/usb-serial.c
>> +++ b/drivers/usb/serial/usb-serial.c
>> @@ -267,10 +267,14 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
>>  		if (mutex_lock_interruptible(&port->mutex))
>>  			return -ERESTARTSYS;
>>  		mutex_lock(&serial->disc_mutex);
>> -		if (serial->disconnected)
>> +		if (serial->disconnected) {
>>  			retval = -ENODEV;
>> -		else
>> -			retval = port->serial->type->open(tty, port);
>> +		} else {
>> +			if (port->console)
>> +				retval = 0;
>> +			else
>> +				retval = port->serial->type->open(tty, port);
>> +		}
>>  		mutex_unlock(&serial->disc_mutex);
>>  		mutex_unlock(&port->mutex);
>>  		if (retval)
>>     
>
> This part of the patch shouldn't be necessary.  The console device
> should always be open.
>
>   

With your other patch you just mentioned, I absolutely agree.  This does
not need to be tracked in this manner and I don't believe this patch is
needed either.


