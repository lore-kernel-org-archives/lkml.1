Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXGZE6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXGZE6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 00:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXGZE6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 00:58:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbXGZE6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 00:58:23 -0400
Date: Wed, 25 Jul 2007 21:57:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Eric St-Laurent" <ericstl34@sympatico.ca>,
       "Rene Herman" <rene.herman@gmail.com>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, "ck list" <ck@vds.kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-Id: <20070725215717.df1d2eea.akpm@linux-foundation.org>
In-Reply-To: <2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	<46A57068.3070701@yahoo.com.au>
	<2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<46A58B49.3050508@yahoo.com.au>
	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	<46A6CC56.6040307@yahoo.com.au>
	<46A6D7D2.4050708@gmail.com>
	<1185341449.7105.53.camel@perkele>
	<46A6E1A1.4010508@yahoo.com.au>
	<2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 09:09:01 -0700
"Ray Lee" <ray-lk@madrabbit.org> wrote:

> No, there's a third case which I find the most annoying. I have
> multiple working sets, the sum of which won't fit into RAM. When I
> finish one, the kernel had time to preemptively swap back in the
> other, and yet it didn't. So, I sit around, twiddling my thumbs,
> waiting for my music player to come back to life, or thunderbird,
> or...

Yes, I'm thinking that's a good problem statement and it isn't something
which the kernel even vaguely attempts to address, apart from normal
demand paging.

We could perhaps improve things with larger and smarter fault readaround,
perhaps guided by refault-rate measurement.  But that's still demand-paged
rather than being proactive/predictive/whatever.

None of this is swap-specific though: exactly the same problem would need
to be solved for mmapped files and even plain old pagecache.

In fact I'd restate the problem as "system is in steady state A, then there
is a workload shift causing transition to state B, then the system goes
idle.  We now wish to reinstate state A in anticipation of a resumption of
the original workload".

swap-prefetch solves a part of that.

A complete solution for anon and file-backed memory could be implemented
(ta-da) in userspace using the kernel inspection tools in -mm's maps2-*
patches.  We would need to add a means by which userspace can repopulate
swapcache, but that doesn't sound too hard (especially when you haven't
thought about it).

And userspace can right now work out which pages from which files are in
pagecache so this application can handle pagecache, swap and file-backed
memory.  (file-backed memory might not even need special treatment, given
that it's pagecache anyway).


And userspace can do a much better implementation of this
how-to-handle-large-load-shifts problem, because it is really quite
complex.  The system needs to be monitored to determine what is the "usual"
state (ie: the thing we wish to reestablish when the transient workload
subsides).  The system then needs to be monitored to determine when the
exceptional workload has started, and when it has subsided, and userspace
then needs to decide when to start reestablishing the old working set, at
what rate, when to abort doing that, etc.

All this would end up needing runtime configurability and tweakability and
customisability.  All standard fare for userspace stuff - much easier than
patching the kernel.


So.  We can

a) provide a way for userspace to reload pagecache and

b) merge maps2 (once it's finished) (pokes mpm)

and we're done?
