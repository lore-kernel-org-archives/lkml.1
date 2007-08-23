Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbXHWRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbXHWRWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbXHWRWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:22:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:64120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbXHWRW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:22:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,301,1183359600"; 
   d="scan'208";a="282941984"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Date: Thu, 23 Aug 2007 10:22:26 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023EB020@scsmsx411.amr.corp.intel.com>
In-reply-to: <20070823221005.0D76.Y-GOTO@jp.fujitsu.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Thread-Index: AcfliW9QeKD/8hjzSPWjtwEHg/nE8QAHy4zQ
References: <617E1C2C70743745A92448908E030B2A023B2FD5@scsmsx411.amr.corp.intel.com> <20070823091556.GA18456@skynet.ie> <20070823221005.0D76.Y-GOTO@jp.fujitsu.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Yasunori Goto" <y-goto@jp.fujitsu.com>, "Mel Gorman" <mel@skynet.ie>
Cc: "Jeremy Higdon" <jeremy@sgi.com>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 23 Aug 2007 17:22:27.0707 (UTC) FILETIME=[2DB02CB0:01C7E5AA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> __get_free_pages() of swiotlb_alloc_coherent() fails in rc3-mm1.
> But, it doesn't fail on rc2-mm2, and kernel can boot up.

That looks to be part of the problem here ... failing an order=3
allocation during boot on a system that just a few lines earlier
in the boot log reported "Memory: 37474000k/37680640k available"
looks bad ... but perhaps having *more* memory is part of your problem.
You may have run low on GFP_DMA memory because some allocation
scaled by memory size has chewed up a lot of your memory.  To check
this try booting with a "mem=4G" parameter and see if that helps
you.

But it is also bad that the swiotlb() code failed to handle this.
Can you check whether the problem is related to the size of the
allocation being just over 256K (a magic number for swiotlb since
IO_TLB_SEGSIZE is 128 times a slab size of 2k).  Try changing
lib/swiotlb.c to set IO_TLB_SEGSIZE to 256 instead.

-Tony
