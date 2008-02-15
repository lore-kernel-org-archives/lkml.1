Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYBOFTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYBOFTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYBOFTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:19:40 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35894 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYBOFTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:19:39 -0500
Message-ID: <47B520E6.5030809@davidnewall.com>
Date: Fri, 15 Feb 2008 15:49:34 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
References: <47B30291.2040905@davidnewall.com> <20080214050211.GB1432@kroah.com> <47B40918.20206@davidnewall.com> <20080214204744.GB17277@kroah.com>
In-Reply-To: <20080214204744.GB17277@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Feb 14, 2008 at 07:55:44PM +1030, David Newall wrote:
>   
>> The current 2.6 driver maintains it's own buffer.  I think that's a bad
>> thing: usbserial already buffers writes, and the extra buffer copy seems
>> unnecessary, however it does solve the putchar problem.  Buffered (i.e.
>> by the 2.6 series pl2303 driver) data is written as soon as practicable,
>> regardless of CTS/DTR.  The same general workaround, but placed in
>> pl2303_send seems correct to me; that is, stop submitting write urbs
>> when the remote end lowers CTS/DTR, and trigger the resume from the
>> interrupt callback (specifically in update_line_status.)
>>     
>
> Where does the usbserial core buffer writes on 2.6?  The serial_write()
> function just passes the data straight down to the usb-serial child
> driver directly, no copying or buffering happens that I can see.
>   

You're right.  I haven't examined the 2.6 stack as closely as the 2.4. 
I noticed the buffer in 2.6 pl2303, but didn't check 2.6 usb-serial.  I
think I prefer the buffer in usb-serial, because its centralised rather
than in each driver, but I'm not going to step up to the plate and
propose changing that!

>> To make it clear: Even aside from the buffer in 2.6's pl2303.c, there's
>> a race: An in-flight write URB can fill all hardware buffers, making
>> unsafe what previously appeared to be a safe write.  I think it's
>> essential to delay submission of the URB on a stop-transmit condition.
>>     
>
> It's up to the individual driver to know when their buffers are filled
> up.  The big problem is, a lot of these cheap usb-serial devices (like
> the pl2303) don't have a way to report the uart queue filled-state back
> to the host, so things can easily get over-run as you have found out.
>   

My understanding of the problem has developed over the last couple of
days; going from wrist-deep to elbow-deep into the guts of things does
that.  There is a problem, and the solution I've been developing
addresses it, but maybe there's a simpler answer.  Hope to have a patch
together soon.
