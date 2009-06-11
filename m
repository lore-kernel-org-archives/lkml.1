Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZFKQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZFKQ4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZFKQ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:56:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZFKQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:56:37 -0400
Message-ID: <4A3123FF.3010803@zytor.com>
Date: Thu, 11 Jun 2009 08:34:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: vendor reserved memory type
References: <E1MElFX-0007fY-TR@eag09.americas.sgi.com>
In-Reply-To: <E1MElFX-0007fY-TR@eag09.americas.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman wrote:
> From: Cliff Wickman <cpw@sgi.com>
> 
> Create a new e820 memory type (E820_VENDOR_RESERVED) for areas
> of memory reserved by the BIOS in the EFI table.
> 
> (An example use of this functionality is the UV system, which
>  will access extremely large areas of memory with a memory engine
>  that allows a user to address beyond the processor's range.  Such
>  areas are reserved in the EFI table by the BIOS.)
> 

There is no difference between that and E820_RESERVED, so there is no
reason to distinguish them.  The semantics are exactly the same.

> Without this patch the EFI_RESERVED_TYPE memory reservations will be
> marked usable in the e820 table. There will be a collision between
> kernel use and reserver's use of this memory.
> 
> This patch causes the EFI_RESERVED_TYPE memory reservations to be recorded
> in the e820 table as new type E820_VENDOR_RESERVED.
> This patch makes sanitize_e820_map() preserve E820_VENDOR_RESERVED types
> as separate entries.
> 
> [The elilo loader may combine regions of like type as it builds the e820
>  table in boot_params (regular RAM and vendor reserved areas are combined).
>  But this patch makes do_add_efi_memmap() separate the RESERVED regions
>  into separate e820 entries.
>  Some loaders have a restricted number of entries possible in the e820 table,
>  hence the need to record the reservations in the unrestricted EFI table.]
> The call to do_add_efi_memmap() is only made if "add_efi_memmap" is specified
> on the kernel command line.

This patch fixes a real problem in a wrong way.

The real problem is that this condition is too lenient:

                if (md->attribute & EFI_MEMORY_WB)
                        e820_type = E820_RAM;
                else
                        e820_type = E820_RESERVED;

It really should be something like:

	switch (md->type) {
	case EFI_LOADER_CODE:
	case EFI_LOADER_DATA:
	case EFI_BOOT_SERVICES_CODE:
	case EFI_BOOT_SERVICES_DATA:
	case EFI_CONVENTIONAL_MEMORY:
                if (md->attribute & EFI_MEMORY_WB)
                        e820_type = E820_RAM;
                else
                        e820_type = E820_RESERVED;
		break;
	case EFI_ACPI_RECLAIM_MEMORY:
		e820_type = E820_ACPI;
		break;
	case EFI_ACPI_MEMORY_NVS:
		e820_type = E820_NVS;
		break;
	case EFI_UNUSABLE_MEMORY:
		e820_type = E820_UNUSUABLE;
		break;
	default:
		e820_type = E820_RESERVED;
		break;
	}

Personally, it's not clear to me if this should do add any non-memory
ranges, as the boot loader should have done that, but I guess in this
particular case we have already horked out.

Another problem is that the comment is wrong.  sanitize_e820_map() will
coalesce adjacent entries, as it should.

Finally, randomly definiting a standard value in E820 with new semantics
isn't going to fly; it's likely to conflict with official allocations.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


