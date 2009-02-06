Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZBFAun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZBFAun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZBFAud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:50:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38666 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbZBFAuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:50:32 -0500
Date: Fri, 6 Feb 2009 01:50:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090206005022.GA6803@elte.hu>
References: <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <Pine.LNX.4.64.0902051921150.30938@blonde.anvils> <498B4F1F.5070306@goop.org> <Pine.LNX.4.64.0902052046240.18431@blonde.anvils> <498B54A0.7040005@goop.org> <20090205215050.GB28097@elte.hu> <498B6325.1040401@goop.org> <20090205234241.GA14203@elte.hu> <498B7F7F.3090701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B7F7F.3090701@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> just the act of using PAE was measured to cause multi-percent slowdown 
>> in fork() and exec() latencies, etc. The pagetables are twice as large 
>> so is that really surprising?
>>   
>
> Is there a similar slowdown running the CPU in 32 vs 64 bit mode?  Or does 
> having more/wider registers mitigate it?

Yes, of course there's a slowdown on 64-bit kernels in fork() performance, 
mainly related to pte size.

Here's some numbers done with perfstat. The "fork" binary forks 256 times, 
waits for the child tasks and then exits. It is a 32-bit binary, statically 
linked - i.e. very similar layout and function on both 32-bit and 64-bit 
kernels.

The results (tabulated a bit, average result of 20 runs):

 $ perfstat -e -3,-4,-5 ./fork

  Performance counter stats for './fork':

        32-bit  32-bit-PAE     64-bit
     ---------  ----------  ---------
     27.367537   30.660090  31.542003  task clock ticks     (msecs)

          5785        5810       5751  pagefaults           (events)
           389         388        388  context switches     (events)
             4           4          4  CPU migrations       (events)
     ---------  ----------  ---------
                    +12.0%     +15.2%  overhead

So PAE is 12.0% slower (the overhead of double the pte size and three page 
table levels), and 64-bit is 15.2% slower (the extra overhead of having four 
page table levels added to the overhead of double the pte size).

Larger ptes do not come for free and the 64-bit instructions do not mitigate 
the cachemiss overhead and memory bandwidth cost.

	Ingo
