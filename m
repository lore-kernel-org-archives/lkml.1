Return-Path: <linux-kernel-owner+w=401wt.eu-S1946083AbXBPTqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946083AbXBPTqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946088AbXBPTqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:46:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63114 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946083AbXBPTqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:46:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Date: Fri, 16 Feb 2007 20:45:58 +0100
User-Agent: KMail/1.9.5
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702162045.58857.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX191rPTYsKksK9WzDqJ9PORU/pWCXM95CUSmBQHXuJ0fsTbuP1WXAcIjWz6FpfRpmqT6UZrRwMrNxRF8U5oWYz6ZXIjxWT/4EREbHuPL6W1IMg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 13:10, Eric W. Biederman wrote:
> To do this I believe will require a s/unsigned int irq/struct irq_desc *irq/
> throughout the entire kernel.  Getting the arch specific code and the
> generic kernel infrastructure fixed and ready for that change looks
> like a pain but pretty doable.

We did something like this a few years back on the s390 architecture, which
happens to be lucky enough not to share any interrupt based drivers with
any of the other architectures.

It helped a lot on s390, and I think the change will be beneficial on others
as well, e.g. powerpc already uses 'virtual' interrupt numbers to collapse
the large (sparse) range of interrupt numbers into 512 unique numbers. This
could easily be avoided if there was simply an array of irq_desc structures
per interrupt controller.

However, I also think we should maintain the old interface, and introduce
a new one to deal only with those cases that benefit from it (MSI, Xen,
powerpc VIO, ...). This means one subsystem can be converted at a time.

I don't think there is a point converting the legacy ISA interrupts to
a different interface, as the concept of IRQ numbers is part of the 
subsystem itself (if you want to call ISA a subsystem...).

For PCI, it makes a lot more sense to use something else, considering
that PCI interrupts are defined as 'pins' instead of 'lines', and
while an interrupt pin is defined per slot, while the line is per
bus, in a system with multiple PCI buses, the line is still not
necessarily unique.

One interface I could imagine for PCI devices would be

/* generic functions */
int request_irq_desc(struct irq_desc *desc, irq_handler_t handler,
		unsigned long irqflags, const char *devname, void *dev_id);
int free_irq_desc(struct irq_desc *desc, void *dev_id);

/* legacy functions */
int request_irq(int irq, irq_handler_t handler,
		unsigned long irqflags, const char *devname, void *dev_id)
{
	return request_irq_desc(lookup_irq_desc(irq), handler, irqflags,
					devname, dev_id);
}
int free_irq(int irq, void *dev_id)
{
	return free_irq_desc(lookup_irq_desc(irq), dev_id);
}

/* pci specific */
struct irq_desc *pci_request_irq(struct pci_device *dev, int pin,
				 irq_handler_t handler)
{
	struct irq_desc *desc = pci_lookup_irq(dev, pin);
	int ret;

	if (!desc)
		return NULL;

	ret = request_irq_desc(desc, handler, IRQF_SHARED,
			&dev->dev.bus_id, dev);
	if (ret < 0)
		return NULL;
	return desc;
}
int pci_free_irq(struct pci_device *dev, int pin)
{
	return free_irq_desc(pci_lookup_irq(dev, pin), dev);
}

Now I don't know enough about MSI yet, but I could imagine
that something along these lines would work as well, and we
could simply require all drivers that want to support MSI
to use the new interfaces.

	Arnd <><
