Return-Path: <linux-kernel-owner+w=401wt.eu-S1765652AbZFLNpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765652AbZFLNpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbZFLNiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:38:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58809 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765836AbZFLNiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:38:18 -0400
Date: Fri, 12 Jun 2009 08:39:18 -0500
From: Cliff Wickman <cpw@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: vendor reserved memory type
Message-ID: <20090612133918.GA17557@sgi.com>
References: <E1MElFX-0007fY-TR@eag09.americas.sgi.com> <4A3123FF.3010803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3123FF.3010803@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jun 11, 2009 at 08:34:23AM -0700, H. Peter Anvin wrote:
> Cliff Wickman wrote:
> > From: Cliff Wickman <cpw@sgi.com>
> > 
> > Create a new e820 memory type (E820_VENDOR_RESERVED) for areas
> > of memory reserved by the BIOS in the EFI table.
> > 
> > (An example use of this functionality is the UV system, which
> >  will access extremely large areas of memory with a memory engine
> >  that allows a user to address beyond the processor's range.  Such
> >  areas are reserved in the EFI table by the BIOS.)
> > 
> 
> There is no difference between that and E820_RESERVED, so there is no
> reason to distinguish them.  The semantics are exactly the same.

I thought a new type would be clearer, but if it would break an e820
standard I withdraw the idea.  All is good as long as the memory gets reserved.
> 
> > Without this patch the EFI_RESERVED_TYPE memory reservations will be
> > marked usable in the e820 table. There will be a collision between
> > kernel use and reserver's use of this memory.
> > 
> > This patch causes the EFI_RESERVED_TYPE memory reservations to be recorded
> > in the e820 table as new type E820_VENDOR_RESERVED.
> > This patch makes sanitize_e820_map() preserve E820_VENDOR_RESERVED types
> > as separate entries.
> > 
> > [The elilo loader may combine regions of like type as it builds the e820
> >  table in boot_params (regular RAM and vendor reserved areas are combined).
> >  But this patch makes do_add_efi_memmap() separate the RESERVED regions
> >  into separate e820 entries.
> >  Some loaders have a restricted number of entries possible in the e820 table,
> >  hence the need to record the reservations in the unrestricted EFI table.]
> > The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
> > on the kernel command line.
> 
> This patch fixes a real problem in a wrong way.
> 
> The real problem is that this condition is too lenient:
> 
>                 if (md->attribute & EFI_MEMORY_WB)
>                         e820_type = E820_RAM;
>                 else
>                         e820_type = E820_RESERVED;
> 
> It really should be something like:
> 
> 	switch (md->type) {
> 	case EFI_LOADER_CODE:
> 	case EFI_LOADER_DATA:
> 	case EFI_BOOT_SERVICES_CODE:
> 	case EFI_BOOT_SERVICES_DATA:
> 	case EFI_CONVENTIONAL_MEMORY:
>                 if (md->attribute & EFI_MEMORY_WB)
>                         e820_type = E820_RAM;
>                 else
>                         e820_type = E820_RESERVED;
> 		break;
> 	case EFI_ACPI_RECLAIM_MEMORY:
> 		e820_type = E820_ACPI;
> 		break;
> 	case EFI_ACPI_MEMORY_NVS:
> 		e820_type = E820_NVS;
> 		break;
> 	case EFI_UNUSABLE_MEMORY:
> 		e820_type = E820_UNUSUABLE;
> 		break;
> 	default:
> 		e820_type = E820_RESERVED;
> 		break;
> 	}

Okay. I buy that as more straightforward.
 
> Personally, it's not clear to me if this should do add any non-memory
> ranges, as the boot loader should have done that, but I guess in this
> particular case we have already horked out.
> 
> Another problem is that the comment is wrong.  sanitize_e820_map() will
> coalesce adjacent entries, as it should.
> 
> Finally, randomly definiting a standard value in E820 with new semantics
> isn't going to fly; it's likely to conflict with official allocations.
> 
> 	-hpa

I propose to submit your code (basically) in the form of the below patch.
It works for me.   Does it look okay to you?


 
Subject: [PATCH] x86: efi/e820 table merge fix

This patch causes all the EFI_RESERVED_TYPE memory reservations to be recorded
in the e820 table as type E820_RESERVED.

Without this patch EFI_RESERVED_TYPE memory reservations may be
marked usable in the e820 table. There may be a collision between
kernel use and some reserver's use of this memory.

(An example use of this functionality is the UV system, which
 will access extremely large areas of memory with a memory engine
 that allows a user to address beyond the processor's range.  Such
 areas are reserved in the EFI table by the BIOS.
 Some loaders have a restricted number of entries possible in the e820 table,
 hence the need to record the reservations in the unrestricted EFI table.)

The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
on the kernel command line.

Diffed against 2.6.30-rc8

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/efi.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -240,10 +240,35 @@ static void __init do_add_efi_memmap(voi
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		int e820_type;
 
-		if (md->attribute & EFI_MEMORY_WB)
-			e820_type = E820_RAM;
-		else
+		switch (md->type) {
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			if (md->attribute & EFI_MEMORY_WB)
+				e820_type = E820_RAM;
+			else
+				e820_type = E820_RESERVED;
+			break;
+		case EFI_ACPI_RECLAIM_MEMORY:
+			e820_type = E820_ACPI;
+			break;
+		case EFI_ACPI_MEMORY_NVS:
+			e820_type = E820_NVS;
+			break;
+		case EFI_UNUSABLE_MEMORY:
+			e820_type = E820_UNUSABLE;
+			break;
+		default:
+			/*
+			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
+			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
+			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
+			 */
 			e820_type = E820_RESERVED;
+			break;
+		}
 		e820_add_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
