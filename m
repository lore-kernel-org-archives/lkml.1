Return-Path: <linux-kernel-owner+w=401wt.eu-S964948AbXG0LuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948AbXG0LuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbXG0LuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:50:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53742 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765469AbXG0LuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:50:02 -0400
Date: Fri, 27 Jul 2007 12:56:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Howard <faxguy@howardsilvan.com>
Cc: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<ukleinek@informatik.uni-freiburg.de>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070727125655.6a71ab77@the-village.bc.nu>
In-Reply-To: <46A98DFE.3050304@howardsilvan.com>
References: <46A7FE6A.4030309@howardsilvan.com>
	<20070726123420.GA14163@informatik.uni-freiburg.de>
	<46A8CB96.1010501@howardsilvan.com>
	<20070726174150.4ffcabd4@the-village.bc.nu>
	<46A98DFE.3050304@howardsilvan.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -parenb -parodd cs8 -hupcl -cstopb cread clocal crtscts

Ok so crtscts is set, but you have clocal set too. That shouldn't matter

> Using software flow control this is what stty tells me about the port 
> set up done by the application:

This also looks fine

> They seem correct to me, but I am certainly willing to be wrong.

clocal set as well is unusual but if I remember the spec right then
clocal would not interfere with rts/cts handshake and certainly not with
xon/xoff

Looks correct, two boards so its unlikely both didnt wire it.

> A quick google on "input overrun(s)" may lend some credence (although, 
> certainly this is not in any way conclusive) that I'm not the only one 
> who may be seeking a solution on this matter.
> 
>   http://www.google.com/search?hl=en&q=%2B%22input+overrun%28s%29%22

Those look different on the whole - there are two reasons you'll get an
input overrun with a 16x50 UART. The first is because we ran out of
buffers to empty the chip, in which case we would have asserted flow
control in software. The second is if we cannot keep up and fail to empty
the on chip FIFO within the required time (about 1mS)

As the flow control is driven by software on most 16x50 chips (there are
a couple of exceptions) if we fail to empty the fifo fast enough then any
flow control will be asserted too late to save the day.

If you stop the application and do the following

	cat /dev/ttywhatever
	^Z
	[stopped]

(so you are asking the OS to buffer data but not ever reading it)

and then fire data at it does the flow control eventually occur ?

Alan
