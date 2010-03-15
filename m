Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936212Ab0COMe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:34:59 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43805 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936092Ab0COMe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:34:57 -0400
Message-ID: <4B9E296A.2010605@linux.vnet.ibm.com>
Date: Mon, 15 Mar 2010 13:34:50 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <20100311154124.e1e23900.akpm@linux-foundation.org> <4B99E19E.6070301@linux.vnet.ibm.com> <20100312020526.d424f2a8.akpm@linux-foundation.org> <20100312104712.GB18274@csn.ul.ie>	<4B9A3049.7010602@linux.vnet.ibm.com> <20100312093755.b2393b33.akpm@linux-foundation.org>
In-Reply-To: <20100312093755.b2393b33.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 12 Mar 2010 13:15:05 +0100 Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com> wrote:
> 
>>> It still feels a bit unnatural though that the page allocator waits on
>>> congestion when what it really cares about is watermarks. Even if this
>>> patch works for Christian, I think it still has merit so will kick it a
>>> few more times.
>> In whatever way I can look at it watermark_wait should be supperior to 
>> congestion_wait. Because as Mel points out waiting for watermarks is 
>> what is semantically correct there.
> 
> If a direct-reclaimer waits for some thresholds to be achieved then what
> task is doing reclaim?
> 
> Ultimately, kswapd.  This will introduce a hard dependency upon kswapd
> activity.  This might introduce scalability problems.  And latency
> problems if kswapd if off doodling with a slow device (say), or doing a
> journal commit.  And perhaps deadlocks if kswapd tries to take a lock
> which one of the waiting-for-watermark direct relcaimers holds.

So then why not letting the process do something about it if no writes 
are outstanding instead of going to sleep. It might be able to
take care of its bad situation alone, maybe by calling try_to_free again.

> Generally, kswapd is an optional, best-effort latency optimisation
> thing and we haven't designed for it to be a critical service. 
> Probably stuff would break were we to do so.
> 
> 
> This is one of the reasons why we avoided creating such dependencies in
> reclaim.  Instead, what we do when a reclaimer is encountering lots of
> dirty or in-flight pages is
> 
> 	msleep(100);
> 
> then try again.  We're waiting for the disks, not kswapd.
> 
> Only the hard-wired 100 is a bit silly, so we made the "100" variable,
> inversely dependent upon the number of disks and their speed.  If you
> have more and faster disks then you sleep for less time.
> 
> And that's what congestion_wait() does, in a very simplistic fashion. 
> It's a facility which direct-reclaimers use to ratelimit themselves in
> inverse proportion to the speed with which the system can retire writes.

I would totally agree if I wouldn't have that scenario suffering so much
from that mechanism.

In the scenario Mel, Nick and I discussed for a while are no writes at
all, but a lot of page cache reads.
In this scenario direct_reclaimer runs quite frequently into the case of
"did_some_progress && !page" which leads to congestion_wait calls in the
caller of direct_reclaim - eventually waiting always the full timeout as
there are no writes.

I think reclaim in this case is just done by dropping clean page cache
pages in try_to_free_pages in this case -> so still no writes.
For the solution it is hard to find the right layer, as the race is in 
direct_reclaim but the wait call is outside of it.

The alternatives we have so far are:
a) congestion_wait which works fine with writes in flight in the system,
but with a huge drawback for non writing systems.
b) watermark wait which covers writes like congestion_wait (if they free
up enough) but also any other kind of reclaimers like processes freeing
up stuff, other page cache droppers.

new suggestions:
These ideas came up when trying to view it from your position. I don't 
know exactly if all are doable/feasible, but as we are going to wait 
anyway so we could do complex things in that path.

c) If direct reclaim did reasonable progress in try_to_free but did not
get a page, AND there is no write in flight at all then let it try again
to free up something.
This could be extended by some kind of max retry to avoid some weird
looping cases as well.

d) Another way might be as easy as letting congestion_wait return
immediately if there are no outstanding writes - this would keep the 
behavior for cases with write and avoid the "running always in full 
timeout" issue without writes.

e) like d, but let it go to the watermark wait if no writes exist.

So I don't consider option a) a solution as we have real world scenarios 
with huge impacts, even putting more burden on top of kswapd's shoulders 
b) is still better - remember as long as writes are there its almost the 
same as congestion_wait, but waiting for the right time to wake up 
(awoken allocs will still fail if below watermark).
And c-e) well I'm not sure yet, just things that came to my mind.

For the moment I would suggest going forward with Mels watermark wait
towards the stable tree as it "fixes" a huge issue there (or better its 
symptoms) and the patch is small, neat and matching .32.
We can then separately continue discuss without any pressure how we can 
finally get rid of all that race/latency/kswap issues at all in 2.6.3n+1

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance

