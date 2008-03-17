Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYCQICh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYCQICh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYCQICV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:02:21 -0400
Received: from mga10.intel.com ([192.55.52.92]:65137 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752579AbYCQICU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:02:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,511,1199692800"; 
   d="scan'208";a="534985721"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803141400170.28115@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313014808.f8d25c2a.akpm@linux-foundation.org>
	 <1205400538.3215.148.camel@ymzhang>
	 <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
	 <1205463842.3215.188.camel@ymzhang> <1205465447.3215.195.camel@ymzhang>
	 <Pine.LNX.4.64.0803132333020.24204@schroedinger.engr.sgi.com>
	 <1205479398.3215.284.camel@ymzhang>
	 <Pine.LNX.4.64.0803141400170.28115@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 17 Mar 2008 15:50:04 +0800
Message-Id: <1205740204.3215.520.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 14:06 -0700, Christoph Lameter wrote:
> On Fri, 14 Mar 2008, Zhang, Yanmin wrote:
> 
> > On my 8-core stoakley, there is no such regression. Below data is after 
> > testing.
> 
> I was looking for the details on two slab caches. The comparison of the 
> details statistics is likely very interesting because we will be able to
> see how the doubling of processor counts affects the internal behavior of 
> slub.
I collected more data on 16-p tigerton to try to find the possible relationship
between slub_min_objects and processor number. Kernel is 2.6.25-rc5.

Command\slub_min_objects	|	slub_min_objects=8  |   16  |   32   |  64
-------------------------------------------------------------------------------------
./hackbench 100 process 2000    |  		250second   |	23  |   18.6 |  17.5
./hackbench 200 process 2000	|	      	532         |	44  |   35.6 |  33.5

                                
The first command line will start 4000 processes and the second will start 8000 processes.

As the problemtic slab is kmalloc-512, slub_min_objects=8 is just the default configuration.

Oprofile data shows the ratio of __slab_alloc+__slab_free+add_partial has no difference
between the 2 commandline with the same kernel boot parameters.


slub_min_objects	                                   | 8      |   16   |   32   |  64
--------------------------------------------------------------------------------------------
slab(__slab_alloc+__slab_free+add_partial) cpu utilization | 88.00% | 44.00% | 13.00% | 12%


When slub_min_objects=32, we could get a reasonable value. Beyond 32, the improvement
is very small. 32 is just possible_cpu_number*2 on my tigerton.

It's hard to say hackbench simulates real applications closely. But it discloses a possible
performance bottlebeck. Last year, we once captured the kmalloc-2048 issue by tbench. So the
default slub_min_objects need to be revised. In the other hand, slab is allocated by alloc_page
when its size is equal to or more than a half page, so enlarging slub_min_objects won't create
too many slab page buffers.

As for NUMA, perhaps we could define slub_min_objects to 2*max_cpu_number_per_node.

-yanmin


