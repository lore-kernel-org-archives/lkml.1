Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZEFUZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZEFUZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZEFUZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:25:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:56309 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZEFUZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:25:04 -0400
Message-ID: <4A01F201.3020406@windriver.com>
Date: Wed, 06 May 2009 15:24:33 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
References: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org> <200905062201.42965.oliver@neukum.org>
In-Reply-To: <200905062201.42965.oliver@neukum.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2009 20:24:33.0116 (UTC) FILETIME=[AAADC9C0:01C9CE88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 6. Mai 2009 21:24:56 schrieb Alan Stern:
>   
>> Converting \n to \r\n will add some complication
>> but not too much.
>>     

This conversion is done in the tty layer "the high level".  By the time
the low level driver gets it character stream via the tty call backs
everything is already processed.

>> Allocating URBs on the fly adds a lot of complication.  There has to be
>> a minimum number of pre-allocated URBs; otherwise write_room could
>>     
>
> Why? You can always calculate with the number of URBs you'd
> allocate as a maximum.
>
>   

In the scheme originally posted with the cap of 42 "in flight" urbs, I
had not seen it run out while using the standard tty driver.   The tty
driver really is not really the key problem I was after with the forced
poll patch.

The console driver is where all the character loss is going on.  There
is no tty interface, and there are no "write room" checks.  The present
kernel interface to the uart console callbacks is synchronous.

Here is a back trace to illustrate the typical 8250 driver.

#0  serial8250_console_putchar at drivers/serial/8250.c:2690
#1  0xc03977d4 in uart_console_write at drivers/serial/serial_core.c:1810
#2  0xc039cbb8 in serial8250_console_write at drivers/serial/8250.c:2729
#3  0xc022802b in __call_console_drivers at kernel/printk.c:419
#4  0xc022808b in _call_console_drivers at kernel/printk.c:449
#5  0xc0228269 in call_console_drivers at kernel/printk.c:499
#6  release_console_sem at kernel/printk.c:1020
#7  0xc022872b in vprintk at kernel/printk.c:749
#8  0xc022889b in printk at kernel/printk.c:582

Doing enough printk's such as in register_console() will cause loss
because you run out of URBs unless you can force them to complete.

Is there a valid way we can force the urbs to complete short of "polling
the heck out of the host controller" or have a synchronous interface in
the case of the console write call back?

There are two different call paths into the USB serial drivers just like
the uart drivers.  One is for the tty callbacks and other is for the
console call backs.  I am most interested how to fix the console writes
(with respect to the original experimental patch).

Jason.
