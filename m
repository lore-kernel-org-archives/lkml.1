Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYGJMjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYGJMjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYGJMjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:39:01 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:18221 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYGJMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:39:00 -0400
X-BigFish: VPS-40(zz1432R98dR7efV1805M179dR10d1I873fnzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K3SJ4K-04-DUN-01
Date: Thu, 10 Jul 2008 14:37:47 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 14/34] AMD IOMMU: clue initialization code together
Message-ID: <20080710123747.GK14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-15-git-send-email-joerg.roedel@amd.com> <20080709185512.6355159c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709185512.6355159c.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 12:37:47.0488 (UTC) FILETIME=[C2191600:01C8E289]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 06:55:12PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 21:27:50 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch puts the AMD IOMMU ACPI table parsing and hardware initialization
> > functions together to the main intialization routine.
> > 
> > index 555fcc9..c792ddc 100644
> > --- a/arch/x86/kernel/amd_iommu_init.c
> > +++ b/arch/x86/kernel/amd_iommu_init.c
> > @@ -643,3 +643,129 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
> >  	return 0;
> >  }
> >  
> > +int __init amd_iommu_init(void)
> > +{
> > +	int i, ret = 0;
> > +
> > +
> > +	if (amd_iommu_disable) {
> > +		printk(KERN_INFO "AMD IOMMU disabled by kernel command line\n");
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * First parse ACPI tables to find the largest Bus/Dev/Func
> > +	 * we need to handle. Upon this information the shared data
> > +	 * structures for the IOMMUs in the system will be allocated
> > +	 */
> > +	if (acpi_table_parse("IVRS", find_last_devid_acpi) != 0)
> > +		return -ENODEV;
> > +
> > +	dev_table_size     = TBL_SIZE(DEV_TABLE_ENTRY_SIZE);
> > +	alias_table_size   = TBL_SIZE(ALIAS_TABLE_ENTRY_SIZE);
> > +	rlookup_table_size = TBL_SIZE(RLOOKUP_TABLE_ENTRY_SIZE);
> > +
> > +	ret = -ENOMEM;
> > +
> > +	/* Device table - directly used by all IOMMUs */
> > +	amd_iommu_dev_table = (void *)__get_free_pages(GFP_KERNEL,
> > +				      get_order(dev_table_size));
> 
> Is there a reason for using __get_free_pages() in this manner everywhere? 
> kmalloc() or kzalloc() are unsuitable?

Yes. The device table has to be page aligned and has a maximum size of
2 MB. 

> > +	if (amd_iommu_dev_table == NULL)
> > +		goto out;
> > +
> > +	/*
> > +	 * Alias table - map PCI Bus/Dev/Func to Bus/Dev/Func the
> > +	 * IOMMU see for that device
> > +	 */
> > +	amd_iommu_alias_table = (void *)__get_free_pages(GFP_KERNEL,
> > +			get_order(alias_table_size));

Hmm, maybe this table will fit into a kmalloc allocation. Its maximum
size is 128 kb.

> > +	if (amd_iommu_alias_table == NULL)
> > +		goto free;
> > +
> > +	/* IOMMU rlookup table - find the IOMMU for a specific device */
> > +	amd_iommu_rlookup_table = (void *)__get_free_pages(GFP_KERNEL,
> > +			get_order(rlookup_table_size));
> > +	if (amd_iommu_rlookup_table == NULL)
> > +		goto free;
> > +
> > +	/*
> > +	 * Protection Domain table - maps devices to protection domains
> > +	 * This table has the same size as the rlookup_table
> > +	 */
> > +	amd_iommu_pd_table = (void *)__get_free_pages(GFP_KERNEL,
> > +				     get_order(rlookup_table_size));

The rlookup and the pd table have a maximum size of 1 MB.

> > +	if (amd_iommu_pd_table == NULL)
> > +		goto free;
> > +
> > +	amd_iommu_pd_alloc_bitmap = (void *)__get_free_pages(GFP_KERNEL,
> > +					    get_order(MAX_DOMAIN_ID/8));
> > +	if (amd_iommu_pd_alloc_bitmap == NULL)
> > +		goto free;
> > +
> > +	/*
> > +	 * memory is allocated now; initialize the device table with all zeroes
> > +	 * and let all alias entries point to itself
> > +	 */
> > +	memset(amd_iommu_dev_table, 0, dev_table_size);
> > +	for (i = 0; i < amd_iommu_last_bdf; ++i)
> > +		amd_iommu_alias_table[i] = i;
> > +
> > +	memset(amd_iommu_pd_table, 0, rlookup_table_size);
> > +	memset(amd_iommu_pd_alloc_bitmap, 0, MAX_DOMAIN_ID / 8);
> 
> Use of __GFP_ZERO in here would relieve us of a lot of memsets.
> 
> > +	/*
> > +	 * never allocate domain 0 because its used as the non-allocated and
> > +	 * error value placeholder
> > +	 */
> > +	amd_iommu_pd_alloc_bitmap[0] = 1;
> > +
> > +	/*
> > +	 * now the data structures are allocated and basically initialized
> > +	 * start the real acpi table scan
> > +	 */
> > +	ret = -ENODEV;
> > +	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
> > +		goto free;
> > +
> > +	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
> > +		goto free;
> > +
> > +	printk(KERN_INFO "AMD IOMMU: aperture size is %d MB\n",
> > +			(1 << (amd_iommu_aperture_order-20)));
> > +
> > +	printk(KERN_INFO "AMD IOMMU: device isolation ");
> > +	if (amd_iommu_isolate)
> > +		printk("enabled\n");
> > +	else
> > +		printk("disabled\n");
> > +
> > +out:
> > +	return ret;
> > +
> > +free:
> > +	if (amd_iommu_pd_alloc_bitmap)
> > +		free_pages((unsigned long)amd_iommu_pd_alloc_bitmap, 1);
> > +
> > +	if (amd_iommu_pd_table)
> > +		free_pages((unsigned long)amd_iommu_pd_table,
> > +				get_order(rlookup_table_size));
> > +
> > +	if (amd_iommu_rlookup_table)
> > +		free_pages((unsigned long)amd_iommu_rlookup_table,
> > +				get_order(rlookup_table_size));
> > +
> > +	if (amd_iommu_alias_table)
> > +		free_pages((unsigned long)amd_iommu_alias_table,
> > +				get_order(alias_table_size));
> > +
> > +	if (amd_iommu_dev_table)
> > +		free_pages((unsigned long)amd_iommu_dev_table,
> > +				get_order(dev_table_size));
> 
> free_pages(0) is legal, so all these tests are unneeded, I expect.
> 
> This remains true if you decide to switch to kzalloc().

Thanks for that hint. I will remove the checks.

> > +	free_iommu_all();
> > +
> > +	free_unity_maps();
> > +
> > +	goto out;
> > +}
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

