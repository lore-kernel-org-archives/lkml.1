Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbXB1Nyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbXB1Nyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXB1Nys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:54:48 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60616 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbXB1Nyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:54:47 -0500
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
	<200702280141.51420.arnd@arndb.de>
	<m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
	<200702281324.19884.arnd@arndb.de>
Date: Wed, 28 Feb 2007 06:53:51 -0700
In-Reply-To: <200702281324.19884.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 28 Feb 2007 13:24:18 +0100")
Message-ID: <m1649mie1c.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

>
> I have to admit I still don't really understand how this works
> at all. Can a driver that uses msi-x have different handlers
> for each of those interrupts registered simultaneously?

Yes, and the irqs can be routed at different cpus independently.
However not all hardware supports all 4K irqs.  4K is the implementation
defined maximu.  Although infiniband HCA's are rumored to support a
lot of irqs and it isn't uncommon for simpler nics to support 4 or so.

Conceptually think of it as having an irq controller embedded in your
pci device.

The MSI messages are writes to special addresses that are then
converted into CPU interrupts.

> I would expect that instead there should be only one 'struct irq'
> for the device, with the handler getting a 12 bit number argument.

No.  That would be unnecessary coalescing.  Even if that was what the
hardware layer gave us the (and it doesn't) the generic layers should
demux these things as much as is reasonable.


>> > s390: got rid of irq numbers already
>> 
>> Yes.  I should really look at that more and see if I could bring
>> s390 into the generic irq code with my planned changes.
>
> I don't think there is much point in changing the s390 code, but
> the way it is solved there may be interesting for other buses
> as well. The interrupt handler there is not being registered
> explicitly, but is part of the driver (in case of subchannel)
> or of the device (in case of ccw_device) data structure.
>
> Similarly, in a pci device, one could imagine that the
> struct pci_driver contains a irq_handler_t member that
> is registered from the pci_device_probe() function
> if present.

Yes.  There is some potential there.  Although we would have to go
through an extra hoop to make it a pci specific handler type.


>> > Note that we can even start converting device drivers first, before
>> > moving away from irq numbers. A typical PCI driver should get
>> > somewhat simpler by the conversion, and when they are all converted,
>> > we can replace pci_dev->irq with a struct irq* under the covers.
>> 
>> Reasonable if it is easy and straight forward.
>> Something like pci_request_irq(dev,....) and the helper looks at
>> dev->irq under the covers and calls request_irq or whatever makes
>> sense.  Is this what you are thinking.  Examples would help me here.
>
> Ok, I had an example in on of my previous posts, but based on the
> discussion since then, it has become significantly simpler, basically
> reducing the work to
>
> struct irq *pci_irq_request(struct pci_device *dev,
> 			    irq_handler_t handler)
> {
>         if (!dev->irq)
>                 return -ENODEV;
>
>         return irq_request(irq, handler, IRQF_SHARED,
> 			  &dev->driver->name, dev);
> }
> int pci_irq_free(struct pci_device *dev)
> {
>         return irq_free(dev->irq, dev);
> }
>
> The most significant change of this to the current code
> would be that we can pass arguments down to irq_request
> automatically, e.g. the irq handler can always get the
> pci_device as its dev_id.

Yes.  Mostly.  Since dev_id is what is passed back to the irq handler,
it makes sense to pass the device when the irq is registered.
Passing the driver a pointer to the driver specific structure (not
the pci device) make a lot more of sense from an efficiency
standpoint.  Now it may make sense to remove the irq parameter
from irq_handler_t, and require drivers to look at their dev_id to
see which irq they really are processing.

There is a danger here of making things so generic you don't have good
performance, or the code becomes unnecessarily complex.

>> For talking to user space I expect we will have numbers for a long time
>> to come yet.
>
> I was wondering about that. Do you only mean /proc/interrupts or
> are there other user interfaces we need to worry about?

Yes.  There are other interfaces like /proc/irq/XXX/smp_affinity,
for irq migration.  There are also device specific ioctls.  There is
lspci.  I don't know what all else, and given the current state of the
kernel it is hard to grep for.

> For /proc/interrupts, what could break if we have interrupt numbers
> only local to each controller and potentially duplicate numbers
> in the list? It's good to be paranoid about changes to proc files,
> but I can definitely see value in having meaningful interrupt
> numbers in there instead of making up a more or less random mapping
> to a flat number space.

Well I can have meaning full flat numbers and on i386 and x86_64
except for msi I have that.  The problem is that for the numbers
to have meaning I get a very sparse usage of the numbers, because
very frequently the hardware interrupt controllers has pins that
are not connected up, so I have about an order of magnitude more
numbers then I have actually irqs in use.  That is before I start
reserving irq numbers for MSI.

For MSI (since they cannot be shared) it would actually make a lot of
sense to make the numbers domain,bus,device,func,(Nth device irq) but
I can't because bus,device,func is 16bits worth of number.  Add in
12 more bits for the worst case device assignment and I am up to
28 bits, and the rest of the 32bits can be used for domain or
something like that.  So while the current unsigned int irq works fine
for that backing that with a fixed size array allocated at compile
time is just hopeless.

Eric
