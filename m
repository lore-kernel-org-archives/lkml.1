Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYHPOuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYHPOuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 10:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYHPOur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 10:50:47 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51247 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbYHPOuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 10:50:46 -0400
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	 <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 09:50:38 -0500
Message-Id: <1218898238.3940.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 23:42 -0700, Yinghai Lu wrote:
> On Fri, Aug 15, 2008 at 8:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > The 28 bits aren't enough, are they: we need domain as well (and surely we can have more than 16 domains?)
> 
> current code
> static unsigned int build_irq_for_pci_dev(struct pci_dev *dev)
> {
>         unsigned int irq;
> 
>         irq = dev->bus->number;
>         irq <<= 8;
>         irq |= dev->devfn;
>         irq <<= 12;
> 
>         return irq;
> }

Where exactly is this code in the kernel?  Most arches assume the irq is
an index to a compact table bounded by NR_IRQS, so something like this
would violate that assumption.

This is also the reason why it doesn't matter to assign a u32 irq to a
u16 vector.  The u32 irq is a historical thing; it used to be u16 but
then sparc used a vector mapping scheme for the irq number, which I
don't believe it does any more.

> int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
> {
>         unsigned int irq;
>         int ret;
>         unsigned int irq_want;
> 
>         irq_want = build_irq_for_pci_dev(dev) + 0x100;
> 
>         irq = create_irq(irq_want);
> 
> domain is not used yet.
> 
> need to make vecter_irq to vector_domain_irq
> 
> irq_desc(irq) change to domain_irq_desc(domain, irq)

So the assumption underlying this is that the same bus/dev/function on
different domains would share irq space ... that sounds possible but a
bit strange.

James


