Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYIIQy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYIIQy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYIIQyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:54:20 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:11353 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYIIQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:54:20 -0400
Message-ID: <48C6AA37.2020205@hp.com>
Date: Tue, 09 Sep 2008 12:54:15 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Benchmarking results: DSS elapsed time values w/ rq_affinity=0/1
  - Jens' for-2.6.28 tree
References: <48C15C02.7060504@hp.com> <48C31095.6020206@hp.com> <20080908181046.GM20055@kernel.dk>
In-Reply-To: <20080908181046.GM20055@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Thanks a lot for these numbers Alan, it definitely looks like a clear
> win (and a pretty big one) for all of the above and the previous mail.
> It would be interesting to see sys and usr times seperately, as well as
> trying to compare profiles of two runs. On the testing that I did with a
> 4-way ppc box, lock contention and bouncing was way down with XFS and
> btrfs. I didn't test other file systems yet. I saw mean acquisition and
> hold time reductions in the 20-30% range and waittime reductions of over
> 40% in just simple meta data intensive fs testing.

Unfortunately, ia64 does /not/ currently support the standard lockstat
reporting interface. However, I was able to utilize Caliper (an HP ia64
profiler similar to Oprofile) and gathered a couple of interesting
values. These are averaged over 10 runs each (10 w/ rq_affinity=0 and 10
w/ rq_affinity=1, alternating between the two).

First: For the overall system we can gauge how efficient the instruction
stream is by looking at un-stalled instructions: w/ rq_affinity set to 0
we see 24.001% of the instructions were un-stalled, whilst w/
rq_affinity set to 1 we see 24.469% un-stalled (1.95% better w/
rq_affinity set to 1).

Just looking at the gross amount of cycles attributed to the application
(Oracle) we see that with rq_affinity set to 0 about 70.123% of the
cycles are attributed to that, whilst with rq_affinity set to 1 we see
71.520% of the cycles used by Oracle (1.99% better w/ rq_affinity set to 1).

Overall stats for the two results posted above:

Unstalled values:
rq=0: min=22.180 avg=24.001 max=27.220 sdev=1.881 range=5.040
rq=1: min=23.580 avg=24.469 max=24.930 sdev=0.486 range=1.350

%Cycles attributed to Oracle:
rq=0: min=69.890 avg=70.231 max=71.170 sdev=0.379 range=1.280
rq=1: min=71.420 avg=71.520 max=71.670 sdev=0.080 range=0.250

Again, in both sets we see a /much/ smaller deviation from the average
amongst all the run results when rq_affinity is set to 1.

I'm going to see if an older lock stat mechanism still works w/
2.6.27-rc5-ish kernels on ia64, and try that.

Alan

