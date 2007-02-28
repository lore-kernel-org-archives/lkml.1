Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbXB1MZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbXB1MZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXB1MZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:25:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbXB1MZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:25:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Date: Wed, 28 Feb 2007 13:24:18 +0100
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com> <200702280141.51420.arnd@arndb.de> <m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281324.19884.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18iSaunVO5j+XkJlrhfrioYBV24RMfvYjo/Nlx
 Hhj9/HDx0yoeuddb3f4PG6cW+UTCTfDHi6yjejXkA216LfQSfh
 j55trm7jNLKDWZ7J3mHNA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 February 2007, Eric W. Biederman wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> >
> > Introducing the irq_request() etc. functions that take a struct irq*
> > instead of an int sounds good, but I'd hope we can avoid using those
> > in device drivers and do a separate abstraction for each bus_type
> > that deals with interrupts. I'm not sure if that's possible for
> > each bus_type, but the ones I have worked with in the past should
> > allow that:
> >
> > pci: each device/function has a unique irq, drivers need not know
> >      about it afaics.
> Then there is msi and with msi-x you can have up to 4K irqs.

I have to admit I still don't really understand how this works
at all. Can a driver that uses msi-x have different handlers
for each of those interrupts registered simultaneously?

I would expect that instead there should be only one 'struct irq'
for the device, with the handler getting a 12 bit number argument.

> > s390: got rid of irq numbers already
> 
> Yes.  I should really look at that more and see if I could bring
> s390 into the generic irq code with my planned changes.

I don't think there is much point in changing the s390 code, but
the way it is solved there may be interesting for other buses
as well. The interrupt handler there is not being registered
explicitly, but is part of the driver (in case of subchannel)
or of the device (in case of ccw_device) data structure.

Similarly, in a pci device, one could imagine that the
struct pci_driver contains a irq_handler_t member that
is registered from the pci_device_probe() function
if present.

> > Note that we can even start converting device drivers first, before
> > moving away from irq numbers. A typical PCI driver should get
> > somewhat simpler by the conversion, and when they are all converted,
> > we can replace pci_dev->irq with a struct irq* under the covers.
> 
> Reasonable if it is easy and straight forward.
> Something like pci_request_irq(dev,....) and the helper looks at
> dev->irq under the covers and calls request_irq or whatever makes
> sense.  Is this what you are thinking.  Examples would help me here.

Ok, I had an example in on of my previous posts, but based on the
discussion since then, it has become significantly simpler, basically
reducing the work to

struct irq *pci_irq_request(struct pci_device *dev,
			    irq_handler_t handler)
{
        if (!dev->irq)
                return -ENODEV;

        return irq_request(irq, handler, IRQF_SHARED,
			  &dev->driver->name, dev);
}
int pci_irq_free(struct pci_device *dev)
{
        return irq_free(dev->irq, dev);
}

The most significant change of this to the current code
would be that we can pass arguments down to irq_request
automatically, e.g. the irq handler can always get the
pci_device as its dev_id.

> For talking to user space I expect we will have numbers for a long time
> to come yet.

I was wondering about that. Do you only mean /proc/interrupts or
are there other user interfaces we need to worry about?
For /proc/interrupts, what could break if we have interrupt numbers
only local to each controller and potentially duplicate numbers
in the list? It's good to be paranoid about changes to proc files,
but I can definitely see value in having meaningful interrupt
numbers in there instead of making up a more or less random mapping
to a flat number space.

	Arnd <><
