Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZKEFUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZKEFUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZKEFUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:20:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:49319 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750965AbZKEFUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:20:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+TG4QRgyCTy3eFBLgT40D9WrIWXy/aL2uE9Ghv13
	O8W0Ktbri/UV/Q
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, alex.shi@intel.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257387645.16282.66.camel@ymzhang>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
	 <1257222791.16282.46.camel@ymzhang>  <20091103174531.GA14747@elte.hu>
	 <1257299745.16282.49.camel@ymzhang>
	 <1257336461.16163.18.camel@marge.simson.net>
	 <1257387645.16282.66.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Nov 2009 06:20:17 +0100
Message-Id: <1257398417.6401.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 10:20 +0800, Zhang, Yanmin wrote:
> On Wed, 2009-11-04 at 13:07 +0100, Mike Galbraith wrote:

> > Can you try the below, and send me 
> I tested it on Nehalem machine against the latest tips kernel. netperf loopback
> result is good and regression disappears.

Excellent.  Ingo has picked up a version in tip (1b9508f) which has zero
negative effect on my x264 testcase, and is a win for mysql+oltp through
the whole test spectrum.  As that may (dunno, Ingo?) now be considered a
regression fix, ie candidate for 32.final, testing that it does no harm
to your big machines would be a good thing.  (pretty please?:)

> tbench result has no improvement.

Can you remind me where we stand on tbench?

> > your UDP-U-1k args so I can try it? 
> #taskset -c 0 ./netserver
> #taskset -c 15 ./netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -i 50 3 -I 99 5 -- -P 12384,12888 -s 32768 -S 32768 -m 4096
> 
> Pls. check /proc/cpuinfo to make sure cpu 0 and cpu 15 are not in the
> same physical cpu.

Thanks. My little box doesn't have a 15 (darn) so 0,3 will have to do.

> I also run sysbench(oltp)+mysql testing with thread number 14,16,18,20,32,64,128. The average
> number is good. If I compare every single result against 2.6.32-rc5's, I find thread number
> ﻿14,16,18,20,32's result are better than 2.6.32-rc5's, but 64,128's result are worse. 128's is
> the worst.

Hm.  That's disconcerting.  However, that patch isn't going anywhere but
to the bitwolf anyway (diagnostic).  If 1b9508f regresses, that will be
a problem.  With diag, my box also regressed at the tail.  Balancing a
bit seems to help mysql once it starts tripping all over itself, it
improves the decay curve markedly.  1b9508f does brief bursts of newidle
balancing when idle time climbs, which translated to a ~6% improvement
at 256 clients on my little quad.

	-Mike

