Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZFXV52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZFXV52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZFXV5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:57:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbZFXV5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:57:20 -0400
Date: Wed, 24 Jun 2009 14:56:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090624145615.2ff9e56e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org>
	<20090624094622.d0b0fd82.akpm@linux-foundation.org>
	<84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	<20090624105517.904f93da.akpm@linux-foundation.org>
	<4A426825.80905@cs.helsinki.fi>
	<20090624113037.7d72ed59.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
	<20090624120617.1e6799b5.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
	<20090624123624.26c93459.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
	<20090624130121.99321cca.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 13:13:48 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> On Wed, 24 Jun 2009, Andrew Morton wrote:
> > 
> > If the caller gets oom-killed, the allocation attempt fails.  Callers need
> > to handle that.
> 
> I actually disagree. I think we should just admit that we can always free 
> up enough space to get a few pages, in order to then oom-kill things.

I'm unclear on precisely what you're proposing here?

> This is not a new concept. oom has never been "immediately kill".

Well, it has been immediate for a long time.  A couple of reasons which
I can recall:

- A page-allocating process will oom-kill another process in the
  expectation that the killing will free up some memory.  If the
  oom-killed process remains stuck in the page allocator, that doesn't
  work.

- The oom-killed process might be holding locks (typically fs locks).
  This can cause an arbitrary number of other processes to be blocked.
  So to get the system unstuck we need the oom-killed process to
  immediately exit the page allocator, to handle the NULL return and to
  drop those locks.

There may be other reasons - it was all a long time ago, and I've never
personally hacked on the oom-killer much and I never get oom-killed. 
But given the amount of development work which goes on in there, some
people must be getting massacred.


A long time ago, the Suse kernel shipped with a largely (or
completely?) disabled oom-killer.  It removed the
retry-small-allocations-for-ever logic and simply returned NULL to the
caller.  I never really understood what problem/thinking led Andrea to
do that.


But it's all a bit moot at present, as we seem to have removed the
return-NULL-if-TIF_MEMDIE logic in Mel's post-2.6.30 merges.  I think
that was an accident:

-	/* This allocation should allow future memory freeing. */
-
 rebalance:
-	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-			&& !in_interrupt()) {
-		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-nofail_alloc:
-			/* go through the zonelist yet again, ignoring mins */
-			page = get_page_from_freelist(gfp_mask, nodemask, order,
-				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
-			if (page)
-				goto got_pg;
-			if (gfp_mask & __GFP_NOFAIL) {
-				congestion_wait(WRITE, HZ/50);
-				goto nofail_alloc;
-			}
-		}
-		goto nopage;
+	/* Allocate without watermarks if the context allows */
+	if (alloc_flags & ALLOC_NO_WATERMARKS) {
+		page = __alloc_pages_high_priority(gfp_mask, order,
+				zonelist, high_zoneidx, nodemask,
+				preferred_zone, migratetype);
+		if (page)
+			goto got_pg;
 	}

Offending commit 341ce06 handled the PF_MEMALLOC case but forgot about
the TIF_MEMDIE case.

Mel is having a bit of downtime at present.
