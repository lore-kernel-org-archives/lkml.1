Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbXLDMj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbXLDMj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXLDMju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:39:50 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49362 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752944AbXLDMjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:39:49 -0500
Date: Tue, 4 Dec 2007 13:39:47 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Greg Kroah-Hartman <greg@kroah.com>, linuxppc-dev@ozlabs.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
 resources
In-Reply-To: <20071204060911.EA82BDDE19@ozlabs.org>
Message-ID: <Pine.LNX.4.62.0712041337530.12181@pademelon.sonytel.be>
References: <20071204060911.EA82BDDE19@ozlabs.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1571979154-1196771987=:12181"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1571979154-1196771987=:12181
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 4 Dec 2007, Benjamin Herrenschmidt wrote:
> The current pci_assign_unassigned_resources() code doesn't work properly
> on 32 bits platforms with 64 bits resources. The main reason is the use
> of unsigned long in various places instead of resource_size_t.
> 
> This fixes it, along with some tricks to avoid casting to 64 bits on
> platforms that don't need it in every printk around.
> 
> This is a pre-requisite for making powerpc use the generic code instead of
> its own half-useful implementation.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
>  drivers/pci/pci.h       |   11 +++++++++++
>  drivers/pci/setup-bus.c |   32 +++++++++++++++++---------------
>  drivers/pci/setup-res.c |    5 ++---
>  include/linux/pci.h     |    4 ++--
>  4 files changed, 32 insertions(+), 20 deletions(-)
> 
> Index: linux-work/drivers/pci/pci.h
> ===================================================================
> --- linux-work.orig/drivers/pci/pci.h	2007-12-04 17:00:43.000000000 +1100
> +++ linux-work/drivers/pci/pci.h	2007-12-04 17:02:11.000000000 +1100
> @@ -91,3 +91,14 @@ pci_match_one_device(const struct pci_de
>  }
>  
>  struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
> +
> +#ifdef CONFIG_RESOURCES_64BIT
> +#define RESOURCE_ORDER(order)	(1ULL << (order))
> +#define RES_PR			"%016llx"
> +#else
> +#define RESOURCE_ORDER(order)	(1UL << (order))
> +#define RES_PR			"%08lx"
> +#endif
> +
> +#define RANGE_PR		RES_PR "-" RES_PR

Can we please have them in <linux/ioport.h>? They look very useful to me
elsewhere (other bus drivers, device drivers), too.

What about naming the printf format specifier macros more like in C99, e.g.
PRI*?

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1571979154-1196771987=:12181--
