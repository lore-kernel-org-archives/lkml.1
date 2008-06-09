Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYFIA46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYFIA46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYFIA4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:56:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbYFIA4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:56:49 -0400
Date: Sun, 8 Jun 2008 20:56:29 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Message-ID: <20080608205629.5b519110@bree.surriel.com>
In-Reply-To: <20080608165434.67c87e5c.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.291472052@redhat.com>
	<20080606180506.081f686a.akpm@linux-foundation.org>
	<20080608163413.08d46427@bree.surriel.com>
	<20080608135704.a4b0dbe1.akpm@linux-foundation.org>
	<20080608173244.0ac4ad9b@bree.surriel.com>
	<20080608162208.a2683a6c.akpm@linux-foundation.org>
	<20080608193420.2a9cc030@bree.surriel.com>
	<20080608165434.67c87e5c.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 16:54:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 8 Jun 2008 19:34:20 -0400 Rik van Riel <riel@redhat.com> wrote:

> > Please let me know which direction I should take, so I can fix
> > up the patch set accordingly.
> 
> I'm getting rather wobbly about all of this.
> 
> This is, afair, by far the most intrusive and high-risk change we've
> looked at doing since 2.5.x, for small values of x.

Nowhere near as intrusive or risky as eg. the timer changes that went
in a few releases ago.
 
> I mean, it's taken many years of work to get reclaim into its current
> state (and the reduction in reported problems will in part be due to
> the quadrupling-odd of memory over that time).

Actually, memory is now getting so large that the current code no
longer works right.  On machines 16GB and up, we have discovered
really pathetic behaviour by the VM currently upstream.

Things like the VM scanning over the (locked) shared memory segment
over and over and over again, to get at the 1GB of freeable pagecache
memory in the system.  Or the system scanning over all anonymous
memory over and over again, despite the fact that there is no more
swap space left.

With heavy anonymous memory workloads, Linux can stall for minutes
once memory runs low and something needs to be swapped out, because
pretty much all memory is anonymous and everything has the referenced
bit set.  We have seen systems with 128GB of RAM hang overnight, once
every CPU got wedged in the pageout scanning code.  Typically the VM
decides on a first page to swap out in 2-3 minutes though, and then
it will start several gigabytes of swap IO at once...

Definately not acceptable behaviour.

> And we're now proposing radical changes which again will take years to sort
> out, all on behalf of a small number of workloads upon a minority of 64-bit
> machines which themselves are a minority of the Linux base.

Hardware gets larger.  4 years ago few people cared about systems
with more than 4GB of memory, but nowadays people have that in their
desktops.

> And it will take longer to get those problems sorted out if 32-bt
> machines aren't even compiing the new code in.

32 bit systems will still get the file/anon LRU split.  The only
thing that is 64 bit only in the current patch set is keeping the
unevictable pages off of the LRU lists.

This means that balancing between file and anon eviction will be
the same on 32 and 64 bit systems and things should get sorted out
on both systems at the same time.

> Are all of thse changes really justified?

People with large Linux servers are experiencing system stalls
of several minutes, or at worst complete livelocks, with the
current VM.

I believe that those issues need to be fixed.

After discussing this for a long time with Larry Woodman,
Lee Schermerhorn and others, I am convinced that they can
not be fixed by putting a bandaid on the current code.

After all, the fundamental problem often is that the file backed
and mem/swap backed pages are on the same LRU.

Think of a case that is becoming more and more common: a database
server with 128GB of RAM, 2GB of (hardly ever used) swap, 80GB of
locked shared memory segment, 30GB of other anonymous memory and
5GB of page cache.

Do you think it is reasonable for the VM to have to scan over
110GB of essentially unevictable memory, just to get at the 5GB
of page cache?

> Because I guess we should have a think about alternative approaches.

We have.  We failed to come up with anything that avoids the
problem without actually fixing the fundamental issues.

If you have an idea, please let us know.

Otherwise, please give us a chance to shake things out in -mm.

I will prepare kernel RPMs for Fedora so users in the community can
easily test these patches too, and help find scenarios where these
patches do not perform as well as what the current kernel has.

I have time to track down and fix any issues that people find.

-- 
All rights reversed.
