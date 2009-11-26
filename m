Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbZKZVZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbZKZVZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZKZVZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:25:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55599 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbZKZVZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:25:39 -0500
Date: Thu, 26 Nov 2009 21:25:41 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>, efault@gmx.de
Subject: Re: [RFC,PATCH] cfq-iosched: improve async queue ramp up formula
Message-ID: <20091126212541.GJ13095@csn.ul.ie>
References: <200911261710.40719.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200911261710.40719.czoccolo@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 05:10:39PM +0100, Corrado Zoccolo wrote:
> The introduction of ramp-up formula for async queue depths has
> slowed down dirty page reclaim, by reducing async write performance.
> This patch improves the formula by considering the remaining slice.
> 
> The new formula will allow more dispatches at the beginning of the
> slice, reducing them at the end.
> This will ensure that we achieve good throughput, without the risk of
> overrunning the allotted timeslice.
> 
> The threshold is automatically increased when sync I/O is not
> intermingled with async, in accordance with the previous incarnation of
> the formula.
> 

Thanks.

I don't quite get the patch but it certainly helps the situation for the
tests I was running. It's not as good as disabling the low_latency switch
but it's an improvement. The iozone figures are now comparable to disabling
low_latency and for sysbench and the gitk stuff, I now have

SYSBENCH
                 sysbench-with       low-latency  sysbench-without
                   low-latency      async-rampup       low-latency
           1  1266.02 ( 0.00%)  1265.15 (-0.07%)  1278.55 ( 0.98%)
           2  1182.58 ( 0.00%)  1223.03 ( 3.31%)  1379.25 (14.26%)
           3  1218.64 ( 0.00%)  1246.42 ( 2.23%)  1580.08 (22.87%)
           4  1212.11 ( 0.00%)  1325.17 ( 8.53%)  1534.17 (20.99%)
           5  1046.77 ( 0.00%)  1008.44 (-3.80%)  1552.48 (32.57%)
           6  1187.14 ( 0.00%)  1147.18 (-3.48%)  1661.19 (28.54%)
           7  1179.37 ( 0.00%)  1202.49 ( 1.92%)   790.26 (-49.24%)
           8  1164.62 ( 0.00%)  1184.56 ( 1.68%)   854.10 (-36.36%)
           9  1095.22 ( 0.00%)  1002.42 (-9.26%)  1655.04 (33.83%)
          10  1147.52 ( 0.00%)  1151.73 ( 0.37%)  1653.89 (30.62%)
          11   823.38 ( 0.00%)   754.15 (-9.18%)  1627.45 (49.41%)
          12   813.73 ( 0.00%)   848.32 ( 4.08%)  1494.63 (45.56%)
          13   898.22 ( 0.00%)   931.47 ( 3.57%)  1521.64 (40.97%)
          14   873.50 ( 0.00%)   875.75 ( 0.26%)  1311.09 (33.38%)
          15   808.32 ( 0.00%)   877.87 ( 7.92%)  1009.70 (19.94%)
          16   758.17 ( 0.00%)   881.23 (13.96%)   725.17 (-4.55%)

Many gains there. Not as much as disabling the switch but an improvement
nonetheless.

desktop-net-gitk
                     gitk-with       low-latency      gitk-without
                   low-latency      async-rampup       low-latency
min            954.46 ( 0.00%)   796.22 (16.58%)   640.65 (32.88%)
mean           964.79 ( 0.00%)   798.01 (17.29%)   655.57 (32.05%)
stddev          10.01 ( 0.00%)     1.91 (80.95%)    13.33 (-33.18%)
max            981.23 ( 0.00%)   800.91 (18.38%)   675.65 (31.14%)
pgalloc-fail        0 ( 0.00%)        0 ( 0.00%)        0 ( 0.00%)

Interesting to note how much more stable the results for the gitk tests are
with the patch applied.

The for-2.6.33 branch for linux-2.6-block are now in progress and I've
queued up the high-order allocation tests but it'll take several hours
to complete.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
