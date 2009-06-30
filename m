Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZF3LAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZF3LAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZF3LAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:00:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45340 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbZF3LAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:00:10 -0400
Date: Tue, 30 Jun 2009 12:00:11 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, penberg@cs.helsinki.fi, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de,
       rientjes@google.com
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090630110011.GB17561@csn.ul.ie>
References: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <20090624145615.2ff9e56e.akpm@linux-foundation.org> <20090629153007.GD5065@csn.ul.ie> <20090629122029.93cdcc39.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090629122029.93cdcc39.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 12:20:29PM -0700, Andrew Morton wrote:
> On Mon, 29 Jun 2009 16:30:07 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Processes that have been OOM killed set the thread flag TIF_MEMDIE. A
> > process such as this is expected to exit the page allocator but in the
> > event it happens to have set __GFP_NOFAIL, it potentially loops forever.
> > 
> > This patch checks TIF_MEMDIE when deciding whether to loop again in the
> > page allocator. Such a process will now return NULL after direct reclaim
> > and OOM killing have both been considered as options. The potential
> > problem is that a __GFP_NOFAIL allocation can still return failure so
> > callers must still handle getting returned NULL.
> 
> I don't think we should do this :(
> 
> The __GFP_NOFAIL callers are using __GFP_NOFAIL for a reason - they
> just cannot handle an allocation failure at all.  They won't even test
> for a NULL return because a) they believe that __GFP_NOFAIL is magic and
> b) if the allocation failed, they're screwed anyway.
> 

Indeed.

> So how feasible would it be to arrange for __GFP_NOFAIL callers to
> ignore the oom-killing? 

Potential patch to do that is below - it will continue looping even with
TIF_MEMDIE if __GFP_NOFAIL is specified but otherwise a TIF_MEMDIE process
will ignore watermarks and exit if no page is available. In case __GFP_NOFAIL
is at work, it slightly alters the OOM killer to select another process if
the process selected for OOM killing is the current one.

> Presumably this means that they'll need to kill
> someone else and keep on trying?
> 

That's what I would expect to happen with the following patch. An
OOM-killed && __GFP_NOFAIL process should loop again and in the event there
are 0 pages free in the system, it would select another process for OOM
killing. This is still potentially an infinite loop so we should warn in
the event that might be happening.

Do people reckon this brings behaviour more in line with expectations or
is there something else missing?

==== CUT HERE ====
page-allocator: Ensure that processes that have been OOM killed exit the page allocator

Processes that have been OOM killed set the thread flag TIF_MEMDIE. A process
such as this is expected to exit the page allocator but potentially, it
loops forever. This patch checks TIF_MEMDIE when deciding whether to loop
again in the page allocator. If set, and __GFP_NOFAIL is not specified
then the loop will exit on the assumption it's no longer important for the
process to make forward progress. Note that a process that has just been
OOM-killed will still loop at least one more time retrying the allocation
before the thread flag is checked.

If there are zero pages free and the process has been OOM-killed with
__GFP_NOFAIL, it will loop again but the OOM killer is disabled as long as
one process has TIF_MEMDIE set. Potentially, this is an infinite loop so the
OOM killer will still trigger if the current process is the process with
TIF_MEMDIE set. This still could be an infinite loop in the very unlikely
event all pages are in use by the current process that cannot continue
due to __GFP_NOFAIL. This patch warns if the situation is potentially
occuring. While it could be a deadlock situation, there is little else to
do except keep retrying or panic.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 175a67a..5f4656e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -230,14 +230,21 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		/*
 		 * This task already has access to memory reserves and is
 		 * being killed. Don't allow any other task access to the
-		 * memory reserve.
+		 * memory reserve unless the current process is the one
+		 * selected for OOM-killing. If the current process has
+		 * been OOM-killed and we are OOM again, another process
+		 * needs to be considered for OOM-kill
 		 *
 		 * Note: this may have a chance of deadlock if it gets
 		 * blocked waiting for another task which itself is waiting
 		 * for memory. Is there a better alternative?
 		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE))
-			return ERR_PTR(-1UL);
+		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
+			if (p == current)
+				continue;
+			else
+				return ERR_PTR(-1UL);
+		}
 
 		/*
 		 * This is in the process of releasing memory so wait for it
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d714f8..5896469 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1539,6 +1539,14 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 	if (gfp_mask & __GFP_NORETRY)
 		return 0;
 
+	/* Do not loop if OOM-killed unless __GFP_NOFAIL is specified */
+	if (test_thread_flag(TIF_MEMDIE)) {
+		if (gfp_mask & __GFP_NOFAIL)
+			WARN(1, "Potential infinite loop with __GFP_NOFAIL");
+		else
+			return 0;
+	}
+
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
 	 * means __GFP_NOFAIL, but that may not be true in other
