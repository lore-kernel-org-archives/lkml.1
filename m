Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0BYPOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:14:04 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:34798 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0BYPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:14:00 -0500
Message-ID: <4B8693B0.7000804@linux.vnet.ibm.com>
Date: Thu, 25 Feb 2010 16:13:52 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <20100209175707.GB5098@csn.ul.ie> <4B742C2C.5080305@linux.vnet.ibm.com> <20100212100519.GA29085@laptop> <4B796C6D.80800@linux.vnet.ibm.com> <20100216112517.GE1194@csn.ul.ie> <4B7ACC1E.9080205@linux.vnet.ibm.com> <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie> <4B7D664C.20507@linux.vnet.ibm.com> <4B7E73BF.5030901@linux.vnet.ibm.com> <20100219151934.GA1445@csn.ul.ie> <4B82A603.9030602@linux.vnet.ibm.com>
In-Reply-To: <4B82A603.9030602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Ehrhardt wrote:
> Mel Gorman wrote:
> [...]
> 
>> I'll need to do a number of tests before I can move that upstream but I
>> don't think it's a merge candidate. Unfortunately, I'll be offline for a
>> week starting tomorrow so I won't be able to do the testing.
>>
>> When I get back, I'll revisit those patches with the view to pushing
>> them upstream. I hate to treat symptoms here without knowing the
>> underlying problem but this has been spinning in circles for ages with
>> little forward progress :(
> 
> I'll continue with some debugging in search for the real reasons, but if 
> I can't find a new way to look at it I think we have to drop it for now.
> 
[...]
> 

As a last try I partially rewrote my debug patches which now report what
I call "extended zone info" (like proc/zoneinfo plus free area and per
migrate type counters) once every second at a random direct_reclaim call.

Naming: As before I call the plain 2.6.32 orig or "bad case" and 2.6.32
with e084b and 5f8dcc21 reverted Rev or "good case".
Depending on the fact if a allocation failed or not before the
statistics were reported I call them "failed" or "worked"
Therefore I splitted the resulting data into the four cases orig-failed,
orig-worked, Rev-failed, Rev-worked.

This could again end up in a report that most people expected (like the
stopped by watermark last time), but still I think it is worth to report
and have everyone take a look at it.

PRE)
First and probably most important to keep it in mind later on - the good
case seems to have more pages free, living usually above the watermark
and is therefore not running into that failed direct_reclaim allocations.
The question for all facts I describe below is "can this affect the
number of free pages either directly or be indirectly a pointer what
else is going on affecting the # free pages"

As notice for all data below the page cache allocations that occur when
running the read workload are GFCP_COLD=1 and preferred migration type
MOVABLE.

1) Free page distribution per order in free areas lists
These numbers cover migrate type distribution across free areas per order,
similar to what /proc/pagetypeinfo reports.

There is a major difference between the plain 2.6.32 and the one with 
e084b and 5f8dcc21 reverted. While the good case shows at least some 
distribution having a few elements in order 2-7 the bad case looks quite different.
Bad case has a huge peak in order 0, is about even on order 1 and then much fewer in order 2-7.
Eventually both cases have one order 8 page as reserve at all times.

Pages per Order      0      1      2      3      4     5      6       7    8
Bad Case        272.85  22.10   2.43   0.51   0.14  0.01   0.01    0.06    1
Good Case        97.55  15.29   3.08   1.39   0.77  0.11   0.29    0.90    1

This might not look much but factorized down to 4k order 0 pages this numbers would look like:

4kPages per Order    0      1      2      3      4     5      6       7    8
Bad Case        272.85  44.21   9.73   4.08   2.23  0.23   0.45    7.62  256
Good Case        97.55  30.58  12.30  11.12  12.24  3.64  18.67  114.91  256

So something seems to allow grouping into higher orders much better in the good case.

I wonder if there might be code doing things like this somewhere:
if (couldIcollapsethisintohigherorder)
    free
else
    donothing
-> leaving less free and less higher order pages in the bad case.

Remember my introduction - what we eventually search is why the bad case
has fewer free pages.

3) Migrate types on free areas
Looking at the numbers above more in detail, meaning "splitted into the
different migrate types" shows another difference.
The bad case has most of the pages as unmovable, interestingly almost exactly that
amount of pages that are shifted from higher orders to order 0 when comparing
good/bad case.
So this might be related to that different order distribution we see above.
(BTW - on s390 all memory 0-2Gb is one zone, as we have 256m in these tests
all is in one zone)

BAD CASE										
Free pgs per migrate type @ order     0     1     2     3     4     5     6     7     8
MIGRATE_UNMOVABLE                178.17  0.38  0.00  0.00  0.00  0.00  0.00  0.00     0
MIGRATE_RECLAIMABLE               12.95  0.58  0.01  0.00  0.00  0.00  0.00  0.00     0
MIGRATE_MOVABLE                   81.74 21.14  2.29  0.50  0.13  0.00  0.00  0.00     0
MIGRATE_RESERVE                    0.00  0.00  0.13  0.01  0.01  0.01  0.01  0.06     1
										
GOOD CASE										
Free pgs per migrate type @ order     0     1     2     3     4     5     6     7     8
Normal	MIGRATE_UNMOVABLE         21.70  0.14  0.00  0.00  0.00  0.00  0.00  0.00  0.00
Normal	MIGRATE_RECLAIMABLE        4.15  0.22  0.00  0.00  0.00  0.00  0.00  0.00  0.00
Normal	MIGRATE_MOVABLE           68.71 12.38  0.88  0.63  0.06  0.00  0.00  0.00  0.00
Normal	MIGRATE_RESERVE            2.99  2.56  2.19  0.77  0.71  0.11  0.29  0.90  1.00
Normal	MIGRATE_ISOLATE            0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00  0.00

Maybe this gives someone a good hint why we see that different grouping
or even why we have less free pages in bad case.

4) PCP list fill ratio
Finally the last major difference I see is the fill ratio of the pcp lists.
The good case has an average of ~TODO pages on the pcp lists while the bad
case has only ~TODO pages.

AVG count on pcp lists	
bad case	35.33
good case	62.46


When looking at the migrate types at the pcp lists (which is only possible
without 5f8dcc21 reverted) it looks like "there the movable ones have gone",
which they might have not before migrate differentiation type on pcp list
support.

AVG count per migrate type in bad case
MIGRATE_UNMOVABLE      12.57
MIGRATE_RECLAIMABLE     2.03
MIGRATE_MOVABLE        31.89

Is it possible that with 5f8dcc21 the MIGRATE_MOVABLE pages are drained
from free areas to the pcp list more agressive and leave MIGRATE_UNMOVABLE
which then might e.g. not groupable or something like that - and eventually
that way somehow leave fewer free pages left ?


FIN)
So, thats it from my side.
I look forward to the finalized congestion_wait->zone wait patch however
this turns out (zone wait is resonable if fixing this symptom or not in
my opinion).
But still I have a small amount of hope left that all the data I found here
might give someone the kick to see whats going on in mm's backstage due to
that patches.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance


