Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZBJW5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZBJW5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZBJW5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:57:11 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:54409 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbZBJW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:57:09 -0500
MIME-Version: 1.0
In-Reply-To: <4990DFBA.1050401@kernel.org>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
	 <20090204212517.GM22608@elte.hu> <498A206A.2070309@kernel.org>
	 <4990DF7C.1090701@kernel.org> <4990DFBA.1050401@kernel.org>
Date: Tue, 10 Feb 2009 14:57:06 -0800
Message-ID: <9ae48b020902101457o575f8eb0qa72120efea521c46@mail.gmail.com>
Subject: Re: Subject: [PATCH] x86/pci: Detect mmconfig on nVidia MCP55 -v2
From: Ed Swierk <eswierk@aristanetworks.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jbarnes@virtuousgeek.org, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 6:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> From: Ed Swierk <eswierk@aristanetworks.com>
>
> Detect and enable memory-mapped PCI configuration space on the nVidia
> MCP55 southbridge.  Tested against 2.6.27.4 on an Arista Networks
> development board with one MCP55, Coreboot firmware, no ACPI.
>
> v2: add multi mcp55 support, and conexist with amd quad core system by Yinghai
>    also only enable it only when acpi=off or acpi is not built-in
>
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

A couple of comments below. Let me test this version before signing off.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  arch/x86/pci/mmconfig-shared.c |   64 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
>
> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c
> @@ -166,6 +166,68 @@ static const char __init *pci_mmcfg_amd_
>        return "AMD Family 10h NB";
>  }
>
> +static bool __initdata mcp55_checked;
> +static const char __init *pci_mmcfg_nvidia_mcp55(void)
> +{
> +       int bus;
> +       int mcp55_mmconf_found = 0;
> +
> +       static const u32 extcfg_regnum          = 0x90;
> +       static const u32 extcfg_regsize         = 4;
> +       static const u32 extcfg_enable_mask     = 1<<31;
> +       static const u32 extcfg_start_mask      = 0xff<<16;
> +       static const int extcfg_start_shift     = 16;
> +       static const u32 extcfg_size_mask       = 0x3<<28;
> +       static const int extcfg_size_shift      = 28;
> +       static const int extcfg_sizebus[]       = {0x100, 0x80, 0x40, 0x20};
> +       static const u32 extcfg_base_mask[]     = {0x7ff8, 0x7ffc, 0x7ffe, 0x7fff};
> +       static const int extcfg_base_lshift     = 25;
> +
> +       /*
> +        * do check if amd fam10h already took over
> +        */
> +       if (!acpi_disabled || pci_mmcfg_config_num || mcp55_checked)
> +               return NULL;

Why skip this if !acpi_disabled? I thought we want to have the host
bridge mmconfig settings override the ACPI MCFG. At least that appears
to be the logic for other host bridges.

> +       mcp55_checked = true;
> +       for (bus = 0; bus < 256; bus++) {
> +               u64 base;
> +               u32 l, extcfg;
> +               u16 vendor, device;
> +               int start, size_index, end;
> +
> +               raw_pci_ops->read(0, bus, PCI_DEVFN(0, 0), 0, 4, &l);

Don't we need to check devices 8, 16 and 24 as well as 0?

> +               vendor = l & 0xffff;
> +               device = (l >> 16) & 0xffff;
> +
> +               if (PCI_VENDOR_ID_NVIDIA != vendor || 0x0369 != device)
> +                       continue;
> +
> +               raw_pci_ops->read(0, bus, PCI_DEVFN(0, 0), extcfg_regnum,
> +                                 extcfg_regsize, &extcfg);
> +
> +               if (!(extcfg & extcfg_enable_mask))
> +                       continue;
> +
> +               if (extend_mmcfg(1) == -1)
> +                       continue;
> +
> +               size_index = (extcfg & extcfg_size_mask) >> extcfg_size_shift;
> +               base = extcfg & extcfg_base_mask[size_index];
> +               /* base could > 4G */
> +               base <<= extcfg_base_lshift;
> +               start = (extcfg & extcfg_start_mask) >> extcfg_start_shift;
> +               end = start + extcfg_sizebus[size_index] - 1;
> +               fill_one_mmcfg(base, 0, start, end);
> +               mcp55_mmconf_found++;
> +       }
> +
> +       if (!mcp55_mmconf_found)
> +               return NULL;
> +
> +       return "nVidia MCP55";
> +}
> +
>  struct pci_mmcfg_hostbridge_probe {
>        u32 bus;
>        u32 devfn;
> @@ -183,6 +245,8 @@ static struct pci_mmcfg_hostbridge_probe
>          0x1200, pci_mmcfg_amd_fam10h },
>        { 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD,
>          0x1200, pci_mmcfg_amd_fam10h },
> +       { 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_NVIDIA,
> +         0x0369, pci_mmcfg_nvidia_mcp55 },
>  };
>
>  static int __init cmp_mmcfg(const void *x1, const void *x2)
>
