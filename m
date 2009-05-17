Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbZEQAil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbZEQAil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 20:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZEQAib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 20:38:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:28074 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbZEQAia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 20:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZQeN978JbTLUz/81rK0tOLNKJHJo0ytAaFGBEKDLTQZtTtkQuzyBl1+XVQpR8oL3JG
         NS2fLB7Jz4lJRePhcXW/h1JdKh59D5SAmIYoAVHYaHuEpM0GtAZ+kunsPYLA1I6ecIqb
         r9eHwvukYEzvlahKXdjkwHX+ytfUswB2/kqF4=
MIME-Version: 1.0
In-Reply-To: <20090516092858.GA12104@localhost>
References: <20090516090005.916779788@intel.com>
	 <20090516090448.410032840@intel.com>
	 <20090516092858.GA12104@localhost>
Date: Sun, 17 May 2009 09:38:30 +0900
Message-ID: <28c262360905161738o2ec8b0cg6bfb40b40fc048fa@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class 
	citizen
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 6:28 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> [trivial update on comment text, according to Rik's comment]
>
> --
> vmscan: make mapped executable pages the first class citizen
>
> Protect referenced PROT_EXEC mapped pages from being deactivated.
>
> PROT_EXEC(or its internal presentation VM_EXEC) pages normally belong to some
> currently running executables and their linked libraries, they shall really be
> cached aggressively to provide good user experiences.
>
> Thanks to Johannes Weiner for the advice to reuse the VMA walk in
> page_referenced() to get the PROT_EXEC bit.
>
>
> [more details]
>
> ( The consequences of this patch will have to be discussed together with
>  Rik van Riel's recent patch "vmscan: evict use-once pages first". )
>
> ( Some of the good points and insights are taken into this changelog.
>  Thanks to all the involved people for the great LKML discussions. )
>
> the problem
> -----------
>
> For a typical desktop, the most precious working set is composed of
> *actively accessed*
>        (1) memory mapped executables
>        (2) and their anonymous pages
>        (3) and other files
>        (4) and the dcache/icache/.. slabs
> while the least important data are
>        (5) infrequently used or use-once files
>
> For a typical desktop, one major problem is busty and large amount of (5)
> use-once files flushing out the working set.
>
> Inside the working set, (4) dcache/icache have already been too sticky ;-)
> So we only have to care (2) anonymous and (1)(3) file pages.
>
> anonymous pages
> ---------------
> Anonymous pages are effectively immune to the streaming IO attack, because we
> now have separate file/anon LRU lists. When the use-once files crowd into the
> file LRU, the list's "quality" is significantly lowered. Therefore the scan
> balance policy in get_scan_ratio() will choose to scan the (low quality) file
> LRU much more frequently than the anon LRU.
>
> file pages
> ----------
> Rik proposed to *not* scan the active file LRU when the inactive list grows
> larger than active list. This guarantees that when there are use-once streaming
> IO, and the working set is not too large(so that active_size < inactive_size),
> the active file LRU will *not* be scanned at all. So the not-too-large working
> set can be well protected.
>
> But there are also situations where the file working set is a bit large so that
> (active_size >= inactive_size), or the streaming IOs are not purely use-once.
> In these cases, the active list will be scanned slowly. Because the current
> shrink_active_list() policy is to deactivate active pages regardless of their
> referenced bits. The deactivated pages become susceptible to the streaming IO
> attack: the inactive list could be scanned fast (500MB / 50MBps = 10s) so that
> the deactivated pages don't have enough time to get re-referenced. Because a
> user tend to switch between windows in intervals from seconds to minutes.
>
> This patch holds mapped executable pages in the active list as long as they
> are referenced during each full scan of the active list.  Because the active
> list is normally scanned much slower, they get longer grace time (eg. 100s)
> for further references, which better matches the pace of user operations.
>
> Therefore this patch greatly prolongs the in-cache time of executable code,
> when there are moderate memory pressures.
>
>        before patch: guaranteed to be cached if reference intervals < I
>        after  patch: guaranteed to be cached if reference intervals < I+A
>                      (except when randomly reclaimed by the lumpy reclaim)
> where
>        A = time to fully scan the   active file LRU
>        I = time to fully scan the inactive file LRU
>
> Note that normally A >> I.
>
> side effects
> ------------
>
> This patch is safe in general, it restores the pre-2.6.28 mmap() behavior
> but in a much smaller and well targeted scope.
>
> One may worry about some one to abuse the PROT_EXEC heuristic.  But as
> Andrew Morton stated, there are other tricks to getting that sort of boost.
>
> Another concern is the PROT_EXEC mapped pages growing large in rare cases,
> and therefore hurting reclaim efficiency. But a sane application targeted for
> large audience will never use PROT_EXEC for data mappings. If some home made
> application tries to abuse that bit, it shall be aware of the consequences.
> If it is abused to scale of 2/3 total memory, it gains nothing but overheads.
>
> CC: Elladan <elladan@eskimo.com>
> CC: Nick Piggin <npiggin@suse.de>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Christoph Lameter <cl@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
