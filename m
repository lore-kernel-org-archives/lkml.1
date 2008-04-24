Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbYDXNcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbYDXNcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYDXNcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:32:02 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34849 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYDXNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:32:00 -0400
Message-ID: <48108BC6.5030409@hp.com>
Date: Thu, 24 Apr 2008 09:31:50 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com>
In-Reply-To: <480F8936.5030406@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> The block I/O + elevator + I/O scheduler code spends a lot of time
> trying to merge I/Os -- rightfully so under "normal" circumstances.
> However, if one were to know that the incoming I/O stream was /very/
> random in nature, the cycles are wasted. (This can be the case, for
> example, during OLTP-type runs.)
>
> This patch stream adds a per-request_queue tunable that (when set)
> disables merge attempts, thus freeing up a non-trivial amount of CPU
cycles.
>
> I'll be doing some more benchmarking, but this is a representative set
> of data on a two-way Opteron box w/ 4 SATA drives. 'fio' was used to
> generate random 4k asynchronous direct I/Os over the 128GiB of each SATA
> drive.  Oprofile was used to collect the results, and we collected
> CPU_CLK_UNHALTED (CPU) and DATA_CACHE_MISSES (DCM) events. The data
> extracted below shows both the percentage for all samples (including
> non-kernel) as well as just those from the block I/O layer + elevator +
> deadline I/O scheduler + SATA modules.
>
> v2.6.25 (not patched):  CPU: 5.8330% (total)  7.5644% (I/O code only)
> v2.6.25 + nomerges = 0: CPU: 5.8008% (total)  7.5806% (I/O code only)
> v2.6.25 + nomerges = 1: CPU: 4.5404% (total)  5.9416% (I/O code only)
>
> v2.6.25 (not patched):  DCM: 8.1967% (total) 10.5188% (I/O code only)
> v2.6.25 + nomerges = 0: DCM: 7.2291% (total)  9.4087% (I/O code only)
> v2.6.25 + nomerges = 1: DCM: 6.1989% (total)  8.0155% (I/O code only)
>
> I've typically been seeing a good 20-25% reduction in CPU samples, and
> 10-15% in DCM samples for the random load w/ nomerges set to 1 compared
> to set to 0 (looking at just the block code).
>
> [BTW: The I/O performance doesn't change much between the 3 sets of data
> - the seek + I/O times themselves dominate things to such a large
> extent.  There is a very small improvement seen w/ nomerges=1, but <<1%.]
>
> It's not clear to me why 2.6.25 (not patched) requires /more/ cycles
> than does the patched kernel w/ nomerges=0 -- it's been consistent in
> the handful of runs I've done. I'm going to do a large set of runs for
> each condition (not patched, nomerges=0 & nomerges=1) to verify that
> this holds over multiple runs. I'm also going to check out sequential
> loads to see what (if any) penalty the extra couple of checks incurs on
> those (probably not noticeable).
>
> The first patch in the series adds the tunable; The second adds in the
> check to skip the merge code; and the third adds in the check to skip
> adding requests to hash lists for merging.
>
> Alan D. Brunelle
> Hewlett-Packard

The results over 25 runs (10-minutes each) look good, as noted
yesterday, /very/ slightly better I/Os per seconds with nomerges=1:

Kernel                NM  I/Os per second
--------------------  --  ---------------
2.6.25 (not patched)           483,727.36
2.6.25 + nomerges      0       483,880.96
2.6.25 + nomerges      1       483,921.92

The CPU and DCM samples in the block I/O code again were better w/
nomerges=1 averaged over the 25 runs (about 23.8% fewer cycles needed to
do the work in the block I/O code):

v2.6.25 (not patched):   CPU:  5.779% (total)   7.544% (I/O code only)
v2.6.25 + nomerges = 0:  CPU:  5.496% (total)   7.199% (I/O code only)
v2.6.25 + nomerges = 1:  CPU:  4.403% (total)   5.771% (I/O code only)


v2.6.26 (not patched):   DCM:  7.986% (total)  10.246% (I/O code only)
v2.6.25 + nomerges = 0:  DCM:  8.213% (total)  10.514% (I/O code only)
v2.6.25 + nomerges = 1:  DCM:  6.670% (total)   8.525% (I/O code only)

Alan
