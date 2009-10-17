Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZJQBhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZJQBhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 21:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZJQBhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 21:37:41 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43834 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZJQBhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 21:37:41 -0400
Subject: Re: -rt dbench scalabiltiy issue
From: john stultz <johnstul@us.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Darren Hart <dvhltc@us.ibm.com>,
       Clark Williams <williams@redhat.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1255741421.5135.145.camel@localhost.localdomain>
References: <1255723519.5135.121.camel@localhost.localdomain>
	 <20091017004505.GI6720@linux.vnet.ibm.com>
	 <1255741421.5135.145.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 18:37:36 -0700
Message-Id: <1255743456.5135.162.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 18:03 -0700, john stultz wrote:
> On Fri, 2009-10-16 at 17:45 -0700, Paul E. McKenney wrote:
> > On Fri, Oct 16, 2009 at 01:05:19PM -0700, john stultz wrote:
> > > See http://lwn.net/Articles/354690/ for a bit of background here.
> > > 
> > > I've been looking at scalability regressions in the -rt kernel. One easy
> > > place to see regressions is with the dbench benchmark. While dbench can
> > > be painfully noisy from run to run, it does clearly show some severe
> > > regressions with -rt. 
> > > 
> > > There's a chart in the article above that illustrates this, but here's
> > > some specific numbers on an 8-way box running dbench-3.04 as follows: 
> > > 
> > > ./dbench 8 -t 10 -D . -c client.txt 2>&1 
> > > 
> > > I ran both on an ext3 disk and a ramfs mounted directory.
> > > 
> > > (Again, the numbers are VERY rough due to the run-to-run variance seen)
> > > 
> > > 			ext3		ramfs 
> > > 2.6.32-rc3:		~1800 MB/sec	~1600 MB/sec
> > > 2.6.31.2-rt13: 		~300 MB/sec	~66 MB/sec
> > > 
> > > Ouch. Similar to the charts in the LWN article.
> > > 
> > > Dino pointed out that using lockstat with -rt, we can see the
> > > dcache_lock is fairly hot with the -rt kernel. One of the issues with
> > > the -rt tree is that the change from spinlocks to sleeping-spinlocks
> > > doesn't effect the un-contended case very much, but when there is
> > > contention on the lock, the overhead is much worse then with vanilla.
> > > 
> > > And as noted at the realtime mini-conf, Ingo saw this dcache_lock
> > > bottleneck as well and suggested trying Nick Piggin's dcache_lock
> > > removal patches.
> > > 
> > > So over the last week, I've ported Nick's fs-scale patches to -rt. 
> > > 
> > > Specifically the tarball found here:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/06102009.tar.gz
> > > 
> > > 
> > > Due to the 2.6.32 2.6.31-rt split, the port wasn't exactly straight
> > > forward, but I believe I managed to do a decent job. Once I had the
> > > patchset applied, building and booted, I eagerly ran dbench to see the
> > > new results, aaaaaand.....
> > > 
> > > 			ext3		ramfs 
> > > 2.6.31.2-rt13-nick:	~80 MB/sec	~126 MB/sec
> > > 
> > > 
> > > So yea, mixed bag there. The ramfs got a little bit better but not that
> > > much, and the ext3 numbers regressed further.
> > 
> > OK, I will ask the stupid question...  What happens if you run on ext2?
> 
> Yep. That was next on my list. Basically its faster, but the regressions
> are similar % wise with each patchset.
> 
> 			ext3		ext2
> 2.6.32-rc3:		~1800 MB/sec	~2900 MB/sec
> 2.6.31.2-rt13:		~300 MB/sec	~600 MB/sec
> 2.6.31.2-rt13-nick:	~80 MB/sec	~130 MB/sec

Additionally looking at the perf data, it does seem the dcache_lock is
the contention point w/ ext2 on -rt13, but with Nick's patch, the
contention still stays mostly in the dput/path_get functions. So it
seems its just been moved rather then eased with _my port_ of Nick's
patch (emphasis on "my port", since with nick's patch against mainline
there is no regression at all.. I don't want to drag Nick's patches
through the mud here :)

thanks
-john

