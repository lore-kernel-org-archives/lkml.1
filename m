Return-Path: <linux-kernel-owner+w=401wt.eu-S2992802AbXDRQPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992802AbXDRQPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992796AbXDRQPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:15:43 -0400
Received: from mta13.mail.adelphia.net ([68.168.78.44]:38415 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992795AbXDRQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:15:42 -0400
Message-ID: <4626442B.5050708@acm.org>
Date: Wed, 18 Apr 2007 11:15:39 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Provide better abstraction for the serial drivers to
 xmit buf and tty
References: <20070418045423.GA12136@localdomain> <20070418102027.0e1edb2b@the-village.bc.nu>
In-Reply-To: <20070418102027.0e1edb2b@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The basic reason for all this is to eventually allow the low-level
>> serial drivers to function without a uart_info structure being
>> allocated.  This will allow the serial console, debuggers like kgdb,
>> and the IPMI serial driver to use one interface to the uart code and
>>     
>
> Its cheaper to allocate a uart_info that keep doing all the checks, at
> least for port->info. I can see why you want to avoid port->info->tty as
> a debugger can end up running before the tty layer and that would be hard
> to work around.
>   
Currently the uart_info structure is allocated on an open, so it's not
available until that point in time.  The trouble is that console_init() is
called before memory is set up, so you can't allocate the uart_info
until it's too late for the console or a debugger that wants to work
early, though it's ok for IPMI.
> For the other macros - the macros are more efficient than the equivalent
> inline code generation at least for some gccs.
>   
I thought that inlines were preferred, but I can do macros.
> Do you really need any of this change but to check info->tty ?
>   
I'm not really sure.  For IPMI I could do without it, but I'm not
sure about consoles or debuggers.

I have a patch that does consoles over this.  Part of that is moving
the transmit (circ) buffer to the port, so that port->info is not required
at all for console I/O and the console code can supply its own transmit
buffer.  This allows the polled I/O code to reuse all the standard uart
operations for the low-level driver and for the user code, just having
to add a function to call the interrupt handlers properly.

The uart_info struct is not very big, maybe it would be best to pull that
into uart_port?  But the circ buffer might still be a problem, since it
would need to be dynamically allocated and it might need to be
checked instead.

-corey
