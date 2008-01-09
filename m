Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYAICYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYAICYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYAICYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:24:18 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44591 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYAICYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:24:17 -0500
Subject: Re: [PATCH 0/4] add task handling notifier
From: Matt Helsley <matthltc@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       pagg@oss.sgi.com, erikj@sgi.com, pj@sgi.com
In-Reply-To: <20071223122621.GA19310@infradead.org>
References: <476A780C.76E4.0078.0@novell.com>
	 <20071223122621.GA19310@infradead.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 08 Jan 2008 18:24:07 -0800
Message-Id: <1199845447.17010.149.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-23 at 12:26 +0000, Christoph Hellwig wrote:
> On Thu, Dec 20, 2007 at 01:11:24PM +0000, Jan Beulich wrote:
> > With more and more sub-systems/sub-components leaving their footprint
> > in task handling functions, it seems reasonable to add notifiers that
> > these components can use instead of having them all patch themselves
> > directly into core files.
> 
> I agree that we probably want something like this.  As do some others,
> so we already had a few a few attempts at similar things.  The first one
> is from SGI and called PAGG (http://oss.sgi.com/projects/pagg/) and also
> includes allocating per-task data for it's users.  Then also from SGI
> there has been a simplified version called pnotify that's also available
> from the website above.
> 
> Later Matt Helsley had something called "Task Watchers" which lwn has
> an article on: http://lwn.net/Articles/208117/.

Apologies for the late reply -- I haven't had internet access for the
last few weeks.

> For some reason neither ever made a lot of progess (performance
> problems?).

Yeah. Some discussion on measuring the performance of Task Watchers:
http://thread.gmane.org/gmane.linux.lse/4698

The requirements for Task Watchers were:

Allow sleeping in most/all notifier functions in these paths:
	fork
	exec
	exit
	change [re][ug]id
No performance overhead
One "chain" per path ("I only care about exec().")
Easy to use
Scales to large numbers of CPUs
Useful to make most in-tree code more readable. Task Watchers took
direct calls to these pieces of code out of the fork/exec/exit paths:
	audit
	semundo
	cpusets
	mempolicy
	trace irqflags
	lockdep
	keys (for processes -- not for thread groups)
	process events connector
Useful for loadable modules

Performance overhead in microbenchmarks was measurable at around 1% (see
the URL above). Overhead on benchmarks like kernbench on the other hand
were in the noise margins (which were around 1.6%) and hence I couldn't
determine the overhead there.

I never got the loadable module part completely working due to races
between notifier functions and the module unload path. The solution to
the races seemed to require adding more overhead to the notifier
function paths (SRCU-like grace periods).

I stopped pushing the patch set because I hadn't found any new
optimizations to offset the overheads while still meeting all the
requirements and Andrew still felt that the "make it more readable"
argument was not sufficient to justify its inclusion.

Jan, instead of adding notifiers could utrace be used or made to work
for modules? Also, please add me to the Cc list for any reposts of the
entire series. Thanks!

Cheers,
	-Matt Helsley

