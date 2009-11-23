Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZKWOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZKWOhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZKWOhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:37:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:46403 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754833AbZKWOhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:37:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18YKR1/ozIYwfvkeDMZWP4qMMxcMsVQftBEzpGGfu
	0Iq8kGGAgzTMs5
Subject: Re: newidle balancing in NUMA domain?
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20091123112228.GA2287@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 15:37:39 +0100
Message-Id: <1258987059.6193.73.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 12:22 +0100, Nick Piggin wrote:
> Hi,
> 
> I wonder why it was decided to do newidle balancing in the NUMA
> domain? And with newidle_idx == 0 at that.
> 
> This means that every time the CPU goes idle, every CPU in the
> system gets a remote cacheline or two hit. Not very nice O(n^2)
> behaviour on the interconnect. Not to mention trashing our
> NUMA locality.

Painful on little boxen too if left unchained.
 
> And then I see some proposal to do ratelimiting of newidle
> balancing :( Seems like hack upon hack making behaviour much more
> complex.

That's mine, and yeah, it is hackish.  It just keeps newidle at bay for
high speed switchers while keeping it available to kick start CPUs for
fork/exec loads.  Suggestions welcome.  I have a threaded testcase
(x264) where turning the think off costs ~40% throughput.  Take that
same testcase (or ilk) to a big NUMA beast, and performance will very
likely suck just as bad as it does on my little Q6600 box.

Other than that, I'd be most happy to see the thing crawl back in it's
cave and _die_ despite the little gain it provides for a kbuild.  It has
been (is) very annoying.

> One "symptom" of bad mutex contention can be that increasing the
> balancing rate can help a bit to reduce idle time (because it
> can get the woken thread which is holding a semaphore to run ASAP
> after we run out of runnable tasks in the system due to them 
> hitting contention on that semaphore).

Yes, when mysql+oltp starts jamming up, load balancing helps bust up the
logjam somewhat, but that's not at all why newidle was activated..

> I really hope this change wasn't done in order to help -rt or
> something sad like sysbench on MySQL.

Newidle was activated to improve fork/exec CPU utilization.  A nasty
side effect is that it tries to rip other loads to tatters.

> And btw, I'll stay out of mentioning anything about CFS development,
> but it really sucks to be continually making significant changes to
> domains balancing *and* per-runqueue scheduling at the same time :(
> It makes it even difficult to bisect things.

Yeah, balancing got jumbled up with desktop tweakage.  Much fallout this
round, and some things still to be fixed back up.

	-Mike

