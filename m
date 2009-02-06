Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZBFH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZBFH5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZBFH44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:56:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:59351 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZBFH4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:56:55 -0500
Subject: Re: [PATCH 0/16] DMA-API debugging facility v2
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090206020535.GE27684@sequoia.sous-sol.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
	 <1233874352.8135.12.camel@macbook.infradead.org>
	 <20090206020535.GE27684@sequoia.sous-sol.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Feb 2009 07:56:46 +0000
Message-Id: <1233907006.17724.83.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 18:05 -0800, Chris Wright wrote:
> extra tab

Thanks. Your code to hook it up is better than mine too. I'll steal
that.

> Sample output below (2 of ~2500 faults), pages don't appear to be
> mapped:

What machine did you get that on?

Yeah, I saw one of those. If could be a driver bug, of course -- it
could be unmapping a range before it's actually finished with it. But
that's unlikely.

An alternative explanation... The DMA is aborted¹, and the device
interrupts us to tell us about it at the _same_ time that the IOMMU
interrupts us to tell us about the fault. We process the device
interrupt first, unmap that buffer. And then we process the IOMMU
interrupt... and the buffer is already gone from the list.

It might be interesting to make this code also remember and print the
last range that was unmapped, as well as the currently-mapped ranges.

> (interesting hash_fn spread ;-)

Yeah, that's a little suboptimal, isn't it :)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

¹ due to the bug we're chasing now. The range _is_ supposed to be mapped.

