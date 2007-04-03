Return-Path: <linux-kernel-owner+w=401wt.eu-S966120AbXDCTke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966120AbXDCTke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966188AbXDCTke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:40:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38961 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966120AbXDCTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:40:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       "Williams, Mitch A" <mitch.a.williams@intel.com>
Subject: Re: [PATCH] msi: Immediately mask and unmask msi-x irqs.
References: <08FE5CC30C9A3F41BF819A502CF7BF6E0100376E@fmsmsx411.amr.corp.intel.com>
	<m1lkh9dhvm.fsf@ebiederm.dsl.xmission.com>
	<20070403185219.GB15704@linux-os.sc.intel.com>
Date: Tue, 03 Apr 2007 13:39:43 -0600
In-Reply-To: <20070403185219.GB15704@linux-os.sc.intel.com> (Suresh
	B. Siddha's message of "Tue, 3 Apr 2007 11:52:19 -0700")
Message-ID: <m18xd9ckn4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> set_msi_irq_affinity() is already doing read_msi_msg(). So the mask operation
> before this should atleast get flushed before we modify the irq destination
> information.

We modify irq reception information in assign_irq_vector, before that.
With my latest delayed free of irq reception information this is less
of an issue.

Further now that we cache the msi message that read_msi_msg should go
away and we should use the cached version from the msi_desc.

> With this patch however, unmask happens immediately.

Yes unmask happens immediately as well.  Just as with Mitch Williams
last patch, and just like we expect.  Further mask/unmask should not be
called that often so there is no point in micro optimizing them.  At
least not until some screams they are a performance problem.

>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index ad33e01..435c195 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -94,6 +94,7 @@ static void msi_set_mask_bit(unsigned int irq, int flag)
>>  		int offset = entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE +
>>  			PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET;
>>  		writel(flag, entry->mask_base + offset);
>> +		readl(entry->mask_base + offset);
>
> Don't we need the flush for the PCI_CAP_ID_MSI case aswell.

At least the 3.0 pci spec does not allow pci configuration access to
be posted.  So unless we find some hardware that actually does post
pci configuration writes we should be ok.

If we do find that hardware that posts pci config writes I expect we
will make pci config writes non posted in the generic linux pci config
functions, and only an optimized set of pci accessors functions for
drivers that really know what they are doing will export the posted
behavior.

Eric
