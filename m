Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZFEJfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZFEJfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZFEJfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:35:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbZFEJfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:35:25 -0400
Date: Fri, 5 Jun 2009 02:34:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ying.huang@intel.com, W.Li@Sun.COM,
       michaele@au1.ibm.com, mingo@elte.hu, heicars2@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-Id: <20090605023434.8a49d673.akpm@linux-foundation.org>
In-Reply-To: <4A28E3F8.5050908@linux.vnet.ibm.com>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	<20090602114402.951631599@linux.vnet.ibm.com>
	<20090602150324.c706b1d2.akpm@linux-foundation.org>
	<4A266546.5080601@linux.vnet.ibm.com>
	<4A26961E.7040207@linux.vnet.ibm.com>
	<20090604090839.GB7030@cr0.nay.redhat.com>
	<4A28E3F8.5050908@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jun 2009 11:23:04 +0200 Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> Amerigo Wang wrote:
> > On Wed, Jun 03, 2009 at 05:26:22PM +0200, Peter Oberparleiter wrote:
> >> Peter Oberparleiter wrote:
> >>> Andrew Morton wrote:
> >>>> On Tue, 02 Jun 2009 13:44:02 +0200
> >>>> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> >>>>> +	/* Duplicate gcov_info. */
> >>>>> +	active = num_counter_active(info);
> >>>>> +	dup = kzalloc(sizeof(struct gcov_info) +
> >>>>> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
> >>>> How large can this allocation be?
> >>> Hm, good question. Having a look at my test system, I see coverage data 
> >>> files of up to 60kb size. With counters making up the largest part of 
> >>> those, I'd guess the allocation size can be around ~55kb. I assume that 
> >>> makes it a candidate for vmalloc?
> >> A further run with debug output showed that the maximum size is
> >> actually around 4k, so in my opinion, there is no need to switch
> >> to vmalloc.
> > 
> > Unless you want virtually continious memory, you don't need to
> > bother vmalloc().
> > 
> > kmalloc() and get_free_pages() are all fine for this.
> 
> kmalloc() requires contiguous pages to serve an allocation request 
> larger than a single page. The longer a kernel runs, the more fragmented 
> the pool of free pages gets and the probability to find enough 
> contiguous free pages is significantly reduced.
> 
> In this case (having had a 3rd look), I found allocations of up to 
> ~50kb, so to be sure, I'll switch that particular allocation to vmalloc().

Well, vmalloc() isn't magic.  It can suffer internal fragmentation of
the fixed-sized virtual address arena.

Is it possible to redo the data structures so that the large array
isn't needed?  Use a list, or move the data elsewhere or such?

