Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYDYIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYDYIia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYDYIiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:38:18 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5713 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYDYIiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:38:17 -0400
Date: Fri, 25 Apr 2008 10:38:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Message-ID: <20080425083809.GG12774@kernel.dk>
References: <480F8936.5030406@hp.com> <20080424070923.GQ12774@kernel.dk> <48107891.5000308@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48107891.5000308@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24 2008, Alan D. Brunelle wrote:
> Jens Axboe wrote:
> > On Wed, Apr 23 2008, Alan D. Brunelle wrote:
> >> The block I/O + elevator + I/O scheduler code spends a lot of time
> >> trying to merge I/Os -- rightfully so under "normal" circumstances.
> >> However, if one were to know that the incoming I/O stream was /very/
> >> random in nature, the cycles are wasted. (This can be the case, for
> >> example, during OLTP-type runs.)
> >>
> >> This patch stream adds a per-request_queue tunable that (when set)
> >> disables merge attempts, thus freeing up a non-trivial amount of CPU cycles.
> >>
> >> I'll be doing some more benchmarking, but this is a representative set
> >> of data on a two-way Opteron box w/ 4 SATA drives. 'fio' was used to
> >> generate random 4k asynchronous direct I/Os over the 128GiB of each SATA
> >> drive.  Oprofile was used to collect the results, and we collected
> >> CPU_CLK_UNHALTED (CPU) and DATA_CACHE_MISSES (DCM) events. The data
> >> extracted below shows both the percentage for all samples (including
> >> non-kernel) as well as just those from the block I/O layer + elevator +
> >> deadline I/O scheduler + SATA modules.
> >>
> >> v2.6.25 (not patched):  CPU: 5.8330% (total)  7.5644% (I/O code only)
> >> v2.6.25 + nomerges = 0: CPU: 5.8008% (total)  7.5806% (I/O code only)
> >> v2.6.25 + nomerges = 1: CPU: 4.5404% (total)  5.9416% (I/O code only)
> >>
> >> v2.6.25 (not patched):  DCM: 8.1967% (total) 10.5188% (I/O code only)
> >> v2.6.25 + nomerges = 0: DCM: 7.2291% (total)  9.4087% (I/O code only)
> >> v2.6.25 + nomerges = 1: DCM: 6.1989% (total)  8.0155% (I/O code only)
> >>
> >> I've typically been seeing a good 20-25% reduction in CPU samples, and
> >> 10-15% in DCM samples for the random load w/ nomerges set to 1 compared
> >> to set to 0 (looking at just the block code).
> >>
> >> [BTW: The I/O performance doesn't change much between the 3 sets of data
> >> - the seek + I/O times themselves dominate things to such a large
> >> extent.  There is a very small improvement seen w/ nomerges=1, but <<1%.]
> >>
> >> It's not clear to me why 2.6.25 (not patched) requires /more/ cycles
> >> than does the patched kernel w/ nomerges=0 -- it's been consistent in
> >> the handful of runs I've done. I'm going to do a large set of runs for
> >> each condition (not patched, nomerges=0 & nomerges=1) to verify that
> >> this holds over multiple runs. I'm also going to check out sequential
> >> loads to see what (if any) penalty the extra couple of checks incurs on
> >> those (probably not noticeable).
> >>
> >> The first patch in the series adds the tunable; The second adds in the
> >> check to skip the merge code; and the third adds in the check to skip
> >> adding requests to hash lists for merging.
> > 
> > The functionality is fine with me, merging is obviously a non-zero
> > amount of cycles spent on IO and if you know it's in vain, may as well
> > turn it off. One suggestion, though - if you add this as a performance
> > rather than functionality change, I would suggest keeping the one-hit
> > cache merge as that is essentially free. Better than free actually,
> > since if you hit that merge point you'll be spending way less cycles
> > than allocating+setting up a new request.
> > 
> 
> Hi Jens -
> 
> I'll look into retaining the one-hit cache merge functionality, remove
> the errant elv_rqhas_del code, and repost w/ the results from the other
> tests I've run.

Also please do a check where you only disable the front merge logic, as
that is the most expensive bit (and the least likely to occur). I would
not be surprised if just removing the front merge bit would get you the
majority of the gain already. I have in the past considered just getting
rid of that bit, as it rarely triggers and it is a costly rbtree lookup
for each IO. The back merge lookup+merge should be cheaper, it's just a
hash lookup.

-- 
Jens Axboe

