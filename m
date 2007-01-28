Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbXA1SnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbXA1SnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 13:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXA1SnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 13:43:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbXA1SnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 13:43:01 -0500
Date: Sun, 28 Jan 2007 19:41:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070128184116.GA12150@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128144325.GB16552@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 12:51:18PM +0100, Peter Zijlstra wrote:
> > This patch-set breaks up the global file_list_lock which was found to be a
> > severe contention point under basically any filesystem intensive workload.
> 
> Benchmarks, please.  Where exactly do you see contention for this?

the following very simple workload:

   http://redhat.com/~mingo/file-ops-test/file-ops-test.c

starts one process per CPU and open()s/close()s a file all over again, 
simulating an open/close-intense workload. This pattern is quite typical 
of several key Linux applications.

Using Peter's s_files patchset the following scalability improvement can 
be measured (lower numbers are better):

 ----------------------------------------------------------------------
                  v2.6.20-rc6     |   v2.6.20-rc6+Peter's s_files queue
 ----------------------------------------------------------------------
 dual-core:       2.11 usecs/op   |   1.51 usecs/op     (  +39.7% win )
 8-socket:        6.30 usecs/op   |   2.70 usecs/op     ( +233.3% win )

[ i'd expect something a 64-way box to improve its open/close 
  scalability dramatically, factor 10x or 20x better. On a 1024-CPU (or 
  4096-CPU) system the effects are very likely even more dramatic. ]

Why does this patch make such a difference? Not because the critical 
section is in any way contended - it isnt, we only do a simple list 
operation there. But this lock is touched in every sys_open() and 
sys_close() system-call, so it is a high-frequency accessed cacheline. 
The cost is there due to the global cacheline ping-pong of files_lock. 
Furthermore, in this very important VFS codepath this is the 'last' 
global cacheline that got eliminated, hence all the scalability benefits 
(of previous improvements) get reaped all at once.

Now could you please tell me why i had to waste 3.5 hours on measuring 
and profiling this /again/, while a tiny little bit of goodwill from 
your side could have avoided this? I told you that we lock-profiled this 
under -rt, and that it's an accurate measurement of such things - as the 
numbers above prove it too. Would it have been so hard to say something 
like: "Cool Peter! That lock had been in our way of good open()/close() 
scalability for such a long time and it's an obviously good idea to 
eliminate it. Now here's a couple of suggestions of how to do it even 
simpler: [...]." Why did you have to in essence piss on his patchset? 
Any rational explanation?

	Ingo
