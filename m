Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbYGJBr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbYGJBr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGJBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:47:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbYGJBrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:47:46 -0400
Date: Wed, 9 Jul 2008 18:41:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 03/34] AMD IOMMU: add defines and structures for ACPI
 scanning code
Message-Id: <20080709184141.4f81ae6d.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-4-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:39 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds the required data structures and constants required to parse
> the ACPI table for the AMD IOMMU.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |  101 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 101 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/kernel/amd_iommu_init.c
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> new file mode 100644
> index 0000000..6fce5ab
> --- /dev/null
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
> + * Author: Joerg Roedel <joerg.roedel@amd.com>
> + *         Leo Duran <leo.duran@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/acpi.h>
> +#include <linux/gfp.h>
> +#include <linux/list.h>
> +#include <asm/pci-direct.h>
> +#include <asm/amd_iommu_types.h>
> +#include <asm/gart.h>
> +
> +/*
> + * definitions for the ACPI scanning code
> + */
> +#define UPDATE_LAST_BDF(x) do {\
> +	if ((x) > amd_iommu_last_bdf) \
> +		amd_iommu_last_bdf = (x); \
> +	} while (0);

Does this need to exist?

If so, it could and should be implemented as a C function, not as a macro.

> +#define DEVID(bus, devfn) (((bus) << 8) | (devfn))

I suspect that a helper function for this already exists.

> +#define PCI_BUS(x) (((x) >> 8) & 0xff)

And this.  If it doesn't exist, probably it should?

> +#define IVRS_HEADER_LENGTH 48
> +#define TBL_SIZE(x) (1 << (PAGE_SHIFT + get_order(amd_iommu_last_bdf * (x))))

Can be implemented in C.

> +#define ACPI_IVHD_TYPE                  0x10
> +#define ACPI_IVMD_TYPE_ALL              0x20
> +#define ACPI_IVMD_TYPE                  0x21
> +#define ACPI_IVMD_TYPE_RANGE            0x22
> +
> +#define IVHD_DEV_ALL                    0x01
> +#define IVHD_DEV_SELECT                 0x02
> +#define IVHD_DEV_SELECT_RANGE_START     0x03
> +#define IVHD_DEV_RANGE_END              0x04
> +#define IVHD_DEV_ALIAS                  0x42
> +#define IVHD_DEV_ALIAS_RANGE            0x43
> +#define IVHD_DEV_EXT_SELECT             0x46
> +#define IVHD_DEV_EXT_SELECT_RANGE       0x47
> +
> +#define IVHD_FLAG_HT_TUN_EN             0x00
> +#define IVHD_FLAG_PASSPW_EN             0x01
> +#define IVHD_FLAG_RESPASSPW_EN          0x02
> +#define IVHD_FLAG_ISOC_EN               0x03
> +
> +#define IVMD_FLAG_EXCL_RANGE            0x08
> +#define IVMD_FLAG_UNITY_MAP             0x01
> +
> +#define ACPI_DEVFLAG_INITPASS           0x01
> +#define ACPI_DEVFLAG_EXTINT             0x02
> +#define ACPI_DEVFLAG_NMI                0x04
> +#define ACPI_DEVFLAG_SYSMGT1            0x10
> +#define ACPI_DEVFLAG_SYSMGT2            0x20
> +#define ACPI_DEVFLAG_LINT0              0x40
> +#define ACPI_DEVFLAG_LINT1              0x80
> +#define ACPI_DEVFLAG_ATSDIS             0x10000000
> +
> +struct ivhd_header {
> +	u8 type;
> +	u8 flags;
> +	u16 length;
> +	u16 devid;
> +	u16 cap_ptr;
> +	u64 mmio_phys;
> +	u16 pci_seg;
> +	u16 info;
> +	u32 reserved;
> +} __attribute__((packed));
> +
> +struct ivhd_entry {
> +	u8 type;
> +	u16 devid;
> +	u8 flags;
> +	u32 ext;
> +} __attribute__((packed));
> +
> +struct ivmd_header {
> +	u8 type;
> +	u8 flags;
> +	u16 length;
> +	u16 devid;
> +	u16 aux;
> +	u64 resv;
> +	u64 range_start;
> +	u64 range_length;
> +} __attribute__((packed));

I can make a guess as to why these are "packed", but a code comment would
prevent guesswork.
