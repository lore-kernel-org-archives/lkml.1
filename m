Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXG0SXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXG0SXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbXG0SXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:23:40 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:27150 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbXG0SXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:23:39 -0400
Date: Fri, 27 Jul 2007 12:22:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: serial flow control appears broken
In-reply-to: <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Message-id: <46AA3801.7090204@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>
 <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
 <46AA2748.80703@howardsilvan.com>
 <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Fri, 27 Jul 2007, Lee Howard wrote:
> 
>> Okay, so let's say we've got a loop around a blocking read on the modem file
>> descriptor...
>>
>>  for (;;) {
>>      read some data from modem
>>      process data from modem
>>      if (end-of-data detected) break;
>>  }
>>
>> Are you suggesting that the application should be using deasserting RTS after
>> the read and asserting it before?
> 
>  It certainly could -- you were asking how it would know. ;-)
> 
>> I had previously thought that the control of RTS was something that the
>> serial/tty driver was supposed to do independently based on the buffer fill.
> 
>  The TTY line discipline driver could do that based on the amount of 
> received data present in its buffer.  And it should if asked to (a brief 
> look at drivers/char/n_tty.c reveals it does; obviously there may be a bug 

Really, where? In my look through the code I haven't found any mechanism 
that would result in RTS being lowered based on TTY buffers filling up, 
at least not in the 8250 case.

In this situation, though, it appears it's not the TTY buffers that are 
filling but the UART's own buffer. I would think this must be caused by 
some kind of interrupt latency that results in not draining the FIFO in 
time.

> somewhere though).  So could e.g. the SLIP and PPP line discipline 
> drivers, though the criteria might be different (apparently they do not, 
> which is a shame).
> 
>  The serial drivers have nothing to do about it -- all they can do is 
> pushing data upstream, to the discipline driver.  They can provide an 
> interface to hardware flow control features though, if implemented by a 
> given UART.
> 
>   Maciej
> 
