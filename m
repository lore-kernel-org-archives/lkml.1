Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZKEHne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZKEHne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZKEHnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:43:33 -0500
Received: from mga10.intel.com ([192.55.52.92]:60398 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbZKEHnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:43:32 -0500
X-ExtLoop1: 1
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, alex.shi@intel.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257398417.6401.27.camel@marge.simson.net>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
	 <1257222791.16282.46.camel@ymzhang>  <20091103174531.GA14747@elte.hu>
	 <1257299745.16282.49.camel@ymzhang>
	 <1257336461.16163.18.camel@marge.simson.net>
	 <1257387645.16282.66.camel@ymzhang>
	 <1257398417.6401.27.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Nov 2009 15:44:23 +0800
Message-Id: <1257407063.16282.89.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 06:20 +0100, Mike Galbraith wrote:
> On Thu, 2009-11-05 at 10:20 +0800, Zhang, Yanmin wrote:
> > On Wed, 2009-11-04 at 13:07 +0100, Mike Galbraith wrote:
> 
> > > Can you try the below, and send me 
> > I tested it on Nehalem machine against the latest tips kernel. netperf loopback
> > result is good and regression disappears.
> 
> Excellent.  Ingo has picked up a version in tip (1b9508f) which has zero
> negative effect on my x264 testcase, and is a win for mysql+oltp through
> the whole test spectrum.  As that may (dunno, Ingo?) now be considered a
> regression fix, ie candidate for 32.final, testing that it does no harm
> to your big machines would be a good thing.  (pretty please?:)
I tested the latest tips kernel which includes commit ﻿1b9508f.
Comparing with 2.6.31, netperf loopback UDP-U-4k has about 2% regression.

sysbench(oltp)+mysql result is pretty good, about 2% improvement than
2.6.31's.



> 
> > tbench result has no improvement.
> 
> Can you remind me where we stand on tbench?
I run tbench by starting CPU_NUM*2 tbench clients without cpu binding.
Comparing with 2.6.31, tbench has about 6% regression with 2.6.31-rc1 on Nehalem.
Mostly, it's caused by SD_PREFER_LOCAL and Peter already disables the flag for
MC and cpu domains. Your patch disables it for node domain.
With the current tips kernel, tbench has about 3% regression on 1 nahalem, and
less than 1% on another Nehalem.

With pure 2.6.32-rc6 kernel, tbench result has about 3~6% regression on Nehalem
, comparing with 2.6.32-rc5's. So some patches in tips haven't been merged into
upstream.

> 
> > > your UDP-U-1k args so I can try it? 
> > #taskset -c 0 ./netserver
> > #taskset -c 15 ./netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -i 50 3 -I 99 5 -- -P 12384,12888 -s 32768 -S 32768 -m 4096
> > 
> > Pls. check /proc/cpuinfo to make sure cpu 0 and cpu 15 are not in the
> > same physical cpu.
> 
> Thanks. My little box doesn't have a 15 (darn) so 0,3 will have to do.
Sorry. I copy it from the output of "ps -ef", so a couple of ',' are lost. The right netperf command
line is:
﻿#taskset -c 15 ./netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -P 12384,12888 -s 32768 -S 32768 -m 4096


> 
> > I also run sysbench(oltp)+mysql testing with thread number 14,16,18,20,32,64,128. The average
> > number is good. If I compare every single result against 2.6.32-rc5's, I find thread number
> > ﻿14,16,18,20,32's result are better than 2.6.32-rc5's, but 64,128's result are worse. 128's is
> > the worst.
> 
> Hm.  That's disconcerting.  However, that patch isn't going anywhere but
> to the bitwolf anyway (diagnostic).  If 1b9508f regresses, that will be
> a problem.  With diag, my box also regressed at the tail.  Balancing a
> bit seems to help mysql once it starts tripping all over itself, it
> improves the decay curve markedly.  1b9508f does brief bursts of newidle
> balancing when idle time climbs, which translated to a ~6% improvement
> at 256 clients on my little quad.
> 
> 	-Mike
> 

