Return-Path: <linux-kernel-owner+w=401wt.eu-S1750939AbXB1HWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbXB1HWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 02:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbXB1HWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 02:22:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38188 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXB1HWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 02:22:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<1171844753.5644.174.camel@localhost.localdomain>
	<m1abyzl4yw.fsf@ebiederm.dsl.xmission.com>
	<200702280141.51420.arnd@arndb.de>
Date: Wed, 28 Feb 2007 00:20:34 -0700
In-Reply-To: <200702280141.51420.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 28 Feb 2007 01:41:50 +0100")
Message-ID: <m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

>
> Introducing the irq_request() etc. functions that take a struct irq*
> instead of an int sounds good, but I'd hope we can avoid using those
> in device drivers and do a separate abstraction for each bus_type
> that deals with interrupts. I'm not sure if that's possible for
> each bus_type, but the ones I have worked with in the past should
> allow that:
>
> pci: each device/function has a unique irq, drivers need not know
>      about it afaics.
Then there is msi and with msi-x you can have up to 4K irqs.

> isa/pnp: numbers from 1 to 15 are the right abstraction here, that
>      how isa has worked for ages.

There is some truth there yes.  But for ISA the numbers are really
0 to 15.  

> s390: got rid of irq numbers already

Yes.  I should really look at that more and see if I could bring
s390 into the generic irq code with my planned changes.

> ofw: an open firmware device can have a number of interrupts, but
>      like PCI, the driver only needs to know things like 'first
>      irq of this device', not how it's connected
Yes.

> ps3: irqs are requested from the firmware for each device, this
>      can happen under the covers.
> mmc, usb, phy, ieee1394: these already have a higl-level abstraction
>      for interrupt events
> platform: dunno, probably these really should use the struct irq
>      directly
> eisa, mca, pcmcia, zorro, ...: no idea, but possibly similar to PCI.

Largely for pci we already have dev->irq and the device just calls
request_irq to get things going.  The challenge is that the token
in dev->irq get's looked at.

> Note that we can even start converting device drivers first, before
> moving away from irq numbers. A typical PCI driver should get
> somewhat simpler by the conversion, and when they are all converted,
> we can replace pci_dev->irq with a struct irq* under the covers.

Reasonable if it is easy and straight forward.
Something like pci_request_irq(dev,....) and the helper looks at
dev->irq under the covers and calls request_irq or whatever makes
sense.  Is this what you are thinking.  Examples would help me here.


What I really object to is not the irq numbers.  As an arbitrary number
does not impose limits.  What I object to is drivers that can't handle the
full range of numbers, and the limits imposed upon those numbers when
you require them to be indexes into an array.

For talking to user space I expect we will have numbers for a long time
to come yet.

Eric

