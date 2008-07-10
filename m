Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbYGJBzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbYGJBzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYGJBzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:55:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbYGJBzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:55:05 -0400
Date: Wed, 9 Jul 2008 18:49:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 11/34] AMD IOMMU: add functions for IOMMU hardware
 initialization from ACPI
Message-Id: <20080709184917.fba68fd0.akpm@linux-foundation.org>
In-Reply-To: <1214508490-29683-12-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:47 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds functions to initialize the IOMMU hardware with information
> from ACPI and PCI.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |  125 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 125 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index 4c37abb..8ec48f1 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -353,3 +353,128 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
>  	}
>  }
>  
> +static void __init init_iommu_from_pci(struct amd_iommu *iommu)
> +{
> +	int bus = PCI_BUS(iommu->devid);
> +	int dev = PCI_SLOT(iommu->devid);
> +	int fn  = PCI_FUNC(iommu->devid);
> +	int cap_ptr = iommu->cap_ptr;
> +	u32 range;
> +
> +	iommu->cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_CAP_HDR_OFFSET);
> +
> +	range = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
> +	iommu->first_device = DEVID(MMIO_GET_BUS(range), MMIO_GET_FD(range));
> +	iommu->last_device = DEVID(MMIO_GET_BUS(range), MMIO_GET_LD(range));
> +}
> +
> +static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
> +					struct ivhd_header *h)
> +{
> +	u8 *p = (u8 *)h;
> +	u8 *end = p, flags = 0;
> +	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
> +	u32 ext_flags = 0;
> +	bool alias = 0;

Using `false' would be more conventional.

> +			alias = 1;

`true'.

etc.


