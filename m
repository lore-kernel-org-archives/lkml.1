Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYJBCq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYJBCq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 22:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJBCqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 22:46:16 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:58498 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYJBCqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 22:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Nj8jOLSTvVan+ojc1FPfDoQSMdkVI4MVHDTmK/o4qHxe5L4ylDWi2vnao9iOM644Bk
         EnwhzeJtkcvLSpbj9QSkrsCIYxUPfBkY5M5svRzZajbxfVgGl4BZiETrnkmHT+yZOqZA
         IvBGgbpTvIrgIxTdzkDQAnC9X9UBrB3MoCO+0=
Message-ID: <28c262360810011946p443350d3hcb271720892e7b85@mail.gmail.com>
Date: Thu, 2 Oct 2008 11:46:12 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH 0/4] Reclaim page capture v4
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>, "Mel Gorman" <mel@csn.ul.ie>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1222864261-22570-1-git-send-email-apw@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222864261-22570-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andy.

I tested your patch in my desktop.
The test is just kernel compile with single thread.
My system environment is as follows.

model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
MemTotal:        2065856 kB

When I tested vanilla, compile time is as follows.

2433.53user 187.96system 42:05.99elapsed 103%CPU (0avgtext+0avgdata
0maxresident)k
588752inputs+4503408outputs (127major+55456246minor)pagefaults 0swaps

When I tested your patch, as follows.

2489.63user 202.41system 44:47.71elapsed 100%CPU (0avgtext+0avgdata
0maxresident)k
538608inputs+4503928outputs (130major+55531561minor)pagefaults 0swaps

Regresstion almost is above 2 minutes.
Do you think It is a trivial?

I know your patch is good to allocate hugepage.
But, I think many users don't need it, including embedded system and
desktop users yet.

So I suggest you made it enable optionally.

On Wed, Oct 1, 2008 at 9:30 PM, Andy Whitcroft <apw@shadowen.org> wrote:
> For sometime we have been looking at mechanisms for improving the availability
> of larger allocations under load.  One of the options we have explored is
> the capturing of pages freed under direct reclaim in order to increase the
> chances of free pages coelescing before they are subject to reallocation
> by racing allocators.
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
>                Absolute        Effective
> x86-64          2.48%            4.58%
> powerpc         5.55%           25.22%
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
> Changes since V3:
>  - Incorporates an anon vma fix pointed out by MinChan Kim
>  - switch to using a pagevec for page capture collection
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
>  pull out the page pre-release and sanity check logic for reuse
>  pull out zone cpuset and watermark checks for reuse
>  buddy: explicitly identify buddy field use in struct page
>  capture pages freed during direct reclaim for allocation by the
>    reclaimer
>
>  include/linux/mm_types.h   |    4 +
>  include/linux/page-flags.h |    4 +
>  include/linux/pagevec.h    |    1 +
>  mm/internal.h              |    7 +-
>  mm/page_alloc.c            |  265 ++++++++++++++++++++++++++++++++++++++------
>  mm/vmscan.c                |  118 ++++++++++++++++----
>  6 files changed, 343 insertions(+), 56 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
MinChan Kim
