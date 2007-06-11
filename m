Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXFKVPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXFKVPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbXFKVPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:15:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbXFKVPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:15:04 -0400
Date: Mon, 11 Jun 2007 14:14:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool
 handling
Message-Id: <20070611141449.bfbc4769.akpm@linux-foundation.org>
In-Reply-To: <20070611204442.GA4074@linux-os.sc.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<200706090056.49279.ak@suse.de>
	<Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
	<200706091147.24705.ak@suse.de>
	<20070611204442.GA4074@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 13:44:42 -0700
"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> In the first implementation of ours, we had used mempools api's to 
> allocate memory and we were told that mempools with GFP_ATOMIC is
> useless and hence in the second implementation we came up with
> resource pools ( which is preallocate pools) and again as I understand
> the argument is why create another when we have slab allocation which
> is similar to this resource pools.

Odd.  mempool with GFP_ATOMIC is basically equivalent to your
resource-pools, isn't it?: we'll try the slab allocator and if that failed,
fall back to the reserves.

It's missing the recharge-from-a-kernel-thread functionality but that can be
added easily enough if it's useful.  It's slightly abusive of the mempool
philosophy, but it's probably better to do that than to create a new and
very-similar thing.

> Hence, can I assume that the conclusion of this 
> discussion is to use kmem_cache_alloc() functions 
> to allocate memory in dma_map_{single|sg} API's?
> 
> Again, if dma_map_{single|sg} API's fails due to 
> failure to allocate memory, the only thing that can
> be done is to panic as this is what few of the other 
> IOMMU implementation is doing today. 

If the only option is to panic then something's busted.  If it's network IO
then there should be a way of dropping the frame.  If it's disk IO then we
should report the failure and cause an IO error.

