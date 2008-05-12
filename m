Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbYELJVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbYELJVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYELJVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:21:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbYELJVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:21:38 -0400
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, vatsa@linux.vnet.ibm.com,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1210583090.7402.4.camel@marge.simson.net>
References: <20080506115207.GA24862@linux.vnet.ibm.com>
	 <20080507173357.GA4424@linux.vnet.ibm.com>
	 <1210223914.3453.102.camel@ymzhang>
	 <20080508054047.GD32729@linux.vnet.ibm.com>
	 <1210226013.3453.113.camel@ymzhang>
	 <20080508061125.GC3644@linux.vnet.ibm.com>
	 <20080509155240.GH3612@linux.vnet.ibm.com>
	 <1210556351.3151.2.camel@ymzhang>
	 <20080512023758.GN3612@linux.vnet.ibm.com>
	 <1210563200.3151.10.camel@ymzhang>
	 <20080512045246.GP3612@linux.vnet.ibm.com>
	 <1210568533.3151.13.camel@ymzhang>
	 <1210583090.7402.4.camel@marge.simson.net>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 May 2008 11:20:47 +0200
Message-Id: <1210584047.6524.12.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-12 at 11:04 +0200, Mike Galbraith wrote:
> On Mon, 2008-05-12 at 13:02 +0800, Zhang, Yanmin wrote:
> 
> > A quick update:
> > With 2.6.26-rc2 (﻿CONFIG_USER_SCHED=y), volanoMa﻿rk result on my 8-core stoakley
> > is about 10% worse than the one of 2.6.26-rc1.
> 
> Here (Q6600), 2.6.26-rc2 ﻿CONFIG_USER_SCHED=y regression culprit for
> volanomark is the same one identified for mysql+oltp.
> 
> (i have yet to figure out where the buglet lies, but there is definitely
> one in there somewhere)
> 
> 2.6.25.3-smp (baseline, no group scheduling)
> test-1.log:Average throughput = 102412 messages per second
> test-2.log:Average throughput = 99636 messages per second
> test-3.log:Average throughput = 99373 messages per second
> 
> CONFIG_CGROUPS=n
> CONFIG_USER_SCHED=y
> 
> 2.6.26-rc2 - 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> test-1.log:Average throughput = 102341 messages per second
> test-2.log:Average throughput = 101710 messages per second
> test-3.log:Average throughput = 100572 messages per second
> 
> 
> 2.6.26-rc2 + 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> test-1.log:Average throughput = 79506 messages per second
> test-2.log:Average throughput = 78168 messages per second
> test-3.log:Average throughput = 78200 messages per second

> CONFIG_CGROUPS=y
> CONFIG_CGROUP_SCHED=y
> 
> 2.6.26-rc2 - 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> test-1.log:Average throughput = 103026 messages per second
> test-2.log:Average throughput = 101152 messages per second
> test-3.log:Average throughput = 102616 messages per second
> 
> 2.6.26-rc2 + 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> test-1.log:Average throughput = 104174 messages per second
> test-2.log:Average throughput = 101390 messages per second
> test-3.log:Average throughput = 101212 messages per second
> 
> (but there are no task groups set up...)

Yeah, I expect that when you create some groups and move everything down
1 level you'll get into the same problems as with user grouping.

The thing seems to be that rq weights shrink to < 1 task level in these
situations - because its spreading 1 tasks (well group) worth of load
over the various CPUs.

We're going through the load balance code atm to find out where the
small load numbers would affect decisions.

It looks like things like find_busiest_group() just think everything is
peachy when the imbalance is < 1 task - which with all this grouping
stuff is not necessarily true.

