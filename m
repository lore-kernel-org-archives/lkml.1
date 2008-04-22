Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbYDVKNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbYDVKNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758985AbYDVKN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:13:29 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:12661 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753717AbYDVKN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:13:28 -0400
Date: Tue, 22 Apr 2008 12:13:26 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, Jeff Garzik <jeff@garzik.org>,
       alan@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/15] drivers/char: minor irq handler cleanups
Message-ID: <20080422101326.GD23482@bitwizard.nl>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com> <20080419060011.GA29321@bitwizard.nl> <1208851540.9640.95.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208851540.9640.95.camel@pasglop>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:05:40PM +1000, Benjamin Herrenschmidt wrote:
> 
> On Sat, 2008-04-19 at 08:00 +0200, Rogier Wolff wrote:
> > 
> > You added a "XXX Using free_irq in the interrupt is not wise!". When I
> > wrote that code, I didn't know about this. These lines triggered when
> > the level-triggered PCI interrupt stuck "active" this would mean that
> > NO userspace code would get executed anymore: Hard lock up. Difficult
> > to debug. This happend a few times during development when the code
> > behind the "if (!polled)": "tell the hardware we've seen the
> > interrupt" didn't work. On the other hand, some failures in the field
> > have triggered this. So I think it's wise to keep it in. Disabling the
> > interrupt on the card is not an option, because that's exactly what
> > this is supposed to catch: We're unable to make the card stop
> > interrupting the CPU.
> > 
> > Note that it also doesn't work (i.e. hard lock of the machine) if some
> > other driver is using the same interupt.
> 
> You should let the kernel generic code deal with the runaway interrupt,
> it should be capable of doing so nowadays pretty reliably.
> 
> free_irq() is definitely not going to be happy when it start messing
> with /proc from an interrupt... It will at least give you a WARN_ON.

The situation is NOT normal operation. It is an emergency measure in
an attempt to prevent a full hang. It is great that other parts of the
kernel also "shout" that something is wrong.

Consider it similar to a "kernel null pointer dereference". Once that
happens, all bets are off. In practise you've probably seen one, and
you were able to continue to work. It is advisable to save everything
you can, and reboot. This is similar. 

The "generic code for runaway interrupts" didn't exist when this was
written. If it exists, and works for the case that this was written
for, then all is fine, and we can remove my code. As you can see, I
copied over the code from one driver to the next after I got bitten
again with the second driver. So having something generic is of course
preferable. :-)

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
