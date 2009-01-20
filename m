Return-Path: <linux-kernel-owner+w=401wt.eu-S1761911AbZATTcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbZATTcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZATTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:31:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbZATTbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:31:50 -0500
Date: Tue, 20 Jan 2009 20:31:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120193128.GA21481@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <1232478318.16317.160.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232478318.16317.160.camel@bodhitayantram.eng.vmware.com>
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


* Zachary Amsden <zach@vmware.com> wrote:

> On Tue, 2009-01-20 at 03:26 -0800, Ingo Molnar wrote:
> 
> > Jeremy, any ideas where this slowdown comes from and how it could be 
> > fixed?
> 
> Well I'm early responding to this thread before reading on, but I looked 
> at the generated assembly for some common mm paths and it looked awful. 
> The biggest loser was probably having functions to convert pte_t back 
> and forth to pteval_t, which makes most potential mask / shift 
> optimizations impossible - indeed, because the compiler doesn't even 
> understand pte_val(X) = Y is static over the lifetime of the function, 
> it often calls these same conversions back and forth several times, and 
> because this is often done inside hidden macros, it's not even possible 
> to save a cached value in most places.
> 
> The bulk of state required to keep this extra conversion around ties up 
> a lot of registers and as a result heavily limits potential further 
> optimizations.
> 
> The code did not look more branchy to me, however, and gcc seemed to do 
> a good job with lining up a nice branch structure in the few paths I 
> looked at.

i've extended my mmap test with branch execution hw-perfcounter stats:

 -----------------------------------------------
 | Performance counter stats for './mmap-perf' |
 -----------------------------------------------
 |                |
 |  x86-defconfig |   PARAVIRT=y
 |------------------------------------------------------------------
 |
 |    1311.554526 |  1360.624932  task clock ticks (msecs)    +3.74%
 |                |
 |              1 |            1  CPU migrations
 |             91 |           79  context switches
 |          55945 |        55943  pagefaults
 |    ............................................
 |     3781392474 |   3918777174  CPU cycles                  +3.63%
 |     1957153827 |   2161280486  instructions               +10.43%
 |       50234816 |     51303520  cache references            +2.12%
 |        5428258 |      5583728  cache misses                +2.86%
 |
 |      437983499 |    478967061  branches                    +9.36%
 |       32486067 |     32336874  branch-misses               -0.46%
 |                |
 |    1314.782469 |  1363.694447  time elapsed (msecs)        +3.72%
 |                |
 -----------------------------------

So we execute 9.36% more branches - i.e. very noticeably higher as well. 

The CPU predicts them slightly more effectively though, the -0.46% for 
branch-misses is well above measurement noise (of ~0.02% for the branch 
metric) so it's a systematic effect.

Non-functional 'boring' bloat tends to be easier to predict so it's not 
necessarily a real surprise. That also explains why despite +10.43% more 
instructions the total cycle count went up by a comparatively smaller 
+3.63%.

[ that's 64-bit x86 btw. ]

	Ingo
