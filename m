Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYHPUKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYHPUKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYHPUK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:10:26 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:17119 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYHPUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:10:26 -0400
Date: Sat, 16 Aug 2008 13:10:23 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Message-ID: <20080816201023.GA271@plap4-2.local>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com> <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com> <1218898238.3940.6.camel@localhost.localdomain> <20080816163945.74d487e9@lxorguk.ukuu.org.uk> <1218903209.3940.14.camel@localhost.localdomain> <86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 16 Aug 2008 20:10:24.0986 (UTC) FILETIME=[1E832BA0:01C8FFDC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008, Yinghai Lu wrote:

> On Sat, Aug 16, 2008 at 9:13 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Sat, 2008-08-16 at 16:39 +0100, Alan Cox wrote:
> >> > Where exactly is this code in the kernel?  Most arches assume the irq is
> >> > an index to a compact table bounded by NR_IRQS, so something like this
> >> > would violate that assumption.
> >>
> >> Yes, which is no bad thing for some platforms. There are some driver
> >> assumptions like that but those have also been stomped.
> >
> > I'm not saying we couldn't do this, or even that we shouldn't; I'm just
> > asking why would we want to?
> >
> > All arches currently seem to have show_interrupts() which loop over
> > 0..NR_IRQS where the interrupt is printed as %d.  In this encoded scheme
> > they would show up with rather nastily large numbers that have no
> > visible meaning unless we switch to hex for displaying them.
> >
> > What I'm really saying is that irq as the interrupt number is really the
> > *user's* handle for the interrupt not the machine's, so it needs to be
> > something the user is comfortable with.  We could overcome this
> > objection by encoding the number to something meaningful for the
> > user ... I'm just asking if there's any benefit to doing this?
> >
> the code is tip/irq/sparseirq or tip/master
> 
> story:
> 1. for x86_64: first we have NR_IRQS = NR_CPUS * NR_VECTORS, because
> it already supports per_cpu vector
> 2. SGI want MAX_SMP support: NR_CPUS=4096, so everything is broken.
> 3. Mike spent some time to make every array [NR_CPUS]  to per_cpu
> define as possible.
> 4. Mike or someone else reduce NR_IRQS to 224, because NR=256*4096,
> will make kstat_irqs[NR_CPUS][NR_VECTORS*NR_VECTORS] too big, and it
> could be complied.
> 5. IBM guys report their one server is broken, that system GSI > 256,
> so some irq can not work.
> 6. Yinghai tried one patch change NR_IRQS=32*NR_CPUS., but sgi said it
> still broke their system.  --- for 2.6.27
> 7. Eric provide one patch NR_IRQS = min(32*NR_CPUS, NR_VECTORS *
> MAX_IO_APICS) --- for 2.6.27
> 8. For 2.6.28 later, Yinghai add code dyn_array, and probe nr_irqs, so
> NR_IRQS related will be dynamically allocated after nr_irqs is probed.
> 9. Eric said using dyn_array still waste ram, because a lot of
> irq_desc is not used. when MSI-X is involved, some card could use 256
> vectors or 4096 in theory.
> 10. Eric said he had one dyn irq_desc, with 90% done. but didn't have
> time to work it out left 10%
> 11. Yinghai add sparese_irq support. those array will be increased by
> 32, and be claimed one by one.
> 12. according to Eric, we could have irq spread out [0, -1U), irq =
> bus/dev/fn + entry_of_msix
> 13. with sparseirq, /proc/interrupts will have irq_number in hex.
> 
> but msix current cached irq number, and it only use 16bit to store
> unsigned int irq., and later cards will call request_irq with
> truncated irq_number...card will fallback to MSI or INTa
> 
> only two places need to be changed about that.
> 
> BTW, any reason qlogic card need to cache that irq number second times?

So that the driver can release the two request_irq() allocated
handlers during tear-down (via qla24xx_disable_msix()->free_irq()).
Beyond caching (vector/irq) what's returned during pci_enable_msix(),
is there some other mechanism a driver can use to get the IRQ number?
