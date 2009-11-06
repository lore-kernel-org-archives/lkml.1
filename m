Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZKFS4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZKFS4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZKFS4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:56:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbZKFS4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:56:50 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: jens.axboe@oracle.com, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Performance regression in IO scheduler still there
References: <20091026172012.GC7233@duck.suse.cz>
	<x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 06 Nov 2009 13:56:44 -0500
In-Reply-To: <x49zl7020mr.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Thu, 05 Nov 2009 15:10:52 -0500")
Message-ID: <x49my2zh47n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Jan Kara <jack@suse.cz> writes:
>
>>   Hi,
>>
>>   I took time and remeasured tiobench results on recent kernel. A short
>> conclusion is that there is still a performance regression which I reported
>> few months ago. The machine is Intel 2 CPU with 2 GB RAM and plain SATA
>> drive. tiobench sequential write performance numbers with 16 threads:
>> 2.6.29:              AVG       STDERR
>> 37.80 38.54 39.48 -> 38.606667 0.687475
>>
>> 2.6.32-rc5:
>> 37.36 36.41 36.61 -> 36.793333 0.408928 
>>
>> So about 5% regression. The regression happened sometime between 2.6.29 and
>> 2.6.30 and stays the same since then... With deadline scheduler, there's
>> no regression. Shouldn't we do something about it?
>
> Sorry it took so long, but I've been flat out lately.  I ran some
> numbers against 2.6.29 and 2.6.32-rc5, both with low_latency set to 0
> and to 1.  Here are the results (average of two runs):

I modified the tiobench script to do a drop_caches between runs so I
could stop fiddling around with the numbers myself.  Extra credit goes
to anyone who hacks it up to report standard deviation.

Anyway, here are the latest results, average of 3 runs each for 2.6.29
and 2.6.32-rc6 with low_latency set to 0.  Note that there was a fix in
CFQ that would result in properly preempting the active queue for
metadata I/O.

                                                            rlat      |     rrlat       |     wlat       |  rwlat
kernel     | Thr | read  | randr  | write  | randw  |    avg, max     |    avg, max     |   avg, max     | avg,max
------------------------------------------------------------------------------------------------------------------------
2.6.29     |  8  | 66.43 |  20.52 | 296.32 | 214.17 | 22.330, 3106.47 | 70.026, 2804.02 | 4.817, 2406.65 | 1.420, 349.44
           | 16  | 63.28 |  20.45 | 322.65 | 212.77 | 46.457, 5779.14 |137.455, 4982.75 | 8.378, 5408.60 | 2.764, 425.79
------------------------------------------------------------------------------------------------------------------------
2.6.32-rc6 |  8  | 87.66 | 115.22 | 324.19 | 222.18 | 16.677, 3065.81 | 11.834,  194.18 | 4.261, 1212.86 | 1.577, 103.20
low_lat=0  | 16  | 94.06 | 49.65  | 327.06 | 214.74 | 30.318, 5468.20 | 50.947, 1725.15 | 8.271, 1522.95 | 3.064,  89.16
------------------------------------------------------------------------------------------------------------------------

Given those numbers, everything looks ok from a regression perspective.
More investigation should be done for the random read numbers (given
that they fluctuate quite a bit), but that's purely an enhancement at
this point in time.

Just to be sure, I'll kick off 10 runs and make sure the averages fall
out the same way.  If you don't hear from me, though, assume this
regression is fixed.  The key is to set low_latency to 0 for this
benchmark.  We should probably add notes about when to switch off
low_latency to the io scheduler documentation.  Jens, would you mind
doing that?

Cheers,
Jeff
