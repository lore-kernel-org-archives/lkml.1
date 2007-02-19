Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXBSQmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXBSQmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbXBSQmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:42:10 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3478 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbXBSQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:42:09 -0500
Date: Mon, 19 Feb 2007 16:42:00 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070219164200.GF27370@flint.arm.linux.org.uk>
Mail-Followup-To: Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D9D073.7020701@inov.pt>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 04:29:39PM +0000, Jose Goncalves wrote:
> Russell King wrote:
> > On Tue, Feb 20, 2007 at 02:48:14PM +0000, Frederik Deweerdt wrote:
> >   
> >> (trimmed tie-fei.zang from the CC, added by mistake)
> >> On Mon, Feb 19, 2007 at 02:35:20PM +0000, Russell King wrote:
> >>     
> >>>> Neither did I, but introducing printk's through the function, we narrowed
> >>>> the problem to this part of the code. And removing it makes the problem
> >>>> go away. We inserted 37 printk's in the function body, and Jose bisected
> >>>> those until the problem went away.
> >>>>         
> >>> Well, there's still little clue about why this is causing a NULL pointer
> >>> dereference.  The only thing I can think is that somehow performing
> >>> this test is causing a power glitch to your CPU, causing its registers
> >>> to get corrupted, and which results in it doing a NULL pointer deref.
> >>>       
> >> That may be the case, indeed.
> >>     
> 
> But if the problem was a power glitch I should get Oops with or without
> printk() inserted, shouldn't I?

That depends if the printk() changes the timing such that it doesn't occur.
Don't know, I'm only grasping at straws due to the lack of any concrete
information.

> >> If you see other tests to be performed...
> >
> > Maybe adding some delays in that bit of code?  I'm sure you've already
> > thought of that though.  Since no one has a proper understanding of the
> > problem, the only suggestions possible are mere shots in the dark.
> 
> I'm no kernel expert, but it's not possible to trace what is the
> instruction that is causing the NULL pointer dereference?

The reported dump shows that the kernel tried to access virtual address 0,
and the instruction pointer seems to be the cause of that - it has a value
of zero in that dump.

The call trace indicates that the last function was called from around
"uart_startup+0x63/0xf4" which is probably the indirect function call
to serial8250_startup().  That's unconfirmed - the only way to get it
confirmed is if you could dump the entire uart_startup() function.

$ grep uart_startup System.map
(address) T uart_startup
$ objdump -r -d vmlinux --start-addr=0x<address> --stop-addr=0x<address+256>

The grep should get you the address of uart_startup.  Replace <address>
with that value and <address+256> with the value plus 256 (0x100) and
mail the result.

> I have no clue on what is causing this problem but, what I know, is
> that I can always reproduce it, and it always happens in the same code
> section of serial8250_startup().

We're both at the same level of clue about the problem then.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
