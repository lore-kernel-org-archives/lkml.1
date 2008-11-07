Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYKGU0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYKGU0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYKGU0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:26:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:39978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYKGU0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:26:34 -0500
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mayhar <fmayhar@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1226081448.28191.64.camel@bobble.smo.corp.google.com>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins>
	 <Pine.LNX.4.64.0811060900450.3595@quilx.com>
	 <1225984098.7803.4642.camel@twins>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>
	 <1226081448.28191.64.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 21:26:14 +0100
Message-Id: <1226089574.31966.85.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, so how about going about this differently.

How about we group the threads per cpu, and appoint one the cpu-leader
and collect the per cpu sum in there.

Then, on tick time we sum the cpu-leaders to obtain the total.

This would require finding the cpu-leader for any particular cpu, which
for example, we could do by maintaining a rb-tree ordered on cpu. If you
find an entry, its the leader and you store a pointer to it, if its
empty, insert yourself.

We'd have to update this whenever a task migrates.

When the cpu-leader migrates it can hand off its sum to the cpu-leader
of the target cpu (assuming there is one, otherwise it will again be
cpu-leader).

The advantage is that the memory foot-print scales with nr_tasks and the
runtime cost is min(nr_tasks, nr_cpus) where nr_cpus is limited to the
cpus the process actually runs on, so this takes full advantage of
things like cpusets.



