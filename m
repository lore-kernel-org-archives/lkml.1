Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYCQRdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYCQRdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYCQRd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:33:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34218 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184AbYCQRd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:33:26 -0400
Date: Mon, 17 Mar 2008 10:32:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205740204.3215.520.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803171027450.7359@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang> <1205465447.3215.195.camel@ymzhang> 
 <Pine.LNX.4.64.0803132333020.24204@schroedinger.engr.sgi.com> 
 <1205479398.3215.284.camel@ymzhang>  <Pine.LNX.4.64.0803141400170.28115@schroedinger.engr.sgi.com>
 <1205740204.3215.520.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Zhang, Yanmin wrote:

> slub_min_objects	                                   | 8      |   16   |   32   |  64
> --------------------------------------------------------------------------------------------
> slab(__slab_alloc+__slab_free+add_partial) cpu utilization | 88.00% | 44.00% | 13.00% | 12%
> 
> 
> When slub_min_objects=32, we could get a reasonable value. Beyond 32, the improvement
> is very small. 32 is just possible_cpu_number*2 on my tigerton.

Interesting. What is the optimal configuration for your 8p? Could you 
figure out the optimal configuration for an 4p and a 2p configuration?

> It's hard to say hackbench simulates real applications closely. But it discloses a possible
> performance bottlebeck. Last year, we once captured the kmalloc-2048 issue by tbench. So the
> default slub_min_objects need to be revised. In the other hand, slab is allocated by alloc_page
> when its size is equal to or more than a half page, so enlarging slub_min_objects won't create
> too many slab page buffers.
> 
> As for NUMA, perhaps we could define slub_min_objects to 2*max_cpu_number_per_node.

Well for a 4k cpu configu this would set min_objects to 8192. So I think 
we could implement a form of logarithmic scaling based on cpu 
counts comparable to what is done for the statistics update in vmstat.c

fls(num_online_cpus()) = 4

So maybe

slub_min_objects= 8 + (2 + fls(num_online_cpus())) * 4
