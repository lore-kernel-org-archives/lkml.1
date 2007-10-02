Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXJBPnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXJBPnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXJBPno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:43:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41875 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbXJBPnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:43:43 -0400
Date: Tue, 2 Oct 2007 08:42:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: A unresponsive file system can hang all I/O in the system on
 linux-2.6.23-rc6 (dirty_thresh problem?)
Message-Id: <20071002084239.7371820c.randy.dunlap@oracle.com>
In-Reply-To: <1191332161.13204.70.camel@twins>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	<20070927235034.ae7bd73d.akpm@linux-foundation.org>
	<1190998853.6702.17.camel@heimdal.trondhjem.org>
	<20070928114930.2c201324.akpm@linux-foundation.org>
	<1191005339.18147.89.camel@lappy>
	<20070928121642.56a380ce.akpm@linux-foundation.org>
	<1191332161.13204.70.camel@twins>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 15:36:01 +0200 Peter Zijlstra wrote:

> On Fri, 2007-09-28 at 12:16 -0700, Andrew Morton wrote:
> 
> > (Searches for the lockstat documentation)
> > 
> > Did we forget to do that?
> 
> yeah,...
> 
> /me quickly whips up something

Thanks.  Just some typos noted below.


> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  Documentation/lockstat.txt |  119 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 119 insertions(+)
> 
> Index: linux-2.6/Documentation/lockstat.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6/Documentation/lockstat.txt
> @@ -0,0 +1,119 @@
> +
> +LOCK STATISTICS
> +
> +- WHAT
> +
> +As the name suggests, it provides statistics on locks.
> +
> +- WHY
> +
> +Because things like lock contention can severely impact performance.
> +
> +- HOW
> +
> +Lockdep already has hooks in the lock functions and maps lock instances to
> +lock classes. We build on that. The graph below shows the relation between
> +the lock functions and the various hooks therein.
> +
> +        __acquire
> +            |
> +           lock _____
> +            |        \
> +            |    __contended
> +            |         |
> +            |       <wait>
> +            | _______/
> +            |/
> +            |
> +       __acquired
> +            |
> +            .
> +          <hold>
> +            .
> +            |
> +       __release
> +            |
> +         unlock
> +
> +lock, unlock	- the regular lock functions
> +__*		- the hooks
> +<> 		- states
> +
> +With these hooks we provide the following statistics:
> +
> + con-bounces		- number of lock contention that involved x-cpu data
> + contentions            - number of lock acquisitions that had to wait
> + wait time min          - shortest (non 0) time we ever had to wait for a lock

                                      (non-0)

> +           max          - longest time we ever had to wait for a lock
> +           total        - total time we spend waiting on this lock
> + acq-bounes             - number of lock acquisitions that involved x-cpu data

       -bounces

> + acquisitions		- number of times we took the lock
> + hold time min		- shortest (non 0) time we ever held the lock

                                           (non-0)

> +           max		- longest time we ever held the lock
> +           total	- total time this lock was held
> +
> +From these number various other statistics can be derived, such as:
> +
> + hold time average = hold time total / acquisitions
> +
> +These numbers are gathered per lock class, per read/write state (when
> +applicable).
> +
> +It also tracks (4) contention points per class. A contention point is a call
> +site that had to wait on lock acquisition.
> +
> + - USAGE
> +
> +Look at the current lock statistics:
> +
> +(line numbers not part of actual output, done for clarity in the explanation below)
> +
> +# less /proc/lock_stat
> +
> +01 lock_stat version 0.2
> +02 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> +03                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
> +04 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
...
> +15                              dcache_lock            180          [<ffffffff802c0d7e>] sys_getcwd+0x11e/0x230
> +16                              dcache_lock            165          [<ffffffff802c002a>] d_alloc+0x15a/0x210
> +17                              dcache_lock             33          [<ffffffff8035818d>] _atomic_dec_and_lock+0x4d/0x70
> +18                              dcache_lock              1          [<ffffffff802beef8>] shrink_dcache_parent+0x18/0x130
> +
> +This except shows the first two lock class statistics. Line 01 shows the output

        excerpt

> +version - each time the format changes this will be updated. Line 02-04 show
> +the header with column descriptions. Lines 05-10 and 13-18 show the actual
> +statistics. These statistics come in two parts; the actual stats separated by a
> +short separator (line 08, 14) from the contention points.
> +
> +The first lock (05-10) is a read/write lock, and shows two lines above the
> +short separator. The contention points don't match the column descriptors,
> +they have two: contentions and [<IP>] symbol.
...

---
~Randy
