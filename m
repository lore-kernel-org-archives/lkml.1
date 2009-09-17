Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZIQFGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZIQFGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZIQFGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:06:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:43448 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752716AbZIQFGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:06:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/nf74iqZ7np2l5jFREILphpcLCNzulZTIZVCmEpU
	aCzVYHJKEsevyM
Subject: Re: [patchlet] Re: Epic regression in throughput since v2.6.23
From: Mike Galbraith <efault@gmx.de>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1253163339.15767.62.camel@marge.simson.net>
References: <20090906205952.GA6516@elte.hu>
	 <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru>
	 <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru>
	 <20090910065306.GB3920@elte.hu> <87ljkm9yew.fsf@depni.sinp.msu.ru>
	 <20090911061024.GA27833@elte.hu> <87iqfmx3tr.fsf@depni.sinp.msu.ru>
	 <20090916194507.GA27456@elte.hu>  <87fxamiim4.fsf@depni.sinp.msu.ru>
	 <1253163339.15767.62.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 07:06:40 +0200
Message-Id: <1253164000.15767.65.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aw poo, forgot to add Peter to CC list before poking xmit.

On Thu, 2009-09-17 at 06:55 +0200, Mike Galbraith wrote:
> On Wed, 2009-09-16 at 23:18 +0000, Serge Belyshev wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > Ok, i think we've got a handle on that finally - mind checking latest 
> > > -tip?
> > 
> > Kernel build benchmark:
> > http://img11.imageshack.us/img11/4544/makej20090916.png
> > 
> > I have also repeated video encode benchmarks described here:
> > http://article.gmane.org/gmane.linux.kernel/889444
> > 
> > "x264 --preset ultrafast":
> > http://img11.imageshack.us/img11/9020/ultrafast20090916.png
> > 
> > "x264 --preset medium":
> > http://img11.imageshack.us/img11/7729/medium20090916.png
> 
> Pre-ramble..
> Most of the performance differences I've examined in all these CFS vs
> BFS threads boil down to fair scheduler vs unfair scheduler.  If you
> favor hogs, naturally, hogs getting more bandwidth perform better than
> hogs getting their fair share.  That's wonderful for hogs, somewhat less
> than wonderful for their competition.  That fairness is not necessarily
> the best thing for throughput is well known.  If you've got a single
> dissimilar task load running alone, favoring hogs may perform better..
> or not.  What about mixed loads though?  Is the throughput of frequent
> switchers less important than hog throughput?
> 
> Moving right along..
> 
> That x264 thing uncovered an interesting issue within CFS.  That load is
> a frequent clone() customer, and when it has to compete against a not so
> fork/clone happy load, it suffers mightily.  Even when running solo, ie
> only competing against it's own siblings, IFF sleeper fairness is
> enabled, the pain of thread startup latency is quite visible.  With
> concurrent loads, it is agonizingly painful.
> 
> concurrent load test
> tbench 8 vs
> x264 --preset ultrafast --no-scenecut --sync-lookahead 0 --qp 20 -o /dev/null --threads 8 soccer_4cif.y4m
> 
> (i can turn knobs and get whatever numbers i want, including
> outperforming bfs, concurrent or solo.. not the point)
> 
> START_DEBIT
> encoded 600 frames, 44.29 fps, 22096.60 kb/s
> encoded 600 frames, 43.59 fps, 22096.60 kb/s
> encoded 600 frames, 43.78 fps, 22096.60 kb/s
> encoded 600 frames, 43.77 fps, 22096.60 kb/s
> encoded 600 frames, 45.67 fps, 22096.60 kb/s
> 
> 8   1068214   672.35 MB/sec  execute  57 sec
> 8   1083785   672.16 MB/sec  execute  58 sec
> 8   1099188   672.18 MB/sec  execute  59 sec
> 8   1114626   672.00 MB/sec  cleanup  60 sec
> 8   1114626   671.96 MB/sec  cleanup  60 sec
> 
> NO_START_DEBIT
> encoded 600 frames, 123.19 fps, 22096.60 kb/s
> encoded 600 frames, 123.85 fps, 22096.60 kb/s
> encoded 600 frames, 120.05 fps, 22096.60 kb/s
> encoded 600 frames, 123.43 fps, 22096.60 kb/s
> encoded 600 frames, 121.27 fps, 22096.60 kb/s
> 
> 8    848135   533.79 MB/sec  execute  57 sec
> 8    860829   534.08 MB/sec  execute  58 sec
> 8    872840   533.74 MB/sec  execute  59 sec
> 8    885036   533.66 MB/sec  cleanup  60 sec
> 8    885036   533.64 MB/sec  cleanup  60 sec
> 
> 2.6.31-bfs221-smp
> encoded 600 frames, 169.00 fps, 22096.60 kb/s
> encoded 600 frames, 163.85 fps, 22096.60 kb/s
> encoded 600 frames, 161.00 fps, 22096.60 kb/s
> encoded 600 frames, 155.57 fps, 22096.60 kb/s
> encoded 600 frames, 162.01 fps, 22096.60 kb/s
> 
> 8    458328   287.67 MB/sec  execute  57 sec
> 8    464442   288.68 MB/sec  execute  58 sec
> 8    471129   288.71 MB/sec  execute  59 sec
> 8    477643   288.61 MB/sec  cleanup  60 sec
> 8    477643   288.60 MB/sec  cleanup  60 sec
> 
> patchlet:
> 
> sched: disable START_DEBIT.
> 
> START_DEBIT induces unfairness to loads which fork/clone frequently when they
> must compete against loads which do not.
> 
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> 
>  kernel/sched_features.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_features.h b/kernel/sched_features.h
> index d5059fd..2fc94a0 100644
> --- a/kernel/sched_features.h
> +++ b/kernel/sched_features.h
> @@ -23,7 +23,7 @@ SCHED_FEAT(NORMALIZED_SLEEPER, 0)
>   * Place new tasks ahead so that they do not starve already running
>   * tasks
>   */
> -SCHED_FEAT(START_DEBIT, 1)
> +SCHED_FEAT(START_DEBIT, 0)
>  
>  /*
>   * Should wakeups try to preempt running tasks.
> 

