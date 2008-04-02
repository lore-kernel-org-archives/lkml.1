Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYDBLOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYDBLOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYDBLOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:14:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34186 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753073AbYDBLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:14:09 -0400
Date: Wed, 2 Apr 2008 06:14:05 -0500
From: Paul Jackson <pj@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       andi@firstfloor.org
Subject: Re: [PATCH 1/2] Customize sched domain via cpuset
Message-Id: <20080402061405.197c0c90.pj@sgi.com>
In-Reply-To: <47F34625.6000600@jp.fujitsu.com>
References: <47F21BE3.5030705@jp.fujitsu.com>
	<20080401065534.a6267b96.pj@sgi.com>
	<47F34625.6000600@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi wrote:
> Put simply, if the system tend to be idle, then "push to idle" strategy
> works well.  OTOH if the system tend to be busy, then "pull by idle"
> strategy works well.  Else, both strategy will work but besides of all
> there is a question: how much searching cost can you pay?

So each flag has value in some cases ... that much seems reasonable to me.

But you're saying that you'd like to avoid having to turn on both, just to
get the benefit of one of them, in order to avoid the searching costs of
the other flag that was not valuable on that load, right?

But is this necessarily so?  If "pull by idle" is attempted on a system
which tends to be idle, then while it is true that the search for something
to pull will usually find nothing, what does it matter that we wasted some
otherwise idle cycles, looking for pullable, runnable tasks that cannot be
found, on a system that is mostly idle?

If "push to idle" is attempted on a system that is quite busy, then
couldn't that be coded to notice rather quickly if any nearby CPUs are
idle, and not search if there are no idle neighbors.  One could imagine
a word of memory for each smaller domain ("neighborhood") of CPUs (say
all the logical CPUs in a package), with one bit per logical CPU, that
was set if-and-only-if that CPU was in idle.  Then it would be very
quick for all the CPUs in that domain to see if there are (or just
were ... close enough) any idle CPUs, and skip trying to "push to idle"
if that word was all zero bits.  That is, there would be no sense
trying to push to idle if there were no idle CPUs to push to.  The only
writing and the only locking of that word would be from idle loop code,
and only from nearby CPUs in the same small domain, so it would not be
an impediment to large system scaling or a waste of many CPU cycles on
busy systems.

With a little work such as this, we could make it so that anytime you
needed either flag, you could turn on both, and the other one would be
harmless enough ... just a minor consumer of otherwise idle cycles.

Then with that, we could have one flag, that did both.

> It looks easy... but how do you handle if cpusets are overlapping?

Yeah - that part might be challenging.  Would it work to always take
the largest domain balancing requested?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
