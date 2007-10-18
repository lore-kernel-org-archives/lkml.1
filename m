Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbXJREcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbXJREcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbXJREcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:32:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40587 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXJREcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:32:35 -0400
Date: Thu, 18 Oct 2007 10:02:37 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [patch 2/3] Introduce BOOTMEM_EXCLUSIVE
Message-ID: <20071018043237.GA8779@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20071016162857.635479952@strauss.suse.de> <20071016162858.545617122@strauss.suse.de> <20071017110550.GB17565@in.ibm.com> <20071017113651.GA6963@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017113651.GA6963@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 01:36:51PM +0200, Bernhard Walle wrote:
[..]
> > > +static int __init reserve_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
> > > +					unsigned long size, int flags)
> > >  {
> > >  	unsigned long sidx, eidx;
> > >  	unsigned long i;
> > > @@ -133,7 +133,11 @@ static void __init reserve_bootmem_core(
> > >  #ifdef CONFIG_DEBUG_BOOTMEM
> > >  			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
> > >  #endif
> > > +			if (flags & BOOTMEM_EXCLUSIVE)
> > > +				return -EBUSY;
> > 
> > I think we should unreserve the chunks of memory we have reserved so
> > far (Memory reserved from sidx to i), in case of error.
> 
> Unfortunately, that's not possible without using a lock (or counters
> instead of a bitmap) any more. If we just do
> 
> 	for (i--; i >= sidx; i--)
> 		clear_bit(i, bdata->node_bootmem_map);
> 
> then another thread of execution could reserve the memory (without
> BOOTMEM_EXCLUSIVE) in between -- and the code would free the memory
> which is already reserved.
> 
> I think that could be modelled with a rwlock, not changing the default
> case where BOOTMEM_EXCLUSIVE is not specified.

SMP initialization takes place after bootmem allocator has retired. That
would mean only one thread will be using bootmem allocator. Hence I think
unreserving memory without any kind of locking should be safe.

Thanks
Vivek
