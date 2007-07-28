Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbXG1Ewz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbXG1Ewz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 00:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXG1Ewq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 00:52:46 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:40171 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXG1Ewp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 00:52:45 -0400
Message-ID: <46AACB4D.7080004@howardsilvan.com>
Date: Fri, 27 Jul 2007 21:51:25 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Tilman Schmidt <tilman@imap.cc>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	 <46A84B4A.6070902@shaw.ca>	<46A8C6F1.4080309@howardsilvan.com>	 <20070726173121.70088a92@the-village.bc.nu>	 <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>	 <46D33636.7070200@microgate.com>  <46AA5A0E.1050600@howardsilvan.com> <1185578908.2989.15.camel@x2>
In-Reply-To: <1185578908.2989.15.camel@x2>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum wrote:

>So this seems to be a latency issue reading the receive
>FIFO in the ISR. The current rx FIFO trigger level
>should be 8 bytes (UART_FCR_R_TRIG_10) which gives the
>ISR 694usec to get the data at 115200bps.
>
>IIRC, in 2.2.X kernels this defaulted to 4 bytes
>(TRIG_01) which gave a little more time to service the interrupt.
>
>How does the data rate affect the frequency of the overrun errors?
>Does 57600bps make them go away?
>  
>

The overrun error message does not occur on every instance of data 
corruption.  (I just became aware of this as I've not been paying so 
much attention to the error messages as I have been to the corrupt 
data.)  The data gets far more corrupted than the error messages would 
lead me to believe.  Since the data being sent from the fax modem to the 
host is identical (same image data) every time it's easier for me to 
measure the effect of one bitrate over another by examining the number 
of missing bytes from the data.

The image has a total of 140465 bytes.  Just now I sent it 5 times each 
at 115200, 57600, 38400, and 19200 bps.

At 115200 bps the number of bytes skipped were:  63, 5, 44, 48, and 2.

At 57600 bps the number of bytes skipped were:  0, 1, 13, 9, and 12.

At 38400 bps the number of bytes skipped were 858, 0, 0, 0, and 8.

At 19200 bps the number of bytes skipped were 0, 0, 0, 0, and 0.

Curiously, the session at 38400 bps that skipped 858 bytes... coincided, 
not just in sequence but also in precice timing within the session, with 
a small but noticeable disk load that I caused by grepping through a 
hundred session logs.  (I can't reproduce it easily, though, because of 
disk caching.)

And, perhaps this is relevant... the way that I have the fax modem 
sending the data to the host is by receiving it from another fax modem 
which is sending it.  Thus, the modem on ttyS0 is sending a fax to the 
modem on ttyS1.  Due to the error correction protocol that is performed 
between the two fax endpoints I can guarantee that the data is correct 
as it leaves the DCE.  I mention this in case there is any limitation to 
how the 8250 driver performs when two modems are being run simultaneously.

Thanks,

Lee.

