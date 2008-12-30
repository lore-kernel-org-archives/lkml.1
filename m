Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYL3Qiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYL3Qiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYL3Qil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:38:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYL3Qik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:38:40 -0500
Message-ID: <495A4E85.6070800@redhat.com>
Date: Tue, 30 Dec 2008 18:38:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Tony Battersby <tonyb@cybernetics.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] [DMAR] Fix endless "Unknown DMAR structure type" loop
References: <495A4A39.20903@cybernetics.com>
In-Reply-To: <495A4A39.20903@cybernetics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(copying relevant people)

Tony Battersby wrote:
> I have a SuperMicro C2SBX motherboard with BIOS revision 1.0b.  With
> vt-d enabled in the BIOS, Linux gets into an endless loop printing
> "DMAR:Unknown DMAR structure type" when booting.  Here is the DMAR ACPI
> table:
>
> DMAR @ 0x7fe86dec
>   0000: 44 4d 41 52 98 00 00 00 01 6f 49 6e 74 65 6c 20  DMAR.....oIntel 
>   0010: 4f 45 4d 44 4d 41 52 20 00 00 04 06 4c 4f 48 52  OEMDMAR ....LOHR
>   0020: 01 00 00 00 23 00 00 00 00 00 00 00 00 00 00 00  ....#...........
>   0030: 01 00 58 00 00 00 00 00 00 a0 e8 7f 00 00 00 00  ..X.............
>   0040: ff ff ef 7f 00 00 00 00 01 08 00 00 00 00 1d 00  ................
>   0050: 01 08 00 00 00 00 1d 01 01 08 00 00 00 00 1d 02  ................
>   0060: 01 08 00 00 00 00 1d 07 01 08 00 00 00 00 1a 00  ................
>   0070: 01 08 00 00 00 00 1a 01 01 08 00 00 00 00 1a 02  ................
>   0080: 01 08 00 00 00 00 1a 07 01 08 00 00 00 00 1a 07  ................
>   0090: c0 00 68 00 04 10 66 60                          ..h...f`
>
> Here are the messages printed by the kernel:
>
> DMAR:Host address width 36
> DMAR:RMRR base: 0x000000007fe8a000 end: 0x000000007fefffff
> DMAR:Unknown DMAR structure type
> DMAR:Unknown DMAR structure type
> DMAR:Unknown DMAR structure type
> ...
>
> Although I not very familiar with ACPI, to me it looks like
> struct acpi_dmar_header::length == 0x0058 is incorrect, causing
> parse_dmar_table() to look at an invalid offset on the next loop.  This
> offset happens to have struct acpi_dmar_header::length == 0x0000, which
> prevents the loop from ever terminating.  This patch checks for this
> condition and bails out instead of looping forever.
>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>
> I previously sent this to linux-acpi on August 18, 2008, but got no
> reply.  Please apply this patch upstream (2.6.29 if possible).
>
> --- linux-2.6.28-git2/drivers/pci/dmar.c.orig	2008-12-24 18:26:37.000000000 -0500
> +++ linux-2.6.28-git2/drivers/pci/dmar.c	2008-12-30 11:01:17.000000000 -0500
> @@ -339,6 +339,14 @@ parse_dmar_table(void)
>  	entry_header = (struct acpi_dmar_header *)(dmar + 1);
>  	while (((unsigned long)entry_header) <
>  			(((unsigned long)dmar) + dmar_tbl->length)) {
> +		/* Avoid looping forever on bad ACPI tables */
> +		if (entry_header->length == 0) {
> +			printk(KERN_WARNING PREFIX
> +				"Invalid 0-length structure\n");
> +			ret = -EINVAL;
> +			break;
> +		}
> +
>  		dmar_table_print_dmar_entry(entry_header);
>  
>  		switch (entry_header->type) {
>
>
>   


-- 
error compiling committee.c: too many arguments to function

