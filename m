Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYBHU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYBHU4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYBHU4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:56:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41746 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbYBHU4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:56:00 -0500
Date: Fri, 8 Feb 2008 21:56:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Barry Kasindorf <barry.kasindorf@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] AMD Family10h IBS support for oProfile driver
Message-ID: <20080208205605.GH31984@uranus.ravnborg.org>
References: <47ACB578.9090506@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACB578.9090506@amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> ---
>  kernel/apic_64.c           |    1
>  oprofile/op_model_athlon.c |  245 
>  ++++++++++++++++++++++++++++++++++++++++++++-
>  oprofile/op_x86_model.h    |   37 ++++++
>  3 files changed, 281 insertions(+), 2 deletions(-)
> diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
> index 1e417df..7dbe8b0 100644
> --- a/arch/x86/kernel/apic_32.c
> +++ b/arch/x86/kernel/apic_32.c
> @@ -224,6 +224,30 @@ static void __setup_APIC_LVTT(unsigned int clocks, int 
> oneshot, int irqen)
>  	if (!oneshot)
>  		apic_write_around(APIC_TMICT, clocks/APIC_DIVISOR);
>  }
> +#define APIC_EILVT_LVTOFF_MCE 0
> +#define APIC_EILVT_LVTOFF_IBS 1
> +
> +static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
> +{
> +	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
> +	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
> +
> +	apic_write(reg, v);
> +}
> +
> +u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
> +{
> +	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
> +	return APIC_EILVT_LVTOFF_MCE;
> +}
There are no users of this global symbol - can we kill it?

> +
> +u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
> +{
> +	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
> +	return APIC_EILVT_LVTOFF_IBS;
> +}
> +EXPORT_SYMBOL(setup_APIC_eilvt_ibs);

Please document all new EXPORT_SYMBOLS with kernel-doc comments.
GPL export?

> +
> 
>  /*
>   * Program the next event, relative to now
> diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
> index 286a396..bced2a6 100644
> --- a/arch/x86/kernel/apic_64.c
> +++ b/arch/x86/kernel/apic_64.c
> @@ -219,6 +219,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
>  	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
>  	return APIC_EILVT_LVTOFF_IBS;
>  }
> +EXPORT_SYMBOL(setup_APIC_eilvt_ibs);

Is this new export properly documented?

> +++ b/arch/x86/oprofile/op_model_athlon.c
> @@ -8,9 +8,13 @@
>   * @author John Levon
>   * @author Philippe Elie
>   * @author Graydon Hoare
> - */
> + * @author Barry Kasindorf
> +*/
> 
>  #include <linux/oprofile.h>
> +#include <linux/device.h>
> +#include <linux/pci.h>

Alphabetic order is preferred.

> +
>  #include <asm/ptrace.h>
>  #include <asm/msr.h>
>  #include <asm/nmi.h>
> @@ -42,8 +46,69 @@
>  #define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
>  #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
> 
> +/* high dword IbsFetchCtl[bit 49] */
> +#define IBS_FETCH_VALID_BIT		0x00020000
Then define it as (1 << 49) ?

> + * Add an AMD IBS  sample. This may be called from any context. Pass
> + * smp_processor_id() as cpu. Passes IBS registers as a unsigned int[8]
> + */
> +void oprofile_add_ibs_op_sample(struct pt_regs * const regs,
> +				unsigned int * const ibs_op);
> +
> +void oprofile_add_ibs_fetch_sample(struct pt_regs * const regs,
> +				unsigned int * const ibs_fetch);
> +
These prototypes looks like they belong in a .h file.
Did sparse accept them?

>  static unsigned long reset_value[NUM_COUNTERS];
> -
> +extern int ibs_allowed;		/* AMD Family 10h+ */
This extern certainly does belong in a .h file.

> 
> +/*
> + *	Enable AMD extended PCI config space thru IO
> + *	save previous state
> + */
> +static void
> +	Enable_Extended_PCI_Config(void)
> +{
AnySpecificReasonForPascalCasing?
And keep function definotion on one line.

> +	unsigned int low, high;
> +	rdmsr(NB_CFG_MSR, low, high);
> +	Extended_PCI_Enabled = high  & ENABLE_CF8_EXT_CFG_MASK;
> +	high |= ENABLE_CF8_EXT_CFG_MASK;
> +	wrmsr(NB_CFG_MSR, low, high);
> +}
> +
> +/*
> + *	Disable AMD extended PCI config space thru IO
> + *	restore to previous state
> + */
> +static void
> +	Disable_Extended_PCI_Config(void)
A_New_Style_For_Naming???
> +{
> +	unsigned int low, high;
> +	rdmsr(NB_CFG_MSR, low, high);
> +	high &= ~ENABLE_CF8_EXT_CFG_MASK;
> +	high |= Extended_PCI_Enabled;
> +	wrmsr(NB_CFG_MSR, low, high);
> +}
> +/*
> + * Modified to use AMD extended PCI config space thru IO
> + * these 2 I/Os should be atomic but there is no easy way to do that.
> + * Should use the MMio version, will when it is fixed
> + */
> +
> +static void
> +	PCI_Extended_Write(struct pci_dev *dev, unsigned int offset,
> +						 unsigned long val)
Again.

> +
> +		/**** Be sure to run loop until NULL is returned to
> +		decrement reference count on any pci_dev structures returned 
> ****/

USe kernel style:
/*
 * Bla
 */
And resubmit without line wraps.

