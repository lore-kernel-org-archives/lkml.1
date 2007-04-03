Return-Path: <linux-kernel-owner+w=401wt.eu-S1422642AbXDCSx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422642AbXDCSx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422649AbXDCSx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:53:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:5302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422642AbXDCSx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:53:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="68186265:sNHT18402030"
Date: Tue, 3 Apr 2007 11:52:19 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Williams, Mitch A" <mitch.a.williams@intel.com>
Subject: Re: [PATCH] msi: Immediately mask and unmask msi-x irqs.
Message-ID: <20070403185219.GB15704@linux-os.sc.intel.com>
References: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com> <m1lkh9dhvm.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lkh9dhvm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 01:41:49AM -0600, Eric W. Biederman wrote:
> When we mask or unmask a msi-x irqs the writes may be posted because
> we are writing to memory mapped region.  This means the mask and
> unmask don't happen immediately but at some unspecified time in the
> future.  Which is out of sync with how the mask/unmask logic work
> for ioapic irqs.
> 
> The practical result is that we get very subtle and hard to track down
> irq migration bugs.
> 
> This patch performs a read flush after writes to the MSI-X table for mask
> and unmask operations.  Since the SMP affinity is set while the interrupt
> is masked, and since it's unmasked immediately after, no additional flushes
> are required in the various affinity setting routines.

set_msi_irq_affinity() is already doing read_msi_msg(). So the mask operation
before this should atleast get flushed before we modify the irq destination
information.

With this patch however, unmask happens immediately.

> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index ad33e01..435c195 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -94,6 +94,7 @@ static void msi_set_mask_bit(unsigned int irq, int flag)
>  		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
>  			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
>  		writel(flag, entry->mask_base + offset);
> +		readl(entry->mask_base + offset);

Don't we need the flush for the PCI_CAP_ID_MSI case aswell.

thanks,
suresh
