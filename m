Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZHHMPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZHHMPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 08:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZHHMPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 08:15:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbZHHMPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 08:15:49 -0400
Date: Sat, 8 Aug 2009 14:14:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf report: Display per-thread event counters
Message-ID: <20090808121456.GA14671@elte.hu>
References: <20090629192913.GA29295@elte.hu> <4A7B0C02.7060704@inria.fr> <1249580428.4975.14.camel@laptop> <4A7B175B.8030000@inria.fr> <1249585061.4975.17.camel@laptop> <4A7B28EA.20903@inria.fr> <20090806195924.GA22411@elte.hu> <4A7B68C3.7040706@inria.fr> <20090807063226.GA29532@elte.hu> <4A7C162C.1030707@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7C162C.1030707@inria.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Here's a better patch. I moved everything to utils/values.[ch] so 
> that we may reuse it in perf stat. [...]

Nice patch! I've applied it, you can find it in the latest -tip 
tree:

  http://people.redhat.com/mingo/tip.git/README

please send enhancements/fixes on top of this.

> [...] But I don't see yet where I am suppose to get something like 
> PERF_READ_EVENT in builtin-stat.c so I haven't touched it yet.

Yeah. 'perf stat' is not really getting events but is doing a 
read-out of the counter value(s) and constructs its 'read event' 
that way. So you wont find PERF_READ_EVENT in builtin-stat.c, you'll 
find:

                res = read(fd[cpu][counter], single_count, nv * sizeof(u64));

in read_counter(). The printout is then done in print_counter().

> We get something like this now:
> #  PID   TID  cache-misses  cache-references
>   4658  4659        495581           3238779
>   4658  4662        498246           3236823
>   4658  4663        499531           3243162
> 
> Then it'll be easy to add --pretty=raw to display a single line 
> per thread/event.

ok.

> By the way, -S was also used for --symbol... So I used -T/--thread 
> here.

Hm, indeed - and -s was taken for --sort. Maybe we could rename 
-S/--symbols to -y/--symbols - this too is an i think rarely used 
feature.

I think pure 'statistics' runs like you do will be a pretty popular 
workflow, so intuitive naming/placement of options is important.

> perf report: Add -T/--threads to display per-thread counter values
>     
> We get something like this now:
> #  PID   TID  cache-misses  cache-references
>   4658  4659        495581           3238779
>   4658  4662        498246           3236823
>   4658  4663        499531           3243162

Btw., another thing to do would be to allow the 'dual' recording of 
both the stat values (collected when threads exit) and regular 
samples that perf report deals with.

I.e. dont handle 'perf record -s' as an exclusive thing to regular 
'perf record', but instead have -s/--sample-type option that can 
have such combinations:

  -s stats
  -s samples
  -s call-graph

And any combination thereof, such as:

  -s stats,samples

The default would be '-s samples'. Right now call-graph recording is 
triggered via a separate option (-g/--call-graph) - but maybe it 
could be merged into a more generic -s/--sample option mechanism?

	Ingo
