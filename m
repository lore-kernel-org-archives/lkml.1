Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZJLIUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZJLIUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZJLIUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:20:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56472 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZJLIUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:20:41 -0400
Date: Mon, 12 Oct 2009 10:20:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       samba-technical@lists.samba.org
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091012082004.GY9228@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <20091007095657.GB8703@kernel.dk> <20091012035843.GC25882@wotan.suse.de> <20091012055920.GD25882@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012055920.GD25882@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12 2009, Nick Piggin wrote:
> On Mon, Oct 12, 2009 at 05:58:43AM +0200, Nick Piggin wrote:
> > On Wed, Oct 07, 2009 at 11:56:57AM +0200, Jens Axboe wrote:
> > Try changing the 'statvfs' syscall in dbench to 'statfs'.
> > glibc has to do some nasty stuff parsing /proc/mounts to
> > make statvfs work. On my 2s8c opteron it goes like this:
> > clients     vanilla kernel     vfs scale (MB/s)
> > 1            476                447
> > 2           1092               1128
> > 4           2027               2260
> > 8           2398               4200
> > 
> > Single threaded performance isn't as good so I need to look
> > at the reasons for that :(. But it's practically linearly
> > scalable now. The dropoff at 8 I'd say is probably due to
> > the memory controllers running out of steam rather than
> > cacheline or lock contention.
> 
> Ah, no on a bigger machine it starts slowing down again due
> to shared cwd contention, possibly due to creat/unlink type
> events. This could be improved by not restarting the entire
> path walk when we run into trouble but just trying to proceed
> from the last successful element.
> 
I was starting to do a few runs, but there's something funky going on
here. The throughput rates are consistent throughout a single run, but
not at all between runs. I suspect this may be due to CPU placement.
The numbers also look pretty odd, here's an example from a patched
kernel with dbench using statfs:

Clients         Patched
------------------------
1                1.00
2                1.23
4                2.96
8                1.22
16               0.89
32               0.83
64               0.83

So while the numbers fluctuate by as much as 20% from run to run.

OK, so it seems FAIR_SLEEPERS sched feature is responsible for this, if
I turn that off I get more consistent numbers. Below table is -git vs
vfs patches on -git. Baseline is -git with 1 client, > 1.00 is faster
and vice versa.

Clients         Vanilla         VFS scale
-----------------------------------------
1                1.00            0.96
2                1.69            1.71
4                2.16            2.98
8                0.99            1.00
16               0.90            0.85

As you can see, it's still quickling spiralling into most of the time (>
95%) spinning on a lock and killing scaling.

> Anyway, if you do get a chance to run dbench with this
> modification, I would appreciate seeing a profile with clal
> traces (my bigger system is ia64 which doesn't do perf yet).

For what number of clients?

-- 
Jens Axboe

