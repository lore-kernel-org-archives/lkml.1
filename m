Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbZFWNjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbZFWNjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZFWNi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:38:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbZFWNiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:38:55 -0400
Date: Tue, 23 Jun 2009 15:38:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090623133851.GB3026@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu> <1245763351.19816.1779.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245763351.19816.1779.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-06-23 at 15:14 +0200, Ingo Molnar wrote:
> > * Brice Goglin <Brice.Goglin@inria.fr> wrote:
> > 
> > > Hello,
> > >
> > > I am trying to play with perfcounters in current git (actually in
> > > latest mmotm). I'd like to reproduce what I previously did with
> > > pfmon, but I couldn't so far.
> > >
> > > Something like
> > >     pfmon --follow-exec 'foobar' -e
> > > CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_0,CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE:LOCAL_TO_1
> > > -- <shell script>
> > > gives the number of memory accesses to dram node #0 and #1 for all
> > > processes whose name matches 'foobar'.
> > >
> > > So there are several questions here:
> > > 1) is it possible to specify counter names like the above or do we have
> > > to use raw counter numbers? I tried raw numbers from [1] without
> > > success. How am I supposed to find and specify these raw numbers?
> > > 2) how do we specify "subevents"?
> > > 3) is there anything similar to --follow-exec, or --follow-pthreads for
> > > getting separated outputs for each thread?
> > >
> > > I guess there are still a lot of things on the TODOlist but I'd 
> > > like to understand a bit more where things are going. Sorry I 
> > > didn't read all the archives about this, there are way too many of 
> > > them recently :)
> > 
> > Yeah, there's indeed still a lot on the TODO list :-)
> > 
> > CPU_TO_DRAM_REQUESTS_TO_TARGET_NODE is a Barcelona hardware event, 
> > so if you know that it maps to raw ID 0x100000e0 then you can always 
> > extend the events that 'perf' knows about via raw events:
> > 
> >  $ perf stat -e cycles -e instructions -e r1000ffe0 ./hackbench 10
> >  Time: 0.186
> > 
> >  Performance counter stats for './hackbench 10':
> > 
> >      4381248335  cycles
> >      1964394846  instructions         #      0.448 IPC
> >             838  raw 0x1000ffe0
> > 
> >     0.215382037  seconds time elapsed.
> 
> Just to clarify, The event code is 1E0h, and Ingo used a FFh unit mask.
> These are combined using the arch masks below:
> 
> #define K7_EVNTSEL_EVENT_MASK   0x7000000FFULL
> #define K7_EVNTSEL_UNIT_MASK    0x00000FF00ULL
> 
> to form the raw event code used: 0x1000ffe0

Yes. The individual node mappings are 01, 02 .. 80 - ff is 'all 8 
nodes'.

	Ingo
