Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZCaS5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZCaS5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 14:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZCaS4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 14:56:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZCaS4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 14:56:47 -0400
Date: Tue, 31 Mar 2009 20:55:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] Xen for 2.6.30 #2
Message-ID: <20090331185541.GA17807@elte.hu>
References: <49D1209A.9000800@goop.org> <49D25A42.7060300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D25A42.7060300@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Linus,
>
> This is the second (and final) set of Xen updates for 2.6.30.  
> This set contains Xen dom0 support, which includes:
>
>    * adding to the existing Xen support to allow running as a
>      privileged domain
>    * some hooks into the apic setup code to allow Xen interrupts to get
>      routed properly
>    * a Xen implementation of the DMA ops API
>    * a Xen MTRR driver
>    * other misc things
>
> These changes only hook into init/setup code, and will have no 
> runtime performance impact on native execution when 
> CONFIG_PARAVIRT is enabled, and are completely compiled out 
> without it.
>
> These changes are more or less unchanged since their first posting 
> about 3-4 weeks ago.  The x86 parts have been reviewed (mainly by 
> HPA) and considered not too objectionable.

This stuff is still on my list of things to look at.

AFAIK hpa had a look and found it not too objectionable, but didnt 
ack it, which means the green lights to:

  - review it in detail
 1- then after a round of review feedbacks merge it into the x86 tree
  - then to test it there
  - then to fix the (inevitable) bugs and go to 1 until bug-free
  - then to stage it to linux-next
  - then after many weeks and months, to eventually send it to Linus

That's NOT the same thing as you sending it straight to Linus, 
without the broad acks from the x86 maintainers for all details.

I had a quick look, and stuff like this is not acceptable:

 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
-       struct io_apic __iomem *io_apic = io_apic_base(apic);
+       struct io_apic __iomem *io_apic;
+
+       if (xen_initial_domain())
+               return xen_io_apic_read(apic, reg);
+
+       io_apic = io_apic_base(apic);

Should be done by introducing your own xen specific irqchip. And 
this is not news to you, it has been told you in _early February_:

  http://lkml.indiana.edu/hypermail/linux/kernel/0902.1/00410.html

You didnt reply to that feedback of mine and you didnt fix it.

We are not putting some xen-specific hack into core x86 code ... The 
irqchip method wont put overhead and ugliness into native Linux. 
It's an existing abstraction for such stuff, use it and extend it if 
needed.

And stuff like this in arch/x86/kernel/pci-swiotlb.c:

  dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
  {
 +#ifdef CONFIG_PCI_XEN
 +       if (xen_pv_domain())
 +               return xen_phys_to_bus(paddr);
 +#endif
         return paddr;
  }

and the other PCI bits very much need the ack of the PCI and 
sw-IOMMU folks (Fujita Tomonori mainly). I'd be surprised if they 
werent disgusted by it.

I dont mind pull requests outside of maintenance boundaries, as long 
as the changes are good.

You know our stance which is very simple: dont put in Xen-only hooks 
that slow down native, and get rid of the existing Xen-only hooks.

	Ingo
