Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbYD2OZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbYD2OZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYD2OZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:25:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYD2OZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:25:40 -0400
Date: Tue, 29 Apr 2008 16:25:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [patch] mm: node-setup agnostic free_bootmem()
Message-ID: <20080429142520.GE26461@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de> <20080427234630.GC14338@elte.hu> <877iein859.fsf@saeurebad.de> <20080428004046.GA16155@elte.hu> <87skx56i23.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skx56i23.fsf@saeurebad.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> >  void __init free_bootmem(unsigned long addr, unsigned long size)
> >  {
> >  	bootmem_data_t *bdata;
> > -	list_for_each_entry(bdata, &bdata_list, list)
> > -		free_bootmem_core(bdata, addr, size);
> > +	unsigned long pos = addr;
> > +	unsigned long partsize = size;
> > +
> > +	list_for_each_entry(bdata, &bdata_list, list) {
> > +		unsigned long remainder = 0;
> > +
> > +		if (pos < bdata->node_boot_start)
> > +			continue;
> > +
> > +		if (PFN_DOWN(pos + partsize) > bdata->node_low_pfn) {
> > +			remainder = PFN_DOWN(pos + partsize) - bdata->node_low_pfn;
> > +			partsize -= remainder;
> > +		}
> > +
> > +		free_bootmem_core(bdata, pos, partsize);
> > +
> > +		if (!remainder)
> > +			return;
> > +
> > +		pos = PFN_PHYS(bdata->node_low_pfn + 1);
> > +	}
> > +	printk(KERN_ERR "free_bootmem: request: addr=%lx, size=%lx, "
> > +			"state: pos=%lx, partsize=%lx\n", addr, size,
> > +			pos, partsize);
> > +	BUG();
> >  }
> >  
> >  unsigned long __init free_all_bootmem(void)
> 
> Yes, looks good.  But needs explicit testing, I guess.

yep, but as Yinghai Lu has pointed it out, this removes a cross-node 
allocation fix. That fix has to be preserved in any cleanup, agreed?

in general bootmem should assume the weirdest of NUMA topologies and be 
defensive about them. Topologies will only become more complex, never 
less complex.

	Ingo
