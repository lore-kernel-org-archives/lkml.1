Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZKKOK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZKKOK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZKKOK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:10:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:34607 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZKKOK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:10:27 -0500
Date: Wed, 11 Nov 2009 15:10:31 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Performance regression in IO scheduler still there
Message-ID: <20091111141031.GA21511@duck.suse.cz>
References: <20091026172012.GC7233@duck.suse.cz> <x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-11-09 15:10:52, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >   Hi,
> >
> >   I took time and remeasured tiobench results on recent kernel. A short
> > conclusion is that there is still a performance regression which I reported
> > few months ago. The machine is Intel 2 CPU with 2 GB RAM and plain SATA
> > drive. tiobench sequential write performance numbers with 16 threads:
> > 2.6.29:              AVG       STDERR
> > 37.80 38.54 39.48 -> 38.606667 0.687475
> >
> > 2.6.32-rc5:
> > 37.36 36.41 36.61 -> 36.793333 0.408928 
> >
> > So about 5% regression. The regression happened sometime between 2.6.29 and
> > 2.6.30 and stays the same since then... With deadline scheduler, there's
> > no regression. Shouldn't we do something about it?
> 
> Sorry it took so long, but I've been flat out lately.  I ran some
> numbers against 2.6.29 and 2.6.32-rc5, both with low_latency set to 0
> and to 1.  Here are the results (average of two runs):
> 
>                                                             rlat      |     rrlat       |     wlat       |  rwlat
> kernel     | Thr | read  | randr  | write  | randw  |    avg, max     |    avg, max     |   avg, max     | avg,max
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.29     |  8  | 72.95 |  20.06 | 269.66 | 231.59 |  6.625, 1683.66 | 23.241, 1547.97 | 1.761,  698.10 | 0.720, 443.64
>            | 16  | 72.33 |  20.03 | 278.85 | 228.81 | 13.643, 2499.77 | 46.575, 1717.10 | 3.304, 1149.29 | 1.011, 140.30
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.32-rc5 |  8  | 86.58 |  19.80 | 198.82 | 205.06 |  5.694, 977.26  | 22.559,  870.16 | 2.359,  693.88 | 0.530,  24.32
>            | 16  | 86.82 |  21.10 | 199.00 | 212.02 | 11.010, 1958.78 | 40.195, 1662.35 | 4.679, 1351.27 | 1.007,  25.36
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.32-rc5 |  8  | 87.65 | 117.65 | 298.27 | 212.35 |  5.615,  984.89 |  4.060,   97.39 | 1.535,  311.14 | 0.534,  24.29
> low_lat=0  | 16  | 95.60 | 119.95*| 302.48 | 213.27 | 10.263, 1750.19 | 13.899, 1006.21 | 3.221,  734.22 | 1.062,  40.40
> ------------------------------------------------------------------------------------------------------------------------
> 
> Legend:
> rlat - read latency
> rrlat - random read latency
> wlat - write lancy
> rwlat - random write latency
> * - the two runs reported vastly different numbers: 67.53 and 172.46
> 
> So, as you can see, if we turn off the low_latency tunable, we get
> better numbers across the board with the exception of random writes.
> It's also interesting to note that the latencies reported by tiobench
> are more favorable with low_latency set to 0, which is
> counter-intuitive.
> 
> So, now it seems we don't have a regression in sequential read
> bandwidth, but we do have a regression in random read bandwidth (though
> the random write latencies look better).  So, I'll look into that, as it
> is almost 10%, which is significant.
  Sadly, I don't see the improvement you can see :(. The numbers are the
same regardless low_latency set to 0:
2.6.32-rc5 low_latency = 0:
37.39 36.43 36.51 -> 36.776667 0.434920
  But my testing environment is a plain SATA drive so that probably
explains the difference...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
