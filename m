Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZJCRgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZJCRgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZJCRgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:36:11 -0400
Received: from brick.kernel.dk ([93.163.65.50]:32905 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZJCRgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:36:10 -0400
Date: Sat, 3 Oct 2009 19:35:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
	controller V10)
Message-ID: <20091003173532.GG31616@kernel.dk>
References: <1254549378.8299.21.camel@marge.simson.net> <20091003112915.GA12925@redhat.com> <20091003124049.GB12925@redhat.com> <20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com> <1254578553.7499.5.camel@marge.simson.net> <20091003142840.GE31616@kernel.dk> <1254581496.8293.8.camel@marge.simson.net> <20091003151445.GF31616@kernel.dk> <1254585420.7539.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254585420.7539.2.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03 2009, Mike Galbraith wrote:
> On Sat, 2009-10-03 at 17:14 +0200, Jens Axboe wrote:
> > On Sat, Oct 03 2009, Mike Galbraith wrote:
> > > On Sat, 2009-10-03 at 16:28 +0200, Jens Axboe wrote:
> > > > On Sat, Oct 03 2009, Mike Galbraith wrote:
> > > > > On Sat, 2009-10-03 at 09:56 -0400, Vivek Goyal wrote:
> > > > > 
> > > > > > I have kept the overload delay period as "cfq_slice_sync" same as Mike had
> > > > > > done. We shall have to experiment what is a good waiting perioed. Is 100ms
> > > > > > too long if we are waiting for a request from same process which recently
> > > > > > finished IO and we did not enable idle on it.
> > > > > > 
> > > > > > I guess we can tweak the delay period as we move along.
> > > > > 
> > > > > I kept the delay period very short to minimize possible damage. Without
> > > > > the idle thing, it wasn't enough, but with, worked a treat, as does your
> > > > > patch.
> > > > 
> > > > Can you test the current line up of patches in for-linus? It has the
> > > > ramp up I talked about included as well.
> > > 
> > > Well, it hasn't hit git.kernel.org yet, it's at...
> > > 
> > > * block-for-linus        1d22351 cfq-iosched: add a knob for desktop interactiveness
> > 
> > It's the top three patches here, kernel.org sync sometimes takes a
> > while...
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-linus
> 
> Ok, already had the first two in, added the last.
> 
> Entered uncharted territory for konsole -e exit, but lost a bit of
> throughput for home-brew concurrent git test.
> 
> perf stat      1.70     1.94     1.32     1.89     1.87    1.7     fairness=1 overload_delay=1
>                1.55     1.79     1.38     1.53     1.57    1.5     desktop=1 +last_end_sync
>                1.09     0.87     1.11     0.96     1.11    1.0     block-for-linus

So that's pure goodness, at least.

> perf stat testo.sh                               Avg
> 108.12   106.33    106.34    97.00    106.52   104.8  1.000 fairness=0 overload_delay=0
>  93.98   102.44     94.47    97.70     98.90    97.4   .929 fairness=0 overload_delay=1
>  90.87    95.40     95.79    93.09     94.25    93.8   .895 fairness=1 overload_delay=0
>  89.93    90.57     89.13    93.43     93.72    91.3   .871 fairness=1 overload_delay=1
>  89.81    88.82     91.56    96.57     89.38    91.2   .870 desktop=1 +last_end_sync
>  92.61    94.60     92.35    93.17     94.05    93.3   .890 block-for-linus

Doesn't look too bad, all things considered. Apart from "stock" cfq,
it's consistent. And being consistent is a Good Thing. Performance wise,
it's losing out to "stock" but looks pretty competetive otherwise.

So far that looks like a winner. The dictator wanted good latency, he's
getting good latency. I'll continue working on this on monday, while I'm
waiting for delivery of the Trabant.

-- 
Jens Axboe

