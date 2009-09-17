Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZIQERm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZIQERm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 00:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZIQERl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 00:17:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:63892 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZIQERl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 00:17:41 -0400
Message-ID: <4AB1B860.4080105@windriver.com>
Date: Wed, 16 Sep 2009 23:17:36 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
References: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 04:17:36.0160 (UTC) FILETIME=[C93B5A00:01CA374D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 16 Sep 2009, Jason Wessel wrote:
>
>   
>> Alan Stern wrote:
>>     
>>> On Wed, 16 Sep 2009, Jason Wessel wrote:
>>>
>>>   
>>>       
>>>> The first open of the usb serial HW has the termios initialized to the
>>>> default of 9600 baud, and this will override what ever was setup via
>>>> the original console initialization.
>>>>     
>>>>         
>>> I don't understand.  The first open of the console hardware occurs in 
>>> console.c as part of usb_console_setup(), and it uses the baud rate 
>>> passed in via the console options.  Why does anything need to get 
>>> saved?
>>>   
>>>       
>> The initialization in console.c is done with a dummy tty structure that
>> is thrown away.  It is thrown away because it was not connected to any
>> device handle.
>>
>> Any new tty that is opened defaults to 9600 baud, for the mct_u232
>> driver as an example, if you boot the system with
>> console=ttyUSB0,115200, when mingetty starts it will inherit 9600 from
>> the first tty that is opened, vs reading the value from the HW.  Even if
>> you have a pl2303 and boot with the 115200 baud, you can run "stty -a <
>> /dev/ttyUSB0" and you will see it reports it is running at 9600.  The
>> pl2303 driver just happens to work because it handles the baud differently.
>>
>> I elected to save the baud because:
>>
>> 1) There was no uniform interface to read the current baud from the usb
>> hardware
>>
>> 2) There was no documented API for getting tty to attach when you create
>> the initial console.
>>
>> If there is a better way to fix this, it would be good to continue the
>> discussion.
>>     
>
> I guess a better approach would be not to throw away the "dummy" tty 
> structure, thereby keeping the termios structure as well.  But I don't 
> know if this is practical.
>
> How do other serial console drivers handle this?
>
>   

My answer goes back to the point #1.

If we take the 8250 driver for example,  it reads the HW and force sets
the baud into the termios structure of the real tty.   There are several
layers but in the example case in 8250.c, the serial8250_set_termios()
calls uart_get_baud_rate() to establish "the baud rate to use".

As far as I could tell even the uart based serial drivers use a dummy
termios structure for the initial setup of the console, but do so with
stack memory instead of heap memory.

It looked like the API for the tty subsystem was gradually changing such
that the ldisc structure could ultimately get shared for use with the
console, but this work is not complete, so we are somewhere in between.

The question is what is an acceptable solution?

Depending on the route you go you could modify part of the tty
subsystem, the high level usb serial API to work similarly to the uart
based serial api.

Jason.

