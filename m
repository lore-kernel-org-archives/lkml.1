Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYFPKpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYFPKpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYFPKpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:45:12 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:53701 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbYFPKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bkqJvTOgfTbXBFLV1PyM3YeMQ2sJ2pxDS604MA//H5TJLisftxpq2eWegxj7askeEh
         sUTaZA8b7lKDGCCsjwJGaXNbleMEh5f6CnaihjjdqieuufT4dPJz6b5G3xD1cmTnFNU+
         hmUc0XepW1ACit6+qSL5UeTzaCgVxH/R0+XCQ=
Message-ID: <485643CE.9050800@gmail.com>
Date: Mon, 16 Jun 2008 12:43:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <200806121557.28505.bjorn.helgaas@hp.com> <48529AAC.3030008@gmail.com> <200806131123.16890.bjorn.helgaas@hp.com>
In-Reply-To: <200806131123.16890.bjorn.helgaas@hp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2008 07:23 PM, Bjorn Helgaas wrote:
> Thanks a lot!  Your BIOS clearly claims that at least one of your
> serial ports can be configured with DMA:
> 
>   pnp 00:07:   dependent set 5 (acceptable) io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
>   pnp 00:07:   dependent set 5 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
>   pnp 00:07:   dependent set 5 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0
> 
> That's wierd, but whatever, we still have to be careful to give the
> BIOS back what it expects, and I think that means we have to keep
> track of that disabled DMA resource in pnpacpi_allocated_resource().
> 
> Can you please replace the debug patch with the one below and send me
> the results again?
> 
> Index: work10/drivers/pnp/pnpacpi/rsparser.c
> ===================================================================
> --- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-11 12:46:28.000000000 -0600
> +++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-06-13 11:13:21.000000000 -0600
> @@ -240,6 +240,7 @@ static acpi_status pnpacpi_allocated_res
>  	struct acpi_resource_fixed_memory32 *fixed_memory32;
>  	struct acpi_resource_extended_irq *extended_irq;
>  	int i, flags;
> +	u8 channel;
>  
>  	switch (res->type) {
>  	case ACPI_RESOURCE_TYPE_IRQ:
> @@ -259,13 +260,13 @@ static acpi_status pnpacpi_allocated_res
>  
>  	case ACPI_RESOURCE_TYPE_DMA:
>  		dma = &res->data.dma;
> -		if (dma->channel_count > 0) {
> -			flags = dma_flags(dma->type, dma->bus_master,
> -					  dma->transfer);
> -			if (dma->channels[0] == (u8) -1)
> -				flags |= IORESOURCE_DISABLED;
> -			pnp_add_dma_resource(dev, dma->channels[0], flags);
> +		channel = dma->channels[0];
> +		flags = dma_flags(dma->type, dma->bus_master, dma->transfer);
> +		if (dma->channel_count == 0 || dma->channels[0] == (u8) -1) {
> +			channel = -1;
> +			flags = IORESOURCE_DISABLED;
>  		}
> +		pnp_add_dma_resource(dev, channel, flags);
>  		break;
>  
>  	case ACPI_RESOURCE_TYPE_IO:

Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: parse allocated resources
pnp 00:00:   add io  0xcf8-0xcff flags 0x1
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: parse allocated resources
pnp 00:01:   add mem 0xfed14000-0xfed19fff flags 0x1
pnp 00:01: PNP0c01: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: parse allocated resources
pnp 00:02:   add dma 4 flags 0x4
pnp 00:02:   add io  0x0-0xf flags 0x1
pnp 00:02:   add io  0x81-0x83 flags 0x1
pnp 00:02:   add io  0x87-0x87 flags 0x1
pnp 00:02:   add io  0x89-0x8b flags 0x1
pnp 00:02:   add io  0x8f-0x8f flags 0x1
pnp 00:02:   add io  0xc0-0xdf flags 0x1
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: parse allocated resources
pnp 00:03:   add io  0x70-0x71 flags 0x1
pnp 00:03:   add irq 8 flags 0x1
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: parse allocated resources
pnp 00:04:   add io  0x61-0x61 flags 0x1
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: parse allocated resources
pnp 00:05:   add io  0xf0-0xff flags 0x1
pnp 00:05:   add irq 13 flags 0x1
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: parse allocated resources
pnp 00:06:   add io  0x3f8-0x3ff flags 0x1
pnp 00:06:   add irq 4 flags 0x1
pnp 00:06:   add dma 255 flags 0x10000000
pnp 00:06: parse resource options
pnp 00:06:   dependent set 0 (preferred) io  min 0x3f8 max 0x3f8 align 1 size 8 
flags 0x1
pnp 00:06:   dependent set 0 (preferred) irq 4 flags 0x1
pnp 00:06:   dependent set 1 (acceptable) io  min 0x3f8 max 0x3f8 align 1 size 8 
flags 0x1
pnp 00:06:   dependent set 1 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:06:   dependent set 2 (acceptable) io  min 0x2f8 max 0x2f8 align 1 size 8 
flags 0x1
pnp 00:06:   dependent set 2 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:06:   dependent set 3 (acceptable) io  min 0x3e8 max 0x3e8 align 1 size 8 
flags 0x1
pnp 00:06:   dependent set 3 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:06:   dependent set 4 (acceptable) io  min 0x2e8 max 0x2e8 align 1 size 8 
flags 0x1
pnp 00:06:   dependent set 4 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:07: parse allocated resources
pnp 00:07:   add io  0x2f8-0x2ff flags 0x1
pnp 00:07:   add irq 3 flags 0x1
pnp 00:07:   add dma 255 flags 0x10000000
pnp 00:07: parse resource options
pnp 00:07:   dependent set 0 (preferred) io  min 0x2f8 max 0x2f8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 0 (preferred) irq 3 flags 0x1
pnp 00:07:   dependent set 1 (acceptable) io  min 0x3f8 max 0x3f8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 1 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 2 (acceptable) io  min 0x2f8 max 0x2f8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 2 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 3 (acceptable) io  min 0x3e8 max 0x3e8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 3 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 4 (acceptable) io  min 0x2e8 max 0x2e8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 4 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 5 (acceptable) io  min 0x3f8 max 0x3f8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 5 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 5 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0
pnp 00:07:   dependent set 6 (acceptable) io  min 0x2f8 max 0x2f8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 6 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 6 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0
pnp 00:07:   dependent set 7 (acceptable) io  min 0x3e8 max 0x3e8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 7 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 7 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0
pnp 00:07:   dependent set 8 (acceptable) io  min 0x2e8 max 0x2e8 align 1 size 8 
flags 0x1
pnp 00:07:   dependent set 8 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:07:   dependent set 8 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0
pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:08: parse allocated resources
pnp 00:08:   add io  0x3f0-0x3f5 flags 0x1
pnp 00:08:   add io  0x3f7-0x3f7 flags 0x1
pnp 00:08:   add irq 6 flags 0x1
pnp 00:08:   add dma 2 flags 0x0
pnp 00:08: parse resource options
pnp 00:08:   dependent set 0 (preferred) io  min 0x3f0 max 0x3f0 align 1 size 6 
flags 0x1
pnp 00:08:   dependent set 0 (preferred) io  min 0x3f7 max 0x3f7 align 1 size 1 
flags 0x1
pnp 00:08:   dependent set 0 (preferred) irq 6 flags 0x1
pnp 00:08:   dependent set 0 (preferred) dma 2 (bitmask 0x4) flags 0x0
pnp 00:08:   dependent set 1 (acceptable) io  min 0x3f0 max 0x3f0 align 1 size 6 
flags 0x1
pnp 00:08:   dependent set 1 (acceptable) io  min 0x3f7 max 0x3f7 align 1 size 1 
flags 0x1
pnp 00:08:   dependent set 1 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:08:   dependent set 1 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0
pnp 00:08:   dependent set 2 (acceptable) io  min 0x370 max 0x370 align 1 size 6 
flags 0x1
pnp 00:08:   dependent set 2 (acceptable) io  min 0x377 max 0x377 align 1 size 1 
flags 0x1
pnp 00:08:   dependent set 2 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
pnp 00:08:   dependent set 2 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0
pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:09: parse allocated resources
pnp 00:09:   add io  0x0-0xffffffffffffffff flags 0x10000001
pnp 00:09:   add io  0xa20-0xa3f flags 0x1
pnp 00:09:   add io  0xa00-0xa0f flags 0x1
pnp 00:09:   add io  0xa10-0xa1f flags 0x1
pnp 00:09:   add io  0xa40-0xa5f flags 0x1
pnp 00:09: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: parse allocated resources
pnp 00:0a:   add io  0x10-0x1f flags 0x1
pnp 00:0a:   add io  0x22-0x3f flags 0x1
pnp 00:0a:   add io  0x44-0x5f flags 0x1
pnp 00:0a:   add io  0x62-0x63 flags 0x1
pnp 00:0a:   add io  0x65-0x6f flags 0x1
pnp 00:0a:   add io  0x72-0x7f flags 0x1
pnp 00:0a:   add io  0x80-0x80 flags 0x1
pnp 00:0a:   add io  0x84-0x86 flags 0x1
pnp 00:0a:   add io  0x88-0x88 flags 0x1
pnp 00:0a:   add io  0x8c-0x8e flags 0x1
pnp 00:0a:   add io  0x90-0x9f flags 0x1
pnp 00:0a:   add io  0xa2-0xbf flags 0x1
pnp 00:0a:   add io  0xe0-0xef flags 0x1
pnp 00:0a:   add io  0x4d0-0x4d1 flags 0x1
pnp 00:0a:   add io  0x800-0x87f flags 0x1
pnp 00:0a:   add io  0x0-0xffffffffffffffff flags 0x10000001
pnp 00:0a:   add io  0x480-0x4bf flags 0x1
pnp 00:0a:   add mem 0xfed1c000-0xfed1ffff flags 0x1
pnp 00:0a:   add mem 0xfed20000-0xfed8ffff flags 0x1
pnp 00:0a: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: parse allocated resources
pnp 00:0b:   add io  0x60-0x60 flags 0x1
pnp 00:0b:   add io  0x64-0x64 flags 0x1
pnp 00:0b: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: parse allocated resources
pnp 00:0c:   add mem 0xfed00000-0xfed003ff flags 0x0
pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:0d: parse allocated resources
pnp 00:0d:   add mem 0xffb00000-0xffbfffff flags 0x0
pnp 00:0d:   add mem 0xfff00000-0xffffffff flags 0x0
pnp 00:0d: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:0e: parse allocated resources
pnp 00:0e:   add mem 0xffc00000-0xffefffff flags 0x0
pnp 00:0e: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0f: parse allocated resources
pnp 00:0f:   add mem 0xfec00000-0xfec00fff flags 0x0
pnp 00:0f:   add mem 0xfee00000-0xfee00fff flags 0x0
pnp 00:0f: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:0f: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:10: parse allocated resources
pnp 00:10:   add mem 0xe0000000-0xefffffff flags 0x0
pnp 00:10: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:10: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:11: parse allocated resources
pnp 00:11:   add mem 0x0-0xffffffffffffffff flags 0x10000000
pnp 00:11: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:11: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:12: parse allocated resources
pnp 00:12:   add mem 0xfed90000-0xfed90fff flags 0x1
pnp 00:12: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:12: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:13: parse allocated resources
pnp 00:13:   add mem 0xfed91000-0xfed91fff flags 0x1
pnp 00:13: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:13: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:14: parse allocated resources
pnp 00:14:   add mem 0xfed92000-0xfed92fff flags 0x1
pnp 00:14: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:14: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:15: parse allocated resources
pnp 00:15:   add mem 0xfed93000-0xfed93fff flags 0x1
pnp 00:15: PNP0c02: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:15: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:16: parse allocated resources
pnp 00:16:   add mem 0x0-0x9ffff flags 0x1
pnp 00:16:   add mem 0xc0000-0xcffff flags 0x0
pnp 00:16:   add mem 0xe0000-0xfffff flags 0x0
pnp 00:16:   add mem 0x100000-0x7d5fffff flags 0x1
pnp 00:16:   add mem 0x0-0xffffffffffffffff flags 0x10000000
pnp 00:16: PNP0c01: calling quirk_system_pci_resources+0x0/0x1d0
pnp 00:16: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 23 devices
...
serial 00:06: pnp_start_dev: current resources:
serial 00:06:   io  0x3f8-0x3ff flags 0x101
serial 00:06:   irq 4 flags 0x401
serial 00:06:   dma disabled
serial 00:06: set resources
serial 00:06: encode 3 resources
serial 00:06:   encode io 0x3f8-0x3ff decode 0x1
serial 00:06:   encode irq 4 edge high exclusive (2-byte descriptor)
serial 00:06:   encode dma 255 type 0x0 transfer 0x0 master 0
serial 00:06: activated
serial 00:07: pnp_start_dev: current resources:
serial 00:07:   io  0x2f8-0x2ff flags 0x101
serial 00:07:   irq 3 flags 0x401
serial 00:07:   dma disabled
serial 00:07: set resources
serial 00:07: encode 3 resources
serial 00:07:   encode io 0x2f8-0x2ff decode 0x1
serial 00:07:   encode irq 3 edge high exclusive (2-byte descriptor)
serial 00:07:   encode dma 255 type 0x0 transfer 0x0 master 0
serial 00:07: activated
