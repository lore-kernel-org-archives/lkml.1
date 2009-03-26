Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZCZLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZCZLI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZCZLIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:08:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59487 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZCZLIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:08:18 -0400
Date: Thu, 26 Mar 2009 12:08:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326110815.GT27476@kernel.dk>
References: <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326090630.GA9369@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26 2009, Ingo Molnar wrote:
> And it's not just sys_fsync(). The script i wrote tests file read 
> latencies. I have created 1000 files with the same size (all copies 
> of kernel/sched.c ;-), and tested their cache-cold plain-cat 
> performance via:
> 
>   for ((i=0;i<1000;i++)); do
>     printf "file #%4d, plain reading it took: " $i
>     /usr/bin/time -f "%e seconds."  cat $i >/dev/null
>   done
> 
> I.e. plain, supposedly high-prio reads. The result is very common 
> hickups in read latencies:
> 
> file # 579 (253560 bytes), reading it took: 0.08 seconds.
> file # 580 (253560 bytes), reading it took: 0.05 seconds.
> file # 581 (253560 bytes), reading it took: 0.01 seconds.
> file # 582 (253560 bytes), reading it took: 0.01 seconds.
> file # 583 (253560 bytes), reading it took: 4.61 seconds.
> file # 584 (253560 bytes), reading it took: 1.29 seconds.
> file # 585 (253560 bytes), reading it took: 3.01 seconds.
> file # 586 (253560 bytes), reading it took: 7.74 seconds.
> file # 587 (253560 bytes), reading it took: 3.22 seconds.
> file # 588 (253560 bytes), reading it took: 0.05 seconds.
> file # 589 (253560 bytes), reading it took: 0.36 seconds.
> file # 590 (253560 bytes), reading it took: 7.39 seconds.
> file # 591 (253560 bytes), reading it took: 7.58 seconds.
> file # 592 (253560 bytes), reading it took: 7.90 seconds.
> file # 593 (253560 bytes), reading it took: 8.78 seconds.
> file # 594 (253560 bytes), reading it took: 8.01 seconds.
> file # 595 (253560 bytes), reading it took: 7.47 seconds.
> file # 596 (253560 bytes), reading it took: 11.52 seconds.
> file # 597 (253560 bytes), reading it took: 10.33 seconds.
> file # 598 (253560 bytes), reading it took: 8.56 seconds.
> file # 599 (253560 bytes), reading it took: 7.58 seconds.

Did you capture the trace of the long delays in the read test case? It
can be two things, at least. One is that each little read takes much
longer than it should, the other is that we get stuck waiting on a dirty
page and hence that slows down the reads a lot.

-- 
Jens Axboe

