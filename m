Return-Path: <linux-kernel-owner+w=401wt.eu-S1423193AbXDXW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423193AbXDXW3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423184AbXDXW3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:29:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:14569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423170AbXDXW2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:28:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233351517:sNHT56817173"
Date: Tue, 24 Apr 2007 15:26:57 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: David Miller <davem@davemloft.net>, ashok.raj@intel.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Message-ID: <20070424222656.GA3317@linux-os.sc.intel.com>
References: <200704242312.54738.ak@suse.de> <20070424213835.GB31920@linux-os.sc.intel.com> <20070424.145026.128110905.davem@davemloft.net> <200704250003.57968.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704250003.57968.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 12:03:57AM +0200, Andi Kleen wrote:
> On Tuesday 24 April 2007 23:50:26 David Miller wrote:
> > From: Ashok Raj <ashok.raj@intel.com>
> > Date: Tue, 24 Apr 2007 14:38:35 -0700
> > 
> > > Its not clear if we have a very generic device breakage.. most devices
> > > on these platforms are going to be more recent, (except maybe some
> > > legacy fd)... 
> > 
> > I'm not so sure, there are some "modern" sound cards that have
> > a 31-bit DMA addressing limitation because they use the 31st
> > bit as a status bit in their DMA descriptors :-)
> 
> There's also a 2GB only megaraid RAID controller that's pretty popular 
> because Dell shipped it for a long time.

Sounds like we have quite a few of those weird ones!

The real question is whats the working set for mapped dma handles for such
a controller. They would typically allocate only a few to what the controller
could handle, and would submit when the io completes right.. So typically
we shouldnt have any trouble since they would be able to reclaim what they
freed before submission (for iova).

Having a IOVA requirement in 2g etc is not a problem, except how many devices
on the same pci bus and what the total working set for iova is for that config.

The only way to gaurantee would be for the device to ask for a gauranteed set
maybe during pci_set_dma_mask() or some such time, and pre-reserve some
IOVA to gaurantee we never run out. BUt this is again driver changes and 
wont be fair if some driver is greedy.
