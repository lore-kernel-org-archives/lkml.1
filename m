Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXCKU7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXCKU7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932322AbXCKU7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:59:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60660
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932253AbXCKU7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:59:47 -0400
Date: Sun, 11 Mar 2007 13:59:46 -0700 (PDT)
Message-Id: <20070311.135946.28788670.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, ak@suse.com, holt@sgi.com,
       linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Sat, 10 Mar 2007 18:09:23 -0800 (PST)

> Page table pages have the characteristics that they are typically zero
> or in a known state when they are freed. This is usually the exactly
> same state as needed after allocation. So it makes sense to build a list
> of freed page table pages and then consume the pages already in use
> first. Those pages have already been initialized correctly (thus no
> need to zero them) and are likely already cached in such a way that
> the MMU can use them most effectively.

I'm going to make the radical declaration that it be perhaps often
better to always initialize page table chunks to all zeros on
allocation.

The reason is that every time I've monitored the allocation patterns
of these things on SMP, the page table chunks always get released on a
different cpu than where they were initialized.

It's precisely suboptimal for a workload that forks off a lot of
very short lived jobs, watch what happens during runs of lmbench's
lat_proc for example.

The allocator side just does nothing but emit L2 cache line ownership
transactions as the pte page is touched.  Especially on chips like
PowerPC where zero initialization is absurdly cheap, we can avoid all
of the cache line transfers if we just initialize it at allocation
time.

Look, I like this trick too, sparc and sparc64 were the first Linux
platforms to implement page table caching about 8 years ago, but
I'm wondering whether it really makes sense any more.

