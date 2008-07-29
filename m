Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbYG2NWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbYG2NWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYG2NWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:22:13 -0400
Received: from saeurebad.de ([85.214.36.134]:59615 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbYG2NWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:22:13 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: PERF: performance tests with the split LRU VM in -mm
References: <20080724222510.3bbbbedc@bree.surriel.com>
	<20080728105742.50d6514e@cuia.bos.redhat.com>
	<20080728164124.8240eabe.akpm@linux-foundation.org>
	<20080728195713.42cbceed@cuia.bos.redhat.com>
	<20080728200311.2218af4e@cuia.bos.redhat.com>
Date: Tue, 29 Jul 2008 15:21:47 +0200
In-Reply-To: <20080728200311.2218af4e@cuia.bos.redhat.com> (Rik van Riel's
	message of "Mon, 28 Jul 2008 20:03:11 -0400")
Message-ID: <87y73k4yhg.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Rik van Riel <riel@redhat.com> writes:

> On Mon, 28 Jul 2008 19:57:13 -0400
> Rik van Riel <riel@redhat.com> wrote:
>> On Mon, 28 Jul 2008 16:41:24 -0700
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>> 
>> > > Andrew, what is your preference between:
>> > > 	http://lkml.org/lkml/2008/7/15/465
>> > > and
>> > > 	http://marc.info/?l=linux-mm&m=121683855132630&w=2
>> > > 
>> > 
>> > Boy.  They both seem rather hacky special-cases.  But that doesn't mean
>> > that they're undesirable hacky special-cases.  I guess the second one
>> > looks a bit more "algorithmic" and a bit less hacky-special-case.  But
>> > it all depends on testing..
>> 
>> I prefer the second one, since it removes the + 1 magic (at least,
>> for the higher priorities), instead of adding new magic like the
>> other patch does.
>
> Btw, didn't you add that "+ 1" originally early on in the 2.6 VM?
>
> Do you remember its purpose?  
>
> Does it still make sense to have that "+ 1" in the split LRU VM?
>
> Could we get away with just removing it unconditionally?

Here is my original patch that just gets rid of it.  It did not cause
any problems to me on high pressure.  Rik, you said on IRC that you now
also think the patch is safe..?

	Hannes

---
From: Johannes Weiner <hannes@saeurebad.de>
Subject: mm: don't accumulate scan pressure on unrelated lists

During each reclaim scan we accumulate scan pressure on unrelated
lists which will result in bogus scans and unwanted reclaims
eventually.

Scanning lists with few reclaim candidates results in a lot of
rotation and therefor also disturbs the list balancing, putting even
more pressure on the wrong lists.

In a test-case with much streaming IO, and therefor a crowded inactive
file page list, swapping started because

  a) anon pages were reclaimed after swap_cluster_max reclaim
  invocations -- nr_scan of this list has just accumulated

  b) active file pages were scanned because *their* nr_scan has also
  accumulated through the same logic.  And this in return created a
  lot of rotation for file pages and resulted in a decrease of file
  list priority, again increasing the pressure on anon pages.

The result was an evicted working set of anon pages while there were
tons of inactive file pages that should have been taken instead.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 mm/vmscan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1458,16 +1458,13 @@ static unsigned long shrink_zone(int pri
 		if (scan_global_lru(sc)) {
 			int file = is_file_lru(l);
 			int scan;
-			/*
-			 * Add one to nr_to_scan just to make sure that the
-			 * kernel will slowly sift through each list.
-			 */
+
 			scan = zone_page_state(zone, NR_LRU_BASE + l);
 			if (priority) {
 				scan >>= priority;
 				scan = (scan * percent[file]) / 100;
 			}
-			zone->lru[l].nr_scan += scan + 1;
+			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)
 				zone->lru[l].nr_scan = 0;
