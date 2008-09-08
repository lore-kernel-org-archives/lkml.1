Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYIHGIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYIHGIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 02:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYIHGIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 02:08:40 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:45156 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752270AbYIHGIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 02:08:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=34243KmEKnHRjDrTJcdT0o60Z+HW4fUbpt7wxO5Jh7QVrlHTevRIgwyDHv0o1q6FsPCnq8nk6dgbvOUv6s4pRIx8Ti10QpiYyMbDKdINTVbuqKZwvVd6wlnlj8Pl/jw2mGLHjDxypSWEwWsX2KDT9PAJX27hNAz9MxExWNzdStw=  ;
X-YMail-OSG: vMGuYo0VM1nJxi49TxwQV.TjiDGoTCpVX19NZySJUjPSuU0kAxaHNLW4c6A_SJs2hpLJ2BugUBjUSBx2uzRBSLX1Ikws2UKN33aia82cy1Gw3r.eFEe0wRJoBWpevTacIjZEJXQephw1FhX8hQgBcVJ3
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 0/4] Reclaim page capture v3
Date: Mon, 8 Sep 2008 16:08:03 +1000
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>
References: <1220610002-18415-1-git-send-email-apw@shadowen.org>
In-Reply-To: <1220610002-18415-1-git-send-email-apw@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081608.03793.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2008 20:19, Andy Whitcroft wrote:
> For sometime we have been looking at mechanisms for improving the
> availability of larger allocations under load.  One of the options we have
> explored is the capturing of pages freed under direct reclaim in order to
> increase the chances of free pages coelescing before they are subject to
> reallocation by racing allocators.
>
> Following this email is a patch stack implementing page capture during
> direct reclaim.  It consits of four patches.  The first two simply pull
> out existing code into helpers for reuse.  The third makes buddy's use
> of struct page explicit.  The fourth contains the meat of the changes,
> and its leader contains a much fuller description of the feature.
>
> This update represents a rebase to -mm and incorporates feedback from
> KOSAKI Motohiro.  It also incorporates an accounting fix which was
> preventing some captures.
>
> I have done a lot of comparitive testing with and without this patch
> set and in broad brush I am seeing improvements in hugepage allocations
> (worst case size) success on all of my test systems.  These tests consist
> of placing a constant stream of high order allocations on the system,
> at varying rates.  The results for these various runs are then averaged
> to give an overall improvement.
>
> 		Absolute	Effective
> x86-64		2.48%		 4.58%
> powerpc		5.55%		25.22%

These are the numbers for the improvement of hugepage allocation success?
Then what do you mean by absolute and effective?

What sort of constant stream of high order allocations are you talking
about? In what "real" situations are you seeing higher order page allocation
failures, and in those cases, how much do these patches help?

I must say I don't really like this approach. IMO it might be better to put
some sort of queue in the page allocator, so if memory becomes low, then
processes will start queueing up and not be allowed to jump the queue and
steal memory that has been freed by hard work of a direct reclaimer. That
would improve a lot of fairness problems as well as improve coalescing for
higher order allocations without introducing this capture stuff.


>
> x86-64 has a relatively small huge page size and so is always much more
> effective at allocating huge pages.  Even there we get a measurable
> improvement.  On powerpc the huge pages are much larger and much harder
> to recover.  Here we see a full 25% increase in page recovery.
>
> It should be noted that these are worst case testing, and very agressive
> taking every possible page in the system.  It would be helpful to get
> wider testing in -mm.
>
> Against: 2.6.27-rc1-mm1
>
> Andrew, please consider for -mm.
>
> -apw
>
> Changes since V2:
>  - Incorporates review feedback from Christoph Lameter,
>  - Incorporates review feedback from Peter Zijlstra, and
>  - Checkpatch fixes.
>
> Changes since V1:
>  - Incorporates review feedback from KOSAKI Motohiro,
>  - fixes up accounting when checking watermarks for captured pages,
>  - rebase 2.6.27-rc1-mm1,
>  - Incorporates review feedback from Mel.
>
>
> Andy Whitcroft (4):
>   pull out the page pre-release and sanity check logic for reuse
>   pull out zone cpuset and watermark checks for reuse
>   buddy: explicitly identify buddy field use in struct page
>   capture pages freed during direct reclaim for allocation by the
>     reclaimer
>
>  include/linux/mm_types.h   |    4 +
>  include/linux/page-flags.h |    4 +
>  mm/internal.h              |    8 +-
>  mm/page_alloc.c            |  263
> ++++++++++++++++++++++++++++++++++++++------ mm/vmscan.c                | 
> 115 ++++++++++++++++----
>  5 files changed, 338 insertions(+), 56 deletions(-)
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
