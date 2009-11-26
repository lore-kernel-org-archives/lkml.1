Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZKZNrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZKZNrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZKZNrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:47:07 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:59668 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZKZNrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yg2tXOuj1LUQyBubfYM/Rx6TSVowmPYuy8ug0PXpqygktYghmWEW8nvmd73wObFBX0
         Hnx2tG2njgWzNo8x2nYY52eJ9A/RG/bHMBgF6cXGIr2n4ibEKF10ULz3lXQGo37qE90V
         RXi7ZrNnkTqZfn6EKKJUViPE/xL9lWEdoaRZg=
MIME-Version: 1.0
In-Reply-To: <20091126121945.GB13095@csn.ul.ie>
References: <20091126121945.GB13095@csn.ul.ie>
Date: Thu, 26 Nov 2009 14:47:10 +0100
Message-ID: <4e5e476b0911260547r33424098v456ed23203a61dd@mail.gmail.com>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 1:19 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> (cc'ing the people from the page allocator failure thread as this might be
> relevant to some of their problems)
>
> I know this is very last minute but I believe we should consider disabling
> the "low_latency" tunable for block devices by default for 2.6.32.  There was
> evidence that low_latency was a problem last week for page allocation failure
> reports but the reproduction-case was unusual and involved high-order atomic
> allocations in low-memory conditions. It took another few days to accurately
> show the problem for more normal workloads and it's a bit more wide-spread
> than just allocation failures.
>
> Basically, low_latency looks great as long as you have plenty of memory
> but in low memory situations, it appears to cause problems that manifest
> as reduced performance, desktop stalls and in some cases, page allocation
> failures. I think most kernel developers are not seeing the problem as they
> tend to test on beefier machines and without hitting swap or low-memory
> situations for the most part. When they are hitting low-memory situations,
> it tends to be for stress tests where stalls and low performance are expected.

The low latency tunable controls various policies inside cfq.
The one that could affect memory reclaim is:
        /*
         * Async queues must wait a bit before being allowed dispatch.
         * We also ramp up the dispatch depth gradually for async IO,
         * based on the last sync IO we serviced
         */
        if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_latency) {
                unsigned long last_sync = jiffies - cfqd->last_end_sync_rq;
                unsigned int depth;

                depth = last_sync / cfqd->cfq_slice[1];
                if (!depth && !cfqq->dispatched)
                        depth = 1;
                if (depth < max_dispatch)
                        max_dispatch = depth;
        }

here the async queues max depth is limited to 1 for up to 200 ms after
a sync I/O is completed.
Note: dirty page writeback goes through an async queue, so it is
penalized by this.

This can affect both low and high end hardware. My non-NCQ sata disk
can handle a depth of 2 when writing. NCQ sata disks can handle a
depth up to 31, so limiting depth to 1 can cause write performance
drop, and this in turn will slow down dirty page reclaim, and cause
allocation failures.

It would be good to re-test the OOM conditions with that code commented out.

>
> To show the problem, I used an x86-64 machine booting booted with 512MB of
> memory. This is a small amount of RAM but the bug reports related to page
> allocation failures were on smallish machines and the disks in the system
> are not very high-performance.
>
> I used three tests. The first was sysbench on postgres running an IO-heavy
> test against a large database with 10,000,000 rows. The second was IOZone
> running most of the automatic tests with a record length of 4KB and the
> last was a simulated launching of gitk with a music player running in the
> background to act as a desktop-like scenario. The final test was similar
> to the test described here http://lwn.net/Articles/362184/ except that
> dm-crypt was not used as it has its own problems.

low_latency was tested on other scenarios:
http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/01410.html
http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-11/msg04855.html
where it improved actual and perceived performance, so disabling it
completely may not be good.

Thanks,
Corrado
