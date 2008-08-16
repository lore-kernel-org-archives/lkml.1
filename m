Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYHPU0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYHPU0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHPUZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:25:51 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35945 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347AbYHPUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:25:50 -0400
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	 <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	 <1218898238.3940.6.camel@localhost.localdomain>
	 <20080816163945.74d487e9@lxorguk.ukuu.org.uk>
	 <1218903209.3940.14.camel@localhost.localdomain>
	 <86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 15:25:41 -0500
Message-Id: <1218918341.3940.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 11:56 -0700, Yinghai Lu wrote:
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

OK, that's either a quilt or a specifier for a git head ...
unfortunately linux-next doesn't give you those, so I'd need either a
commit id or a pointer to the base tree or quilt for that to make sense.

> story:
> 1. for x86_64: first we have NR_IRQS = NR_CPUS * NR_VECTORS, because
> it already supports per_cpu vector

Hmm ... the first thing that springs to mind is are you sure?  We have
architectures (like voyager and parisc) that always had these per cpu
vector type interrupts.  On each of them we actually factored the CPU
affinity out of the irq number for sound reasons (although the per CPU
vectors still exist):  The user understands better that irq line 50 is
currently going to CPU1 and that they could change it to CPU2 (or just
use irqbalance).  Combining the affinity into the irq number looks like
a bad idea because users won't be able to parse it correctly.

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

OK, sorry, I get that there's a bug in the msix_entry ... if it's going
to assign an irq to it, it should at least be the same type as irq.

What I still don't quite get is the benefit of large IRQ spaces ...
particularly if you encode things the system doesn't really need to know
in them. 

> only two places need to be changed about that.
> 
> BTW, any reason qlogic card need to cache that irq number second times?
> 
> YH
> 
> 
> system with qlogic and lpfc

Yes, but if these are all single CPU bound, the matrix display doesn't
really make sense any more, does it?

James


