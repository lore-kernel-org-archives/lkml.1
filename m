Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbXGZHUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbXGZHUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761041AbXGZHUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:20:47 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:29188 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605AbXGZHUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:20:46 -0400
Date: Thu, 26 Jul 2007 01:20:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: serial flow control appears broken
In-reply-to: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Message-id: <46A84B4A.6070902@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Howard wrote:
> Hello.
> 
> I have fax modems that will, in their proper behavior with certain 
> features, send up to 64 kilobytes of data to the host DTE all at once.  
> (So, the fax modem handles an incoming fax and periodically will send 
> between 256 bytes and 64 kilobytes of data in bursts.)
> 
> When the DCE-DTE (modem-to-host) communication rate is established at 
> 115200 bps data loss occurs systems using at least Linux kernels 2.6.5 
> and 2.6.18 (and probably everything in-beween and then some more).  This 
> is because the modem overflows the host's buffer.  This is evidenced in 
> kernel logging:
> 
> Jul 23 14:01:30 gollum kernel: ttyS1: 1 input overrun(s)
> Jul 23 17:09:45 gollum kernel: ttyS1: 1 input overrun(s)
> 
> Normally I would blame the modem itself for not honoring the host's flow 
> control signals.  However, I have worked with the modem manufacturer 
> closely on this matter for over three months now.  In that process they 
> have improved the responsiveness of the modem and have fixed other 
> problems, but the end result is that it truly does appear that the 
> serial tty driver is not using flow control.  Whether software flow 
> control (XON/XOFF) or hardware flow control (RTS/CTS) is used the result 
> is the same.
> 
> This is evidenced in hardware flow control by a little LED labeled "RTS" 
> that is on the external modem.  This LED lights up when pin 7 of the DB9 
> serial connection is given +12Vdc current (signalling "RTS" is on - that 
> the host can accept data).  The LED goes dark when the current is 
> removed (signalling that the host cannot accept data).  This "RTS" LED 
> never flickers at all, as it should, when receiving these bursts of data 
> - the LED stays lit as long as the serial cable is connected to the 
> host... and yet I will see those "input overrun" messages.  Thus, it 
> seems quite clear that the Linux serial tty driver is not deasserting 
> RTS as it should in hardware flow control.  (And probably the analogous 
> problem exists in software flow control, too.)
> 
> Please tell me what I can do to help you resove and/or remedy this 
> matter.  Also, please let me know if I have contacted the wrong people.  
> (I have cross-posted to linux-kernel as a catch-all.  I am not 
> subscribed to either linux-serial or linux-kernel mailing lists.  So 
> please CC me in any list responses.)
> 
> If it is of any value to know (perhaps they have common code?), the same 
> error occurs on FreeBSD 6.2 as well.   The problem does not occur on 
> Windows.  The problem does not occur on RedHat 6.0 (kernel 2.2.5).

What kind of serial port and machine is this on? From what I can see, a 
standard 16550 UART (not a special variant) just doesn't have any 
support for clearing RTS on its own when its input FIFO gets too full. 
The kernel would have to do it in that case. I'm not seeing where it 
would be controlling that automatically (as opposed to manually from the 
application with TIOCM_RTS). I'm also not sure if the UART gives the 
kernel enough information for it to even be able to control this line 
properly automatically.

That's assuming it actually is a 16550 or similar with a 16-byte FIFO at 
all, which assuming it's a non-ancient PC it should be, but who knows.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

