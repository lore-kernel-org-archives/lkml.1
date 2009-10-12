Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZJLD72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZJLD72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZJLD72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:59:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:57243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbZJLD7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:59:21 -0400
Date: Mon, 12 Oct 2009 05:58:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       samba-technical@lists.samba.org
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091012035843.GC25882@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <20091007095657.GB8703@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007095657.GB8703@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:56:57AM +0200, Jens Axboe wrote:
> On Wed, Oct 07 2009, Nick Piggin wrote:
> > Anyway, this is the basics working for now, microbenchmark shows
> > same-cwd lookups scale linearly now too. We can probably slowly
> > tackle more cases if they come up as being important, simply by
> > auditing filesystems etc.
> 
>                                 throughput
> ------------------------------------------------
> 2.6.32-rc3-git          |      561.218 MB/sec
> 2.6.32-rc3-git+patch    |      627.022 MB/sec
> 2.6.32-rc3-git+patch+inc|      969.761 MB/sec
> 
> So better, quite a bit too. Latencies are not listed here, but they are
> also a lot better. Perf top still shows ~95% spinlock time. I did a
> shorter run (the above are full 600 second runs) of 60s with profiling
> and the full 64 clients, this time using -a as well (which generated
> 9.4GB of trace data!). The top is now:

Hey Jens,

Try changing the 'statvfs' syscall in dbench to 'statfs'.
glibc has to do some nasty stuff parsing /proc/mounts to
make statvfs work. On my 2s8c opteron it goes like this:
clients     vanilla kernel     vfs scale (MB/s)
1            476                447
2           1092               1128
4           2027               2260
8           2398               4200

Single threaded performance isn't as good so I need to look
at the reasons for that :(. But it's practically linearly
scalable now. The dropoff at 8 I'd say is probably due to
the memory controllers running out of steam rather than
cacheline or lock contention.

Unfortunately we didn't just do this posix API in-kernel,
and statfs is Linux-specific. But we do have some spare
room in statfs structure I think to pass back mount flags
for statvfs.

Tridge, Samba people: measuring vfs performance with dbench
in my effort to improve Linux vfs scalability has shown up
the statvfs syscall you make to be the final problematic
issue for this workload. In particular reading /proc/mounts
that glibc does to impement it. We could add complexity to
the kernel to try improving it, or we could extend the
statfs syscall so glibc can avoid the issue (requiring
glibc upgrade). But I would like to know whether samba
really uses statvfs() significantly?

Thanks,
Nick