> LBSuse:~ # cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
>       CPU6       CPU7       CPU8       CPU9       CPU10      CPU11
>  CPU12      CPU13      CPU14      CPU15
> 0x0:        111          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   IO-APIC-edge      timer
> 0x4:        450          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   IO-APIC-edge      serial
> 0x7:          1          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   IO-APIC-edge
> 0x8:          1          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   IO-APIC-edge      rtc0
> 0x9:          0          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   IO-APIC-fasteoi   acpi
> 0x17:          0          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi   sata_nv
> 0x16:        140          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi
> ohci_hcd:usb2, sata_nv
> 0x15:        384          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi
> ehci_hcd:usb1
> 0x14:          0          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi   sata_nv
> 0x10:       1083          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi   aacraid
> 0x2e:          0          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi   sata_nv
> 0x2d:          0          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi   sata_nv
> 0x2c:          0          0          0          0          0
> 0          0          0          0          0          0          0
>       0          0          0          0   IO-APIC-fasteoi   sata_nv
> 0x50100:          0          0          0          0          0
>   0          0          0          0          0          0          0
>         0          0          0          0   PCI-MSI-edge      aerdrv
> 0x70100:          0          0          0          0          0
>   0          0          0          0          0          0          0
>         0          0          0          0   PCI-MSI-edge      aerdrv
> 0x78100:          0          0          0          0          0
>   0          0          0          0          0          0          0
>         0          0          0          0   PCI-MSI-edge      aerdrv
> 0x8058100:          0          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge
> aerdrv
> 0x8070100:          0          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge
> aerdrv
> 0x8078100:          0          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge
> aerdrv
> 0x8300100:         41          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge
> qla2xxx (default)
> 0x83000ff:          0          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge
> qla2xxx (rsp_q)
> 0x8301100:         41          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge
> qla2xxx (default)
> 0x83010ff:          0          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge
> qla2xxx (rsp_q)
> 0x300100:          2          0          0          0          0
>    0          0          0          0          0          0          0
>          0          0          0          0   PCI-MSI-edge      lpfc
> 0x301100:          2          0          0          0          0
>    0          0          0          0          0          0          0
>          0          0          0          0   PCI-MSI-edge      lpfc
> 0x40100:        326          0          0          0          0
>   0          0          0          0          0          0          0
>         0          0          0          0      none-edge
> 0x48100:        328          0          0          0          0
>   0          0          0          0          0          0          0
>         0          0          0          0      none-edge
> 0x8040100:       2222          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0   PCI-MSI-edge      eth2
> 0x8048100:        326          0          0          0          0
>     0          0          0          0          0          0
> 0          0          0          0          0      none-edge
> NMI:          0          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   Non-maskable interrupts
> LOC:       8782       5209       3029       3222       4556       3328
>       2862       2782       2730       3218       2742       2655
>  3664       3099       3146       3356   Local timer interrupts
> RES:        904       2930         98         65       1083       3723
>        158         84         46       1899        157         60
>  2476        971        114         97   Rescheduling interrupts
> CAL:         12         89         71         65         65        142
>         77         66         65        118         77         67
>    66        106         72         67   function call interrupts
> TLB:          7         90         18          5          3        115
>         16         10          3        123         19          5
>     2        157         18          3   TLB shootdowns
> TRM:          0          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   Threshold APIC interrupts
> SPU:          0          0          0          0          0          0
>          0          0          0          0          0          0
>     0          0          0          0   Spurious interrupts
> ERR:          1
> 
> system with neptune:
> LBSuse:~ # cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
>       CPU6       CPU7
> 0x0:         92          0          0          0          0          0
>          0          1   IO-APIC-edge      timer
> 0x4:          0          0          0          0          0          0
>          1        532   IO-APIC-edge      serial
> 0x7:          1          0          0          0          0          0
>          0          0   IO-APIC-edge
> 0x8:          0          0          0          0          0          0
>          0          1   IO-APIC-edge      rtc0
> 0x9:          0          0          0          0          0          0
>          0          0   IO-APIC-fasteoi   acpi
> 0x17:          0          0          0          0          0
> 0          0          0   IO-APIC-fasteoi   sata_nv
> 0x16:          0          0          0          0          0
> 0          2        105   IO-APIC-fasteoi   ohci_hcd:usb2
> 0x15:          0          0          0          0          0
> 0          0       1014   IO-APIC-fasteoi   ehci_hcd:usb1
> 0x14:          0          0          0          0          0
> 0          0          1   IO-APIC-fasteoi   sata_nv, sata_nv
> 0x2e:          0          0          0          0          0
> 0          0          0   IO-APIC-fasteoi   sata_nv
> 0x2d:          0          0          0          0          0
> 0          0          0   IO-APIC-fasteoi   sata_nv
> 0x2c:          0          0          0          0          0
> 0          0          0   IO-APIC-fasteoi   sata_nv
> 0x50100:          0          0          0          0          0
>   0          0          0   PCI-MSI-edge      aerdrv
> 0x70100:          0          0          0          0          0
>   0          0          0   PCI-MSI-edge      aerdrv
> 0x78100:          0          0          0          0          0
>   0          0          0   PCI-MSI-edge      aerdrv
> 0x8058100:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      aerdrv
> 0x8070100:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      aerdrv
> 0x8078100:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      aerdrv
> 0x8301100:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010ff:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010fe:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010fd:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010fc:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010fb:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010fa:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f9:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f8:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f7:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f6:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f5:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f4:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f3:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f2:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f1:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010f0:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010ef:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010ee:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010ed:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x83010ec:          0          0          0          0          0
>     0          0          0   PCI-MSI-edge      eth5
> 0x40100:          0          0          0          0          0
>   0          9       5352   PCI-MSI-edge      eth0
> 0x48100:          0          0          0          0          0
>   0          4        148      none-edge
> 0x8040100:          0          0          0        154          0
>     0          0          0      none-edge
> 0x8048100:          0          0          0        154          0
>     0          0          0      none-edge
> NMI:          0          0          0          0          0          0
>          0          0   Non-maskable interrupts
> LOC:       4780       4021       2441       2831       3978       3672
>       2576       4601   Local timer interrupts
> RES:        647       4295        485        282       1324       3561
>        620       1902   Rescheduling interrupts
> CAL:         18         92         53         44         33         53
>         47         39   function call interrupts
> TLB:         23        176         65         41         48        274
>         95         62   TLB shootdowns
> TRM:          0          0          0          0          0          0
>          0          0   Thermal event interrupts
> THR:          0          0          0          0          0          0
>          0          0   Threshold APIC interrupts
> SPU:          0          0          0          0          0          0
>          0          0   Spurious interrupts
> ERR:          1

