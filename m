Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZBDSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZBDSSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZBDSR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:17:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZBDSR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:17:57 -0500
Date: Wed, 4 Feb 2009 19:17:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [RFC] [PATCH] PCI mmconfig without ACPI
Message-ID: <20090204181738.GA16174@elte.hu>
References: <1233766786.16414.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233766786.16414.26.camel@localhost.localdomain>
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


* Ed Swierk <eswierk@aristanetworks.com> wrote:

> Make it possible to use memory-mapped PCI configuration space on systems 
> with a supported PCI host bridge without CONFIG_ACPI.
> 
> The acpi_mcfg_allocation struct serves double duty, as a template for 
> parsing the ACPI MCFG table and also to store the mmconfig data, which 
> doesn't necessarily come from ACPI.  Should I leave the struct in 
> acpi/actbl1.h for ACPI parsing, and create a new one for storing mmconfig 
> data?

ok, that's certainly a nice cleanup and restructuring of this code.

A few comments:

>  config PCI_MMCONFIG
>  	def_bool y
> -	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
> +	depends on X86_32 && PCI && (PCI_GOMMCONFIG || PCI_GOANY)

( nice - increasing a PCI feature's reach and decoupling it from hardware 
  enumeration methods such as ACPI is always good news! )

> +#ifdef CONFIG_ACPI
> +
>  static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
>  					      void *data)

An even cleaner approach would be to create a new file: 

arch/x86/pci/mmconfig-acpi.c, and move this block of 5 functions there - and 
add a obj-$(CONFIG_ACPI) rule to arch/x86/pci/Makefile to build it.

The interfacing to arch/x86/pci/mmconfig-shared.c could be simplified too, 
instead of this two-pass thing:

        if (!known_bridge) {
                acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
                pci_mmcfg_reject_broken(early);
        }

a single:

	if (!known_bridge)
		pci_detect_acpi_mmcfg(early);

interface could be used. In the !CONFIG_ACPI case this interface would be an 
inline do-nothing wrapper, in a pci x86 header file:

  static inline void pci_detect_acpi_mmcfg(int early) { }

A few currently local symbols in the file would have to be made explicit and 
moved into the header - but it should be rather straightforward i think.

That way we avoid the ugly #ifdef and clean up the general code structure 
and modularization a bit.

this #ifdef would go away as well:

> +#ifdef CONFIG_ACPI
>  	if (!known_bridge) {
>  		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
>  		pci_mmcfg_reject_broken(early);
>  	}
> +#endif


> +#ifdef CONFIG_PCI_MMCONFIG
> +
> +struct acpi_mcfg_allocation {
> +	u64 address;		/* Base address, processor-relative */
> +	u16 pci_segment;	/* PCI segment group number */
> +	u8 start_bus_number;	/* Starting PCI Bus number */
> +	u8 end_bus_number;	/* Final PCI Bus number */
> +	u32 reserved;
> +};

Please rename this to "struct pci_mcfg_allocation" - there's nothing ACPI 
about it anymore - mmcfg is a PCI feature and ACPI is an enumeration method.

Also, while touching it, please also use the opportunity to align structure 
fields vertically:

 struct pci_mcfg_allocation {
	u64	address;		/* Base address, processor-relative */
	u16	pci_segment;		/* PCI segment group number */
	u8	start_bus_number;	/* Starting PCI Bus number */
	u8	end_bus_number;		/* Final PCI Bus number */
	u32	__reserved;
 };

The whole layout of this structure becomes easier to read and nicer to look 
at as well.

Another small detail: note how i renamed reserved to __reserved - that is a 
standard way to de-emphasise the signficance of a structure field.

The reserved field there is for future expansion and to pad the structure to 
16 bytes - it doesnt really mean much and the underscores move it a bit out 
of the default line of sight.

With a 'reserved' field people end up wondering whether it's perhaps some 
_semantic_ 'reserved area' kind of thing (like for e820 maps, etc.) - so 
it's never bad to make that distinction explicit via the double underscores.

But again, nice patch and it would be nice to see this concept hit mainline.

	Ingo
