Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXFSXzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXFSXzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbXFSXzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:55:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:8367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbXFSXzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:55:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,440,1175497200"; 
   d="scan'208";a="98218992"
Date: Tue, 19 Jun 2007 16:50:46 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
Message-ID: <20070619235046.GA2228@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.716432000@askeshav-devel.jf.intel.com> <Pine.LNX.4.64.0706191627060.15951@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706191627060.15951@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 04:32:23PM -0700, Christoph Lameter wrote:
> On Tue, 19 Jun 2007, Keshavamurthy, Anil S wrote:
> 
> > +static inline void *alloc_pgtable_page(void)
> > +{
> > +	return (void *)get_zeroed_page(GFP_ATOMIC);
> > +}
> 
> Need to pass gfp_t parameter. Repeates a couple of times.
> 
> > +	addr &= (((u64)1) << addr_width) - 1;
> > +	parent = domain->pgd;
> > +
> > +	spin_lock_irqsave(&domain->mapping_lock, flags);
> > +	while (level > 0) {
> > +		void *tmp_page;
> > +
> > +		offset = address_level_offset(addr, level);
> > +		pte = &parent[offset];
> > +		if (level == 1)
> > +			break;
> > +
> > +		if (!dma_pte_present(*pte)) {
> > +			tmp_page = alloc_pgtable_page();
> 
> Is it not possible here to drop the lock and do the alloc with GFP_KERNEL 
> and deal with the resulting race? That is done in other parts of the 
> kernel.
> 
> > +/* iommu handling */
> > +static int iommu_alloc_root_entry(struct intel_iommu *iommu)
> > +{
> > +	struct root_entry *root;
> > +	unsigned long flags;
> > +
> > +	root = (struct root_entry *)alloc_pgtable_page();
> 
> This may be able to become a GFP_KERNEL alloc since interrupts are enabled 
> at this point?

Memory allocated during driver init is very less and not much benefit
with the suggested changes I think. Please correct me If I am wrong.

The biggest benifit will be when we can figure out GPF_XXXX flags
during runtime when DMA map api's are called. 
