Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYGJMSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYGJMSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYGJMSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:18:39 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:19812 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYGJMSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:18:38 -0400
X-BigFish: VPS-36(zz1432R98dR7efV18c1K1805M655O873fnc8kzz10d3izzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K3SI6M-03-QH0-01
Date: Thu, 10 Jul 2008 14:17:52 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 03/34] AMD IOMMU: add defines and structures for ACPI scanning code
Message-ID: <20080710121752.GI14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-4-git-send-email-joerg.roedel@amd.com> <20080709184141.4f81ae6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709184141.4f81ae6d.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 12:17:52.0415 (UTC) FILETIME=[F9C76AF0:01C8E286]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 06:41:41PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 21:27:39 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch adds the required data structures and constants required to parse
> > the ACPI table for the AMD IOMMU.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu_init.c |  101 ++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 101 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/x86/kernel/amd_iommu_init.c
> > 
> > diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> > new file mode 100644
> > index 0000000..6fce5ab
> > --- /dev/null
> > +++ b/arch/x86/kernel/amd_iommu_init.c
> > @@ -0,0 +1,101 @@
> > +/*
> > + * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
> > + * Author: Joerg Roedel <joerg.roedel@amd.com>
> > + *         Leo Duran <leo.duran@amd.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published
> > + * by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> > + */
> > +
> > +#include <linux/pci.h>
> > +#include <linux/acpi.h>
> > +#include <linux/gfp.h>
> > +#include <linux/list.h>
> > +#include <asm/pci-direct.h>
> > +#include <asm/amd_iommu_types.h>
> > +#include <asm/gart.h>
> > +
> > +/*
> > + * definitions for the ACPI scanning code
> > + */
> > +#define UPDATE_LAST_BDF(x) do {\
> > +	if ((x) > amd_iommu_last_bdf) \
> > +		amd_iommu_last_bdf = (x); \
> > +	} while (0);
> 
> Does this need to exist?
> 
> If so, it could and should be implemented as a C function, not as a macro.

Yes, this macro is usefull because it makes the code look cleaner. But I
will convert that into a function.

> > +#define DEVID(bus, devfn) (((bus) << 8) | (devfn))
> 
> I suspect that a helper function for this already exists.

I have not found one. Macros exist for slot/function of PCI devices. But
nothing which also includes the bus.

> > +#define PCI_BUS(x) (((x) >> 8) & 0xff)
> 
> And this.  If it doesn't exist, probably it should?

Ok, I move that one to linux/pci.h.

> 
> > +#define IVRS_HEADER_LENGTH 48
> > +#define TBL_SIZE(x) (1 << (PAGE_SHIFT + get_order(amd_iommu_last_bdf * (x))))
> 
> Can be implemented in C.

Right. I will convert that into a function too.

> 
> > +#define ACPI_IVHD_TYPE                  0x10
> > +#define ACPI_IVMD_TYPE_ALL              0x20
> > +#define ACPI_IVMD_TYPE                  0x21
> > +#define ACPI_IVMD_TYPE_RANGE            0x22
> > +
> > +#define IVHD_DEV_ALL                    0x01
> > +#define IVHD_DEV_SELECT                 0x02
> > +#define IVHD_DEV_SELECT_RANGE_START     0x03
> > +#define IVHD_DEV_RANGE_END              0x04
> > +#define IVHD_DEV_ALIAS                  0x42
> > +#define IVHD_DEV_ALIAS_RANGE            0x43
> > +#define IVHD_DEV_EXT_SELECT             0x46
> > +#define IVHD_DEV_EXT_SELECT_RANGE       0x47
> > +
> > +#define IVHD_FLAG_HT_TUN_EN             0x00
> > +#define IVHD_FLAG_PASSPW_EN             0x01
> > +#define IVHD_FLAG_RESPASSPW_EN          0x02
> > +#define IVHD_FLAG_ISOC_EN               0x03
> > +
> > +#define IVMD_FLAG_EXCL_RANGE            0x08
> > +#define IVMD_FLAG_UNITY_MAP             0x01
> > +
> > +#define ACPI_DEVFLAG_INITPASS           0x01
> > +#define ACPI_DEVFLAG_EXTINT             0x02
> > +#define ACPI_DEVFLAG_NMI                0x04
> > +#define ACPI_DEVFLAG_SYSMGT1            0x10
> > +#define ACPI_DEVFLAG_SYSMGT2            0x20
> > +#define ACPI_DEVFLAG_LINT0              0x40
> > +#define ACPI_DEVFLAG_LINT1              0x80
> > +#define ACPI_DEVFLAG_ATSDIS             0x10000000
> > +
> > +struct ivhd_header {
> > +	u8 type;
> > +	u8 flags;
> > +	u16 length;
> > +	u16 devid;
> > +	u16 cap_ptr;
> > +	u64 mmio_phys;
> > +	u16 pci_seg;
> > +	u16 info;
> > +	u32 reserved;
> > +} __attribute__((packed));
> > +
> > +struct ivhd_entry {
> > +	u8 type;
> > +	u16 devid;
> > +	u8 flags;
> > +	u32 ext;
> > +} __attribute__((packed));
> > +
> > +struct ivmd_header {
> > +	u8 type;
> > +	u8 flags;
> > +	u16 length;
> > +	u16 devid;
> > +	u16 aux;
> > +	u64 resv;
> > +	u64 range_start;
> > +	u64 range_length;
> > +} __attribute__((packed));
> 
> I can make a guess as to why these are "packed", but a code comment would
> prevent guesswork.

I am currently preparing patches to add a lot of comments to the code. I
will also add a comment to these structures.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

