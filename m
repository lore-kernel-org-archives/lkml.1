Return-Path: <linux-kernel-owner+w=401wt.eu-S1031702AbXEAN00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031702AbXEAN00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031701AbXEAN00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:26:26 -0400
Received: from mta8.adelphia.net ([68.168.78.196]:40392 "EHLO
	mta8.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031694AbXEAN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:26:24 -0400
Message-ID: <46373F42.4080305@acm.org>
Date: Tue, 01 May 2007 08:23:14 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: Serial 8250: clear the lsr_break_flag at open
References: <20070430220858.GA28890@localdomain> <20070501092933.GB18233@flint.arm.linux.org.uk>
In-Reply-To: <20070501092933.GB18233@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Mon, Apr 30, 2007 at 05:08:59PM -0500, Corey Minyard wrote:
>   
>> I'm having a hard time understanding why the lsr_break_flag
>> is necessary.
>>     
>
> Merely reading the LSR clears status bits.  We read the LSR repeatedly
> so that we can monitor the transmit FIFO when outputting serial console
> messages.
>
> This means that if you have a busy serial console, and you want to send
> it a sysrq request, there's a chance that the break flag in the LSR will
> be cleared by the transmit FIFO status polling code thereby being lost.
>
> So, we need to remember that status, and we do this via the lsr_break_flag.
>   
I should have said a little more.  I couldn't find anywhere in any docs
for this that said it was a destructive read.  I've done some experiments
and that seems to be the case, though.

So two things:

There are other bits in this register that also appear to be destroyed on
read: framing, parity, and overrun.  Should those be saved, too?

There are several places where the LSR is read and nothing is done
for this, in serial8250_start_tx, serial8250_backup_timeout, and
serial8250_tx_empty.  It seems like these would need to be handled,
too.

If this is really a problem, I'd be glad to generate another patch.

-corey
