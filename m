Return-Path: <linux-kernel-owner+w=401wt.eu-S1946224AbXBPU7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946224AbXBPU7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946208AbXBPU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:59:55 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4457 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946059AbXBPU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:59:53 -0500
Date: Fri, 16 Feb 2007 20:59:42 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Message-ID: <20070216205942.GG2572@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com> <200702162045.58857.arnd@arndb.de> <20070216195256.GE2572@flint.arm.linux.org.uk> <200702162143.25130.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702162143.25130.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 09:43:24PM +0100, Arnd Bergmann wrote:
> On Friday 16 February 2007 20:52, Russell King wrote:
> > On Fri, Feb 16, 2007 at 08:45:58PM +0100, Arnd Bergmann wrote:
> > > We did something like this a few years back on the s390 architecture, which
> > > happens to be lucky enough not to share any interrupt based drivers with
> > > any of the other architectures.
> > 
> > What you're proposing is looking similar to a proposal I put forward some
> > 4 years ago, but was rejected.  Maybe times have changed and there's a
> > need for it now.
> 
> Yes, I think times have changed, with the increased popularity of MSI
> and paravirtualized devices. A few points on your old proposal though:
> 
> - Doing it per architecture no longer sounds feasible, I think it would
>   need to be done per subsystem so that the drivers can be adapted to
>   a new interface, and most drivers are used across multiple architectures.
> - struct irq sounds much more fitting than struct irq_desc
> - creating new irq_foo() functions to replace foo_irq() also sounds right.
> - doing subsystem specific abstractions ideally allows the drivers to
>   not even need to worry about the irq pointer, significantly simplifying
>   the interface for register/unregister.

I agree with your points above, except for:

> - I don't see the point in splitting request_irq into irq_request and
>   irq_register.

This was to work around those scenarios where you want to mark an IRQ
resource as being in use prior to actually using it in much the same
way as is done with IO ports.

I've come across hardware where you need to claim the interrupt with
the controller masked, configure the device generating the interrupt
appropriately, and only then unmask it.  Otherwise you end up spinning.

To work around that, we've had to introduce additional flags into the
genirq subsystem - IRQF_NOAUTOEN - whereas separating the "obtain"
from the "start using" bit of request_irq would've made this
unnecessary.

Another example where this (was|still is) used is the IDE code, but
that's probably been cleaned up in some way now.

There's nothing wrong with keeping a combined "request_irq" for the
common case though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
