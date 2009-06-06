Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZFFIbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZFFIbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZFFIbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:31:09 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50750 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZFFIbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:31:06 -0400
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
From: Michael Ellerman <michaele@au1.ibm.com>
Reply-To: michaele@au1.ibm.com
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ying.huang@intel.com, W.Li@Sun.COM, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
In-Reply-To: <4A28EF7D.5030704@linux.vnet.ibm.com>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	 <20090602114402.951631599@linux.vnet.ibm.com>
	 <20090602150324.c706b1d2.akpm@linux-foundation.org>
	 <4A266546.5080601@linux.vnet.ibm.com>	<4A26961E.7040207@linux.vnet.ibm.com>
	 <20090604090839.GB7030@cr0.nay.redhat.com>
	 <4A28E3F8.5050908@linux.vnet.ibm.com>
	 <20090605023434.8a49d673.akpm@linux-foundation.org>
	 <4A28EF7D.5030704@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 18:30:57 +1000
Message-Id: <1244277057.4277.7.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 12:12 +0200, Peter Oberparleiter wrote:
> Andrew Morton wrote:
> > On Fri, 05 Jun 2009 11:23:04 +0200 Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> > 
> >> Amerigo Wang wrote:
> >>> On Wed, Jun 03, 2009 at 05:26:22PM +0200, Peter Oberparleiter wrote:
> >>>> Peter Oberparleiter wrote:
> >>>>> Andrew Morton wrote:
> >>>>>> On Tue, 02 Jun 2009 13:44:02 +0200
> >>>>>> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> >>>>>>> +	/* Duplicate gcov_info. */
> >>>>>>> +	active = num_counter_active(info);
> >>>>>>> +	dup = kzalloc(sizeof(struct gcov_info) +
> >>>>>>> +		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
> >>>>>> How large can this allocation be?
> >>>>> Hm, good question. Having a look at my test system, I see coverage data 
> >>>>> files of up to 60kb size. With counters making up the largest part of 
> >>>>> those, I'd guess the allocation size can be around ~55kb. I assume that 
> >>>>> makes it a candidate for vmalloc?
> >>>> A further run with debug output showed that the maximum size is
> >>>> actually around 4k, so in my opinion, there is no need to switch
> >>>> to vmalloc.
> >>> Unless you want virtually continious memory, you don't need to
> >>> bother vmalloc().
> >>>
> >>> kmalloc() and get_free_pages() are all fine for this.
> >> kmalloc() requires contiguous pages to serve an allocation request 
> >> larger than a single page. The longer a kernel runs, the more fragmented 
> >> the pool of free pages gets and the probability to find enough 
> >> contiguous free pages is significantly reduced.
> >>
> >> In this case (having had a 3rd look), I found allocations of up to 
> >> ~50kb, so to be sure, I'll switch that particular allocation to vmalloc().
> > 
> > Well, vmalloc() isn't magic.  It can suffer internal fragmentation of
> > the fixed-sized virtual address arena.
> > 
> > Is it possible to redo the data structures so that the large array
> > isn't needed?  Use a list, or move the data elsewhere or such?
> 
> Unfortunately not - the format of the data is dictated by gcc. Any 
> attempt to break it down into page-sized chunks would only imitate what 
> vmalloc() already does.
> 
> Note though that this function is not called very often - it's only used 
> to preserve coverage data for modules which are unloaded. And I only saw 
> the 50kb counter data size for one file: kernel/sched.c (using a 
> debugging patch).

Isn't it also called from gcov_seq_open() ?

> So hm, I'm not sure about this anymore. I can also leave it at kmalloc() 
> - chances are slim that anyone will actually experience a problem and if 
> they do, they get an "order-n allocation failed" message so theres a 
> hint at the cause for the problem.

Why are we duping it anyway? Rather than allocating it in the beginning,
is it because gcc-generated code is writing directly to the original
copy?

If there's any chance of memory allocation failure it'd be preferable
for it to happen before the test run that generates the coverage data,
that way you know before hand that you are out of memory. Rather than
running some (possibly long & involved) test case, and then losing all
your data.

cheers

-- 
Michael Ellerman
OzLabs, LTC Prism Kernel Team

email: michaele@au.ibm.com
stime: ellerman@au1.ibm.com
notes: Michael Ellerman/Australia/IBM

