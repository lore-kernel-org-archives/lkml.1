Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbZCaTi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbZCaTi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbZCaTil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:38:41 -0400
Received: from gw.goop.org ([64.81.55.164]:56469 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763365AbZCaTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:38:40 -0400
Message-ID: <49D2713D.6090401@goop.org>
Date: Tue, 31 Mar 2009 12:38:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen for 2.6.30 #2
References: <49D1209A.9000800@goop.org> <49D25A42.7060300@goop.org> <20090331185541.GA17807@elte.hu>
In-Reply-To: <20090331185541.GA17807@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>   - review it in detail
>  1- then after a round of review feedbacks merge it into the x86 tree
>   - then to test it there
>   - then to fix the (inevitable) bugs and go to 1 until bug-free
>   - then to stage it to linux-next
>   - then after many weeks and months, to eventually send it to Linus
>
> That's NOT the same thing as you sending it straight to Linus, 
> without the broad acks from the x86 maintainers for all details.
>   

I sent mail to you about this several days ago, announcing my intention 
to post if I didn't hear back from you.   I heard nothing and went ahead.

I've been working with HPA to get him to review all the x86 
interactions, and reviewed-by the patches accordingly.  I have sent you 
these patches several times over the last month, but haven't seen any 
response.

> I had a quick look, and stuff like this is not acceptable:
>
>  static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
>  {
> -       struct io_apic __iomem *io_apic = io_apic_base(apic);
> +       struct io_apic __iomem *io_apic;
> +
> +       if (xen_initial_domain())
> +               return xen_io_apic_read(apic, reg);
> +
> +       io_apic = io_apic_base(apic);
>
> Should be done by introducing your own xen specific irqchip. And 
> this is not news to you, it has been told you in _early February_:
>
>   http://lkml.indiana.edu/hypermail/linux/kernel/0902.1/00410.html
>
> You didnt reply to that feedback of mine and you didnt fix it.
>   

Yes, you've suggested that several times; that particular mail was about 
a different issue, for which it also wasn't the answer.  (I didn't reply 
because shortly after you sent me with another mail saying "Ok, never 
mind my comment on the do_IRQ() detail, this looks good after all[...]")

We *do* define our own irqchip (drivers/xen/events.c), but that 
interface doesn't cover IO apic interactions, which are primarily used 
when doing apic setup, and to set up interrupt routing. 
ioapic_write_entry(), for example, is not reached via any irq_chip method.

In this case we want the normal apic setup to go ahead, but the actual 
read/writes to the apic registers need to be directed to a hypercall.

> We are not putting some xen-specific hack into core x86 code ... The 
> irqchip method wont put overhead and ugliness into native Linux. 
> It's an existing abstraction for such stuff, use it and extend it if 
> needed.
>   
No, it isn't, because it doesn't encapsulate the whole apic layer.  I 
don't want to duplicate all that code; I want to use it (mostly) as-is.

I went around this several times with HPA.  My initial version of the 
patch introduced an io_apic_ops and hooked it appropriately.  He 
objected on the grounds that its pointless adding an extra level of 
abstraction for a single user; he preferred a straightforward call, as 
it is here.  This change is Xen-specific, but it disappears completely 
if you don't enable Xen and it is not on a performance-critical path.  
If any other users appear here, we can easily add an appropriate 
abstraction layer.

> And stuff like this in arch/x86/kernel/pci-swiotlb.c:
>
>   dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
>   {
>  +#ifdef CONFIG_PCI_XEN
>  +       if (xen_pv_domain())
>  +               return xen_phys_to_bus(paddr);
>  +#endif
>          return paddr;
>   }
>
> and the other PCI bits very much need the ack of the PCI and 
> sw-IOMMU folks (Fujita Tomonori mainly). I'd be surprised if they 
> werent disgusted by it.
>   

I believe they've been cc:ed on all these patches, but I'll repost the 
relevent bits to make sure.  The #ifdef definitely should not be there.

> I dont mind pull requests outside of maintenance boundaries, as long 
> as the changes are good.
>   

Well, I've been trying to get your comments about these patches for at 
least a month now, with the intention of hitting this merge window.  I 
realize you're very busy overall, so when HPA took the time to review 
them I didn't see the need to also press it with you.  And I certainly 
wasn't going to let the window go by without doing anything.

> You know our stance which is very simple: dont put in Xen-only hooks 
> that slow down native, and get rid of the existing Xen-only hooks.
>   

Yes, I understand that.  Unlike the pvops stuff, the dom0 changes are 
largely all init-time and setup, and so have no performance impact. 

    J
