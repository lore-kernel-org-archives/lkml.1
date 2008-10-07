Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbYJGU1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbYJGU1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYJGU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:27:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33695 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbYJGU1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:27:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC
Date: Tue, 7 Oct 2008 22:31:23 +0200
User-Agent: KMail/1.9.9
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
References: <20081005183603.GA3263@amd.corenet.prv> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006221122.GC22097@alberich.amd.com>
In-Reply-To: <20081006221122.GC22097@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810072231.29891.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 of October 2008, Andreas Herrmann wrote:
> On Mon, Oct 06, 2008 at 10:39:25PM +0100, Maciej W. Rozycki wrote:
> > On Mon, 6 Oct 2008, Andi Kleen wrote:
> > 
> > > The real reason is actually a workaround in the BIOS for problems
> > > in the older Linux code that caused duplicated timer interrupts. The
> > > old Linux would fall into "enable both IO-APIC and 8259" fallback mode
> > > and the resulted in duplicated timer events, which made everything unhappy.
> > > They instead configured the northbridge in a way that one of the inputs
> > > is ignored.
> > 
> >  Hmm, working around Linux problems in the BIOS is a new and truly odd 
> > concept to me.  It's not that we are unresponsive or do not take 
> > responsibility for our bugs, is it?
> 
> So, let's work around BIOS bugs in Linux then ...
> 
> Following patch is almost untested -- especially I didn't get my
> hands on one of the HP Laptops with broken DSDT.

The patch works on my nx6325.  I removed the DMI workarouds for this test, so
I'm quite sure. :-)

You can add my Tested-by to it too.

Thanks,
Rafael

 
> --
> 
> On some HP nx6... laptops (e.g. nx6325) BIOS reports an IRQ0 override
> but the SB450 chipset is configured such that timer interrupts goe to
> INT0 of IOAPIC.
> 
> Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the
> timer override.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/early-quirks.c |   48 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 4353cf5..6b839b1 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -95,6 +95,52 @@ static void __init nvidia_bugs(int num, int slot, int func)
>  
>  }
>  
> +static u32 ati_ixp4x0_rev(int num, int slot, int func)
> +{
> +	u32 d;
> +	u8  b;
> +
> +	b = read_pci_config_byte(num, slot, func, 0xac);
> +	b &= ~(1<<5);
> +	write_pci_config_byte(num, slot, func, 0xac, b);
> +
> +	d = read_pci_config(num, slot, func, 0x70);
> +	d |= 1<<8;
> +	write_pci_config(num, slot, func, 0x70, d);
> +
> +	d = read_pci_config(num, slot, func, 0x8);
> +	d &= 0xff;
> +	return d;
> +}
> +
> +static void __init ati_bugs(int num, int slot, int func)
> +{
> +#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
> +	u32 d;
> +	u8  b;
> +
> +	if (acpi_use_timer_override)
> +		return;
> +
> +	d = ati_ixp4x0_rev(num, slot, func);
> +	if (d  < 0x82)
> +		acpi_skip_timer_override = 1;
> +	else {
> +		/* check for IRQ0 interrupt swap */
> +		outb(0x72, 0xcd6); b = inb(0xcd7);
> +		if (!(b & 0x2))
> +			acpi_skip_timer_override = 1;
> +	}
> +
> +	if (acpi_skip_timer_override) {
> +		printk(KERN_INFO "SB4X0 revision 0x%x\n", d);
> +		printk(KERN_INFO "Ignoring ACPI timer override.\n");
> +		printk(KERN_INFO "If you got timer trouble "
> +		       "try acpi_use_timer_override\n");
> +	}
> +#endif
> +}
> +
>  #define QFLAG_APPLY_ONCE 	0x1
>  #define QFLAG_APPLIED		0x2
>  #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> @@ -114,6 +160,8 @@ static struct chipset early_qrk[] __initdata = {
>  	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
>  	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
>  	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
> +	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
> +	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
>  	{}
>  };
>  


