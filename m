Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZDKEZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZDKEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 00:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZDKEZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 00:25:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:4997 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZDKEZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 00:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,171,1239001200"; 
   d="scan'208";a="130331714"
Date: Sat, 11 Apr 2009 12:24:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "yinghan@google.com" <yinghan@google.com>
Subject: Re: [PATCH 9/9] readahead: record mmap read-around states in
	file_ra_state
Message-ID: <20090411042452.GB6613@localhost>
References: <20090410060957.442203404@intel.com> <20090410061255.041947147@intel.com> <20090410163853.0e1b8f7c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410163853.0e1b8f7c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 07:38:53AM +0800, Andrew Morton wrote:
> On Fri, 10 Apr 2009 14:10:06 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Mmap read-around now shares the same code style and data structure
> > with readahead code.
> > 
> > This also removes do_page_cache_readahead().
> > Its last user, mmap read-around, has been changed to call ra_submit().
> > 
> > The no-readahead-if-congested logic is dumped by the way.
> > Users will be pretty sensitive about the slow loading of executables.
> > So it's unfavorable to disabled mmap read-around on a congested queue.
> 
> Did you verify that the read-congested code ever triggers?

No.

Sorry the described is an imagined case. There could be other
counter-cases, however..

> It used to be (and probably still is) the case that
> bdi_read_congested() is very very rare, because the read queue is long
> and the kernel rarely puts many read requests into it.  You can of
> course create this condition with a fake workload with may
> threads/processes, but it _is_ fake.

The major workloads that could trigger read congestions:

1) file servers running highly concurrent IO streams
2) concurrent sys_readahead()s on a desktop, for fast booting
3) mysql is also able to issue concurrent sys_readahead()s
4) more workloads out of my imaginary

For 1) the change is favorable or irrelevant.

For 2) and 3) the change is irrelevant. The user space readahead
process must make sure the degree of parallelism is kept in control,
so that read congestion _never_ happen. Or normal reads will be blocked.

> Some real-world workloads (databases?) will of course trigger
> bdi_read_congested().  But they're usually doing fixed-sized reads, and
> if we're doing _any_ readahead/readaround in that case, readahead is
> busted.

Hmm I didn't have this possibility in mind: the read congestion is
exactly caused by a pool of concurrent mmap readers _themself_.

Let's assume they are doing N-page sized _sparse_ random reads.
(otherwise this patch will be favorable)

The current mmap_miss accounting works so that if ever N >= 2, the
readaround will be enabled for ever; if N == 1, the readaround will
be disabled quickly. The designer of this logic must be a master!

Why? If an application is to do 2-page random reads, the best option
will be the read() syscall. Because the size info will be _lost_ when
doing mmap reads. If ever the application author cares about
performance (i.e. big DBMS), he will find out that truth either by
theorizing or through experiments.

IMHO the kernel mmap readaround algorithm shall only be optimized for
- enabled: sequential reads
- enabled: large random reads
- enabled: clustered random reads
- disabled: 1-page random reads
and to perform bad and therefore discourage
- enabled and discouraged: small(2-page) and sparse random reads

It will do undesirable readaround for small sparse random mmap readers,
and I do think that we want this bad behavior to push such workloads
into using the more optimal read() syscall.

Therefore the change introduced by this patch is in line with the
above principles: either the readaround is favorable and should be
insisted even in read congestions, or readaround is already
unfavorable and let's keep it. If there are user complaints, good. We
_helped_ they discover performance bugs in their application and can
point them to the optimal solution. If it's not viable in short term,
there are workarounds like reducing the readahead size.

Thanks,
Fengguang

