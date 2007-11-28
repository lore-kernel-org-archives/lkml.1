Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbXK1HLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbXK1HLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 02:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbXK1HLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 02:11:15 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35930 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbXK1HLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 02:11:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Len Brown <lenb@kernel.org>
Cc: "Natalie Protasevich" <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
References: <200711280121.18376.lenb@kernel.org>
Date: Wed, 28 Nov 2007 00:09:15 -0700
In-Reply-To: <200711280121.18376.lenb@kernel.org> (Len Brown's message of
	"Wed, 28 Nov 2007 01:21:18 -0500")
Message-ID: <m1mysyg82s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

>     commit c434b7a6aedfe428ad17cd61b21b125a7b7a29ce
>     (x86: avoid wasting IRQs for PCI devices)
>     created a concept of "IRQ compression" on i386
>     to conserve IRQ numbers on systems with many
>     sparsely populated IO APICs.
>     
>     The same scheme was also added to x86_64,
>     but later removed when x86_64 recieved an IRQ over-haul
>     that made it unnecessary -- including per-CPU
>     IRQ vectors that greatly increased the IRQ capacity
>     on the machine.
>     
>     i386 has not received the analogous over-haul,
>     and thus a previous attempt to delete IRQ compression
>     from i386 was rejected on the theory that there may
>     exist machines that actually need it.  The fact is
>     that the author of IRQ compression patch was unable
>     to confirm the actual existence of such a system.
>     
>     As a result, all i386 kernels with IOAPIC support
>     pay the following:
>     
>     1. confusion
>     
>     IRQ compression re-names the traditional IOAPIC
>     pin numbers (aka ACPI GSI's) into sequential IRQ #s:
>     
>     ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 16
>     ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 17
>     ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 18
>     ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 19
>     ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 20 (level, low) -> IRQ 16
>     
>     This makes /proc/interrupts look different
>     depending on system configuration and device probe order.
>     It is also different than the x86_64 kernel running
>     on the exact same system.  As a result, programmers
>     get confused when comparing systems.
>     
>     2. complexity
>     
>     The IRQ code in Linux is already overly complex,
>     and IRQ compression makes it worse.  There have
>     already been two bug workarounds related to IRQ
>     compression -- the IRQ0 timer workaround and
>     the VIA PCI IRQ workaround.
>     
>     3. size
>     
>     All i386 kernels with IOAPIC support contain an int[4096] --
>     a 4 page array to contain the renamed IRQs.
>     
>     So while the irq compression code on i386 should really
>     be deleted -- even before merging the x86_64 irq-overhaul,
>     this patch simply disables it on all high volume systems
>     to avoid problems #1 and #2 on most all i386 systems.
>     
>     A large system with pin numbers >=64 will still have compression
>     to conserve limited IRQ numbers for sparse IOAPICS.  However,
>     the vast majority of the planet, those with only pin numbers < 64
>     will use an identity GSI -> IRQ mapping.
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>

Looks reasonable.  As a further cleanup it might be worth yanking the
Via workaround because we simply can not hit it with your change of
disabling irq compression for the first 64 gsis.

I honestly don't understand the "(gsi == 0 && !timer_uses_ioapic_pin_0)"
test but I do know killing irq compression was safe and worked on
x86_64 so I don't expect any problems there.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>




> diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
> index 7a05a7f..468d6ed 100644
> --- a/arch/x86/kernel/mpparse_32.c
> +++ b/arch/x86/kernel/mpparse_32.c
> @@ -1041,13 +1041,14 @@ void __init mp_config_acpi_legacy_irqs (void)
>  }
>  
>  #define MAX_GSI_NUM	4096
> +#define IRQ_COMPRESSION_START	64
>  
>  int mp_register_gsi(u32 gsi, int triggering, int polarity)
>  {
>  	int ioapic = -1;
>  	int ioapic_pin = 0;
>  	int idx, bit = 0;
> -	static int pci_irq = 16;
> +	static int pci_irq = IRQ_COMPRESSION_START;
>  	/*
>  	 * Mapping between Global System Interrups, which
>  	 * represent all possible interrupts, and IRQs
> @@ -1086,12 +1087,16 @@ int mp_register_gsi(u32 gsi, int triggering, int
> polarity)
>  	if ((1<<bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
>  		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
>  			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
> -		return gsi_to_irq[gsi];
> +		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
>  	}
>  
>  	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1<<bit);
>  
> -	if (triggering == ACPI_LEVEL_SENSITIVE) {
> +	/*
> +	 * For GSI >= 64, use IRQ compression
> +	 */
> +	if ((gsi >= IRQ_COMPRESSION_START)
> +		&& (triggering == ACPI_LEVEL_SENSITIVE)) {
>  		/*
>  		 * For PCI devices assign IRQs in order, avoiding gaps
>  		 * due to unused I/O APIC pins.
