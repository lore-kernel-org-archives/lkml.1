Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbYBNJZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbYBNJZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYBNJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:25:21 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35779 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYBNJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:25:18 -0500
Message-ID: <47B40918.20206@davidnewall.com>
Date: Thu, 14 Feb 2008 19:55:44 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
References: <47B30291.2040905@davidnewall.com> <20080214050211.GB1432@kroah.com>
In-Reply-To: <20080214050211.GB1432@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Feb 14, 2008 at 01:15:37AM +1030, David Newall wrote:
>   
>> Consider a USB-attached serial port that is set to do RTS/CTS (or
>> DSR/DTR) handshaking: What stops the kernel sending more data to it when
>> the remote end lowers CTS (or DTR)?
>>     
>
> The tty layer should look at the proper flags and not send data on to
> the driver in this kind of instance.
>
> Is this not happening properly for you?  If so, which USB serial driver?
>   

It's not happening properly, for pl2303 (and, I admit it! on kernel
2.4.)  I think there's a widespread problem (i.e. with other drivers.) 
None of the drivers that I've examined check CTS or DTR; or, if they do,
I can't see where.  Likewise, I can't see it being done in n_tty nor
tty_io; not even in usbserial.  The best answer I can see is write_room,
but that doesn't seem quite right.  It seems that data written (via
*_write) will merrily be transmitted to the converter, even while the
remote end is signalling to stop, even if local hardware buffers fill.

I have a working solution for the 2.4 driver, but am looking towards
something for 2.6 and beyond.  The 2.4 solution is in two parts: first,
implement a write_room function, which returns 0 when transmission is
required to stop, which apparently gives a hint to the tty layer.  (NB,
doesn't help when using a different line discipline.)  The second part
is to return 0 (or maybe -EAGAIN?) in the write function when
transmission is required to stop.  This appears sound.  (Note that the
generic putchar does no error checking, and fails when the write URB is
busy.  That's a problem with a fairly obvious solution.)

The current 2.6 driver maintains it's own buffer.  I think that's a bad
thing: usbserial already buffers writes, and the extra buffer copy seems
unnecessary, however it does solve the putchar problem.  Buffered (i.e.
by the 2.6 series pl2303 driver) data is written as soon as practicable,
regardless of CTS/DTR.  The same general workaround, but placed in
pl2303_send seems correct to me; that is, stop submitting write urbs
when the remote end lowers CTS/DTR, and trigger the resume from the
interrupt callback (specifically in update_line_status.)

As I say, this appears to be a widespread problem.  I've looked at a
number of drivers and in none of them can I see anything to prevent
transmission when the remote end demands a stop.  I'm not sure that the
tty layer, which I think I said attempts to address the problem, albeit
it does a half-arsed job, is the right place to do hardware
handshaking.  Equally, I'm not sure that the wheel should be re-invented
for every driver, but that might be unavoidable.

To make it clear: Even aside from the buffer in 2.6's pl2303.c, there's
a race: An in-flight write URB can fill all hardware buffers, making
unsafe what previously appeared to be a safe write.  I think it's
essential to delay submission of the URB on a stop-transmit condition.
