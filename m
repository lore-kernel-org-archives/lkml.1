Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZKEOqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZKEOqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZKEOqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:46:39 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:42315 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbZKEOqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:46:39 -0500
Date: Thu, 5 Nov 2009 14:46:41 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
In-Reply-To: <1257375875.4716.24.camel@sbs-t61.sc.intel.com>
Message-ID: <alpine.LFD.2.00.0911051415340.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>  <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>  <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>  <1257301490.2668.280.camel@sbs-t61.sc.intel.com>
 <1257375875.4716.24.camel@sbs-t61.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Suresh Siddha wrote:

> > Maciej, There might be some confusion (mostly on my side). When I looked
> > at ICH2 spec http://www.intel.com/assets/pdf/datasheet/290687.pdf it
> > says it has an EOI register and it is version 2.

 For the record: the original ICH/ICH0 (82801AA/AB) seems to have the 
version set to 0x11 as well.  Now its datasheet mentions the EOI register, 
but even if it is not a mistake, its usefulness is rather limited as the 
APIC does not support FSB delivery.

 Also for the record: the 82489DX is a combined local and I/O APIC chip -- 
quite reasonable given it was intended for 486-class processors which 
needed both units and the cost of manufacturing a separate chip for each 
unit plus the extra PCB space needed in that case certainly outweighed the 
loss from having a part of silicon unused on some chips.

> Ok, Issue is in the specs documentation. ICH2 to ICH5 seems to document
> that they use version 0x2 ioapic's, while infact they use 0x20 version
> and has a working EOI register. So we should use 0x20 as the version
> check and not 0x2.

 I've checked some docs too and you may want to check whether to qualify 
the use of the EOI register further with the DT (Delivery Type) bit in the 
Boot Configuration register.  It affects ICH2 at least (but some I/O APICs 
do this differently; e.g. the PID or 82094AA changes its version between 
0x13 and 0x21 depending on whether FSB delivery is used or not).  
Otherwise you may have interrupts delivered twice (though it may not be a 
big problem after all).

 Note that we have a piece of code to report the existence of the DT bit 
already, so we've got the knowledge about APIC versions already. ;)  I 
guess it should be modified a bit though as reportedly the PID does not 
have the Boot Configuration register, so the version checked there should 
be 0x20 exactly, rather than greater or equal.

 Also you may want to see whether the complication in ack_apic_level() 
that is meant to deal with an APIC erratum really matters for FSB delivery 
-- I guess not, because if you explicitly ACK an interrupt in the I/O 
unit, then even if it was incorrectly recorded as edge-triggered in the 
local unit, the IRR bit will be correctly reset and the next message 
delivered properly.  Given you introduce a conditional statement anyway, 
you can place more code within it and there will be no performance hit for 
the other path and certainly a gain for this one.

 Additionally it seems to me that code to migrate an IRQ is placed 
incorrectly -- the erratum workaround should be placed above it as it 
complements ack_APIC_irq() -- the IRR bit will not have been reset before 
the workaround has been executed if the erratum was hit.  Will you care 
about this problem?

> Maciej, can I have your ack for the appended patch?

 Certainly, it looks good to me.

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

> ---
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86, ioapic: fix io-apic version check for the EOI reg presence
> 
> Maciej W. Rozycki reported:
> > 82093AA I/O APIC has its version set to 0x11 and it 
> > does not support the EOI register.  Similarly I/O APICs integrated into 
> > the 82379AB south bridge and the 82374EB/SB EISA component.
> 
> IO-APIC versions below 0x20 don't support EOI register.
> 
> Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
> version as 0x2. This is an error with documentation and these ICH chips
> use io-apic's of version 0x20 and indeed has a working EOI register
> for the io-apic.
> 
> Fix the ioapic_supports_eoi() to check for version 0x20 and beyond.
> 
> Reported-by: Maciej W. Rozycki <macro@linux-mips.org>
> Acked-by: Rajesh Sankaran <rajesh.sankaran@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 47d95c3..68510d4 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2520,13 +2520,29 @@ static void eoi_ioapic_irq(struct irq_desc *desc)
>  	spin_unlock_irqrestore(&ioapic_lock, flags);
>  }
>  
> +/*
> + * IO-APIC versions below 0x20 don't support EOI register.
> + * For the record, here is the information about various versions:
> + * 	0Xh	82489DX
> + * 	1Xh	I/OAPIC or I/O(x)APIC which are not PCI 2.2 Compliant
> + * 	2Xh     I/O(x)APIC which is PCI 2.2 Compliant
> + *	30h-FFh Reserved
> + *
> + * Some of the Intel ICH Specs (ICH2 to ICH5) documents the io-apic
> + * version as 0x2. This is an error with documentation and these ICH chips
> + * use io-apic's of version 0x20.
> + */
>  static int ioapic_supports_eoi(void)
>  {
>  	struct pci_dev *root;
>  
>  	root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
> +	/*
> + 	 * Perhaps we can do this for all vendors. But for now,
> + 	 * no one else seems to have version >= 0x20 ??
> + 	 */
>  	if (root && root->vendor == PCI_VENDOR_ID_INTEL &&
> -	    mp_ioapics[0].apicver >= 0x2) {
> +	    mp_ioapics[0].apicver >= 0x20) {
>  		use_eoi_reg = 1;
>  		printk(KERN_INFO "IO-APIC supports EOI register\n");
>  	} else
> 
> 
