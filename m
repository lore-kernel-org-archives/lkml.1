Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXDFN5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXDFN5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767648AbXDFN5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:57:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43795 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932750AbXDFN5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:57:54 -0400
Date: Wed, 4 Apr 2007 10:13:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bernhard Kaindl <bk@suse.de>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/4] Fix MTRR suspend support for specific machines (some AMD64, maybe others also)
Message-ID: <20070404081321.GD8256@elf.ucw.cz>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr> <200703272213.51947.ak@suse.de> <Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr> <200703291525.59116.ak@suse.de> <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> With at least 3 of the following 4 patches, s2ram and s2disk are
> fixed on at least the Acer Ferrari 1000 notebooks and at least
> s2disk on the Acer Ferrari 5000 notebooks.
> 
> The Acer Ferrari 1000 is a 12" Turion 64 X2 notebook with only 1.7 kg weight
> while the Ferrari 5000 is a 14" AMD Turion notebook and a bit older but
> still not quite old.
> 
> Introduction:
> -------------
> 
> The memory interface of AMD K8 CPUs supports "Extended fixed-range MTRR
> Type-Field Encodings" which allow to specify whether accesses to certain
> address ranges are executed by accessing RAM thru the AMD Direct Connect
> Architecture or by executing memory-mapped I/O. The associated CPU feature
> is called IORR's or I/O Range Registers. This allows e.g. to implement
> Shadow RAM by copying ROM contents into RAM.
> 
> The BIOS of these Acer AMD Turion 64 notebooks makes use of fixed-range
> IORRs to implement shadow RAM and other configurations, and it does
> this while it transitions the system into ACPI mode, but Linux is not
> prepared for that and breaks the IORRs/MTRRs while suspending, resulting
> in errors which look like hardware errors. Symptoms vary from from instant
> resets and power-offs to SATA link failures.
> 
> References:
> http://en.wikipedia.org/wiki/MTRR
> http://en.wikipedia.org/wiki/Direct_Connect_Architecture
> http://en.wikipedia.org/wiki/Memory-mapped_IO
> http://en.wikipedia.org/wiki/Random_access_memory#Shadow_RAM
> 
> In-depth problem description:
> -----------------------------
> 
> AMD introduced this MTRR extension with the AMD64 CPUs which have integrated
> memory controllers. In part (fixed-range IORRs for addresses below 1MB), AMD
> uses the fixed-range MTRR registers which already configure the address range
> below 1MB to implement corresponding IORR bits and calls the resulting
> memory access methods in combination with the original Intel-style MTRR
> bits "Extended fixed-range MTRR Type-Field Encodings". They are documented
> in section 7.8.1 of the "AMD64 Architecture Programmer's Manual Volume 2:
> System Programming", starting with page 234:
> http://amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf
> 
> The extended fixed-range type-field encodings are enabled using two
> bits in the AMD64-specific SYSCFG MSR (described in detail on page 59).
> 
> When the extended fixed-range type-field encodings are enabled, all
> fixed-range MTRR fields are defined this way:
> 
>   7      5          4                3         2                   0
> +--------------------------------------------------------------------+
> | reserved | IORR RdMem bit | IORR WrMem bit | Intel-style MTRR bits |
> +--------------------------------------------------------------------+
> 
> Linux MTRR code does not yet support that the BIOS may change fixed-range
> MTRRs and when suspending, this leads Linux MTRR code to clear the IORR bits
> for some memory regions. The resulting combination of IORR and Intel-style
> MTRR bits is not allowed and causes undefined and unpredictable behaviour
> (see the last paragraph before table 7-10).
> 
> A possible workaround is to detect the Acer Ferraris through DMI and
> don't change the fixed-range MTTRs on them. Linux MTRR code has no
> external interface to change fixed-range MTRRs, so no functionality
> and no syncronisation (it's broken on the Ferrari 1000 after ACPI
> is enabled if no real fix is applied) is lost by this patch:
> 
> --- linux/arch/i386/kernel/cpu/mtrr/generic.c
> +++ linux/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -3,6 +3,7 @@
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/mm.h>
> +#include <linux/dmi.h>
>  #include <asm/io.h>
>  #include <asm/mtrr.h>
>  #include <asm/msr.h>
> @@ -149,6 +150,13 @@ static int set_fixed_ranges(mtrr_type *
>  	int changed = FALSE;
>  	int i;
>  	unsigned int lo, hi;
> +	char *vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
> +	char *product = dmi_get_system_info(DMI_PRODUCT_NAME);
> +
> +	if (vendor && product && !strncmp(vendor, "Acer", 4) &&
> +	    (!strncmp(product, "Ferrari 1000", 12) ||
> +	     !strncmp(product, "Ferrari 5000", 12)))
> +		return FALSE;


What would happen if we just did "return FALSE" here, for all
machines? Lower system performance?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
