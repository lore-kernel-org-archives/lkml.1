Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbXEUKEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbXEUKEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbXEUKEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:04:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbXEUKEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:04:12 -0400
Date: Mon, 21 May 2007 12:03:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ray Lee <ray-lk@madrabbit.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-ID: <20070521100320.GA1801@elte.hu>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <2c0942db0705092252n13a6a79aq39f13fcfae534de2@mail.gmail.com> <4642C416.3000205@yahoo.com.au> <200705121446.04191.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705121446.04191.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> It turns out that fixing swap prefetch was not that hard to fix and 
> improve upon, and since Andrew hasn't dropped swap prefetch, instead 
> here are a swag of fixes and improvements, [...]

it's a reliable win on my testbox too:

 # echo 1 > /proc/sys/vm/swap_prefetch
 # ./sp_tester
 Ram 1019540000  Swap 4096564000
 Total ram to be malloced: 1529310000 bytes
 Starting first malloc of 764655000 bytes
 Starting 1st read of first malloc
 Touching this much ram takes 4393 milliseconds
 Starting second malloc of 764655000 bytes
 Completed second malloc and free
 Sleeping for 600 seconds
 Important part - starting reread of first malloc
 Completed read of first malloc
 Timed portion 30279 milliseconds

versus:

 # echo 0 > /proc/sys/vm/swap_prefetch
 # ./sp_tester
 [...]

 Timed portion 36605 milliseconds

i've repeated these tests to make sure it's a stable win and indeed it 
is:

   # swap-prefetch-on:

   Timed portion 29704 milliseconds

   # swap-prefetch-off:

   Timed portion 34863 milliseconds
 
Nice work Con!

A suggestion for improvement: right now swap-prefetch does a small bit 
of swapin every 5 seconds and stays idle inbetween. Could this perhaps 
be made more agressive (optionally perhaps), if the system is not 
swapping otherwise? If block-IO level instrumentation is needed to 
determine idleness of block IO then that is justified too i think.

Another suggestion: swap-prefetch seems to be doing all the right 
decisions in the sp_test.c case - so would it be possible to add 
statistics so that it could be verified how much of the swapped-in pages 
were indeed a 'hit' - and how many were recycled without them being 
reused? That could give a reliable, objective metric about how efficient 
swap-prefetch is in any workload.

	Ingo
