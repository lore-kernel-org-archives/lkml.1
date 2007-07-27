Return-Path: <linux-kernel-owner+w=401wt.eu-S965392AbXG0Xcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392AbXG0Xcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964930AbXG0Xci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:32:38 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57459
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923AbXG0Xcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:32:36 -0400
Subject: Re: serial flow control appears broken
From: Paul Fulghum <paulkf@microgate.com>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>, linux-serial@vger.kernel.org,
       tytso@mit.edu, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <46AA5A0E.1050600@howardsilvan.com>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	 <46A84B4A.6070902@shaw.ca>	<46A8C6F1.4080309@howardsilvan.com>
	 <20070726173121.70088a92@the-village.bc.nu>
	 <46A98845.8010806@howardsilvan.com> <46A9F712.70706@imap.cc>
	 <46D33636.7070200@microgate.com>  <46AA5A0E.1050600@howardsilvan.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 18:28:28 -0500
Message-Id: <1185578908.2989.15.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 13:48 -0700, Lee Howard wrote:
> Here's the output:
> 
>             type: 4
>             line: 1
>             line: 760
>              irq: 3
>            flags: 1358954688
>   xmit_fifo_size: 16
>   custom_divisor: 0
>        baud_base: 115200

OK, the FIFO should be enabled.

What is known:

* The error is a hardware FIFO overrun.
  - observed message is in n_tty due to driver setting TTY_OVERRUN

* The RTS/CTS flow control is not involved
  - this is done only by the ldisc in response to buffer levels
  - you verified crtscts is set
  - you did not observed RTS change when 'overflow error' logged
  - you did observe RTS change when application stopped reading

So this seems to be a latency issue reading the receive
FIFO in the ISR. The current rx FIFO trigger level
should be 8 bytes (UART_FCR_R_TRIG_10) which gives the
ISR 694usec to get the data at 115200bps.

IIRC, in 2.2.X kernels this defaulted to 4 bytes
(TRIG_01) which gave a little more time to service the interrupt.

How does the data rate affect the frequency of the overrun errors?
Does 57600bps make them go away?

--
Paul




