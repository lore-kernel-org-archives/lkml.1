Return-Path: <linux-kernel-owner+w=401wt.eu-S1030887AbXDNOh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030887AbXDNOh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 10:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030893AbXDNOh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 10:37:26 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37519 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030887AbXDNOhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 10:37:25 -0400
Date: Sat, 14 Apr 2007 16:37:19 +0200
From: Jan Yenya Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, osv@javad.com
Subject: Re: [RFC 1/1] Char: mxser_new, fix recursive locking
Message-ID: <20070414143719.GA5203@fi.muni.cz>
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com> <462079ED.2000605@gmail.com> <3018694794025219@wsc.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3018694794025219@wsc.cz>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 14 Apr 2007 16:37:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
: I would rather incline to the second variant as it is the original approach
: from moxa driver and I have no idea, what might happen if we drop the lock
: before calling all involved mxser_ routines.
: 
: Could you both (if possible) test the attached patch and drop a message,
: please?

	Works for me, altough it spits tons of (bogus, in this case)
warnings about possibly uninitialized variable "flags".

	Additionally, I think it is overzealous to wrap _all_
spin_lock_irqsave/irqrestore() with if (!in_interrupt()). Some of them are
never called from the interrupt context (mxser_block_till_ready(), for example
- it can block, so if it is ever called from the interrupt context, we have
a different, an order of magnitude worse problem here :-)

	I have another problem with the driver - it probably sometimes
drops DCD signal on the serial line or something like that:
when the traffic on the serial console is heavy, it sometimes disconnects
me from the remote shell, and cu(1) displays the login prompt from the new
instance of mgetty of the remote machine. However, it does so both with
mxser.o and mxser_new.o (in 2.6.21-rc6, I think it worked in 2.6.19,
but I have to retest it). So this is another problem, different from
the one we are trying to solve now.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
