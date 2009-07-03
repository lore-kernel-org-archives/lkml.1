Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbZGCN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbZGCN0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZGCN0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:26:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:38615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZGCN03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:26:29 -0400
Subject: Re: [PATCH 1/2 -tip] perf_counter: Add generalized hardware
 vectored co-processor support for AMD and Intel Corei7/Nehalem
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1246625377.3088.10.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
	 <20090701114928.GI15958@elte.hu> <1246527872.13659.2.camel@hpdv5.satnam>
	 <20090703102953.GF32128@elte.hu>
	 <1246622122.2322.25.camel@jaswinder.satnam>
	 <1246625377.3088.10.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 18:55:55 +0530
Message-Id: <1246627555.2322.42.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 18:19 +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-07-03 at 17:25 +0530, Jaswinder Singh Rajput wrote:
> > On Fri, 2009-07-03 at 12:29 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > >  Performance counter stats for '/usr/bin/rhythmbox /home/jaswinder/Music/singhiskinng.mp3':
> > > > 
> > > >        17552264  vec-adds                  (scaled from 66.28%)
> > > >        19715258  vec-muls                  (scaled from 66.63%)
> > > >        15862733  vec-divs                  (scaled from 66.82%)
> > > >     23735187095  vec-idle-cycles           (scaled from 66.89%)
> > > >        11353159  vec-stall-cycles          (scaled from 66.90%)
> > > >        36628571  vec-ops                   (scaled from 66.48%)
> > > 
> > > Is stall-cycles equivalent to busy-cycles? 
> > 
> > 
> > hmm, normally we can use these terms interchangeably. But they can be
> > different some times.
> > 
> > busy means it is already executing some instructions so it will not take
> > another instruction.
> > 
> > stall can be busy(executing) or non-executing may be it is waiting for
> > some operands due to cache miss.
> > 
> > 
> > > I.e. do we have this 
> > > general relationship to the cycle event:
> > > 
> > > 	cycles = vec-stall-cycles + vec-idle-cycles
> > > 
> > > ?
> 
> Like on AMD :
> 
>     13390918485  vec-adds                  (scaled from 57.07%)
>     22465091289  vec-muls                  (scaled from 57.22%)
>      2643789384  vec-divs                  (scaled from 57.21%)
>     17922784596  vec-idle-cycles           (scaled from 57.23%)
>      6402888606  vec-stall-cycles          (scaled from 57.17%)
>     55823491597  cycles                    (scaled from 57.05%)
>     51035264218  vec-ops                   (scaled from 57.05%)
> 
>   187.494664172  seconds time elapsed
> 
> vec-idle-cycles + vec-stall-cycles = 24325673202
> 
> so cycles = 2.29 * (vec-idle-cycles + vec-stall-cycles)
> 
> On AMD I used : EventSelect 0D7h Dispatch Stall for FPU Full
> The number of processor cycles the decoder is stalled because the
> scheduler for the Floating Point Unit is full. This condition can be
> caused by a lack of parallelism in FP-intensive code, or by cache misses
> on FP operand loads (which could also show up as EventSelect 0D8h
> instead, depending on the nature of the instruction sequences). May
> occur simultaneously with certain other stall conditions; see
> EventSelect 0D1h
> 
> So stall is due to lack of parallelism and cache misses.
> If we keep on increasing the size of FP units and cache may at some
> point be we can get vec-stall-cycles = zero.
> 

I mean, So stall is majorly due to lack of parallelism and cache misses.
If we keep on increasing the size of FP units and cache then stall time
will keep on decreasing (ofcourse it will be never Zero ;)

And same thing will be happen for Intel.

So stall is not equal to busy.

Please let me know what is next, should I remove busy term from alias.

Thanks,
--
JSR

