Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZGDOFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZGDOFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 10:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZGDOFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 10:05:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:36617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZGDOFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 10:05:36 -0400
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
In-Reply-To: <20090704100331.GC2139@elte.hu>
References: <1246441043.3403.9.camel@hpdv5.satnam>
	 <20090701112007.GD15958@elte.hu> <20090701112704.GF15958@elte.hu>
	 <1246448441.6940.3.camel@hpdv5.satnam> <20090701114928.GI15958@elte.hu>
	 <1246527872.13659.2.camel@hpdv5.satnam> <20090703102953.GF32128@elte.hu>
	 <1246622122.2322.25.camel@jaswinder.satnam>
	 <1246625377.3088.10.camel@hpdv5.satnam>
	 <1246627555.2322.42.camel@jaswinder.satnam> <20090704100331.GC2139@elte.hu>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 19:35:07 +0530
Message-Id: <1246716307.2329.18.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-04 at 12:03 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > > > > I.e. do we have this 
> > > > > general relationship to the cycle event:
> > > > > 
> > > > > 	cycles = vec-stall-cycles + vec-idle-cycles
> > > > > 
> > > > > ?
> > > 
> > > Like on AMD :
> > > 
> > >     13390918485  vec-adds                  (scaled from 57.07%)
> > >     22465091289  vec-muls                  (scaled from 57.22%)
> > >      2643789384  vec-divs                  (scaled from 57.21%)
> > >     17922784596  vec-idle-cycles           (scaled from 57.23%)
> > >      6402888606  vec-stall-cycles          (scaled from 57.17%)
> > >     55823491597  cycles                    (scaled from 57.05%)
> > >     51035264218  vec-ops                   (scaled from 57.05%)
> > > 
> > >   187.494664172  seconds time elapsed
> > > 
> > > vec-idle-cycles + vec-stall-cycles = 24325673202
> > > 
> > > so cycles = 2.29 * (vec-idle-cycles + vec-stall-cycles)
> 
> that equation is entirely bogus.
> 

What is bogus ? in this case this equation is true and it depends on
each application.

> > > 
> > > On AMD I used : EventSelect 0D7h Dispatch Stall for FPU Full The 
> > > number of processor cycles the decoder is stalled because the 
> > > scheduler for the Floating Point Unit is full. This condition 
> > > can be caused by a lack of parallelism in FP-intensive code, or 
> > > by cache misses on FP operand loads (which could also show up as 
> > > EventSelect 0D8h instead, depending on the nature of the 
> > > instruction sequences). May occur simultaneously with certain 
> > > other stall conditions; see EventSelect 0D1h
> > > 
> > > So stall is due to lack of parallelism and cache misses. If we 
> > > keep on increasing the size of FP units and cache may at some 
> > > point be we can get vec-stall-cycles = zero.
> > > 
> > 
> > I mean, So stall is majorly due to lack of parallelism and cache 
> > misses. If we keep on increasing the size of FP units and cache 
> > then stall time will keep on decreasing (ofcourse it will be never 
> > Zero ;)
> > 
> > And same thing will be happen for Intel.
> > 
> > So stall is not equal to busy.
> > 
> > Please let me know what is next, should I remove busy term from 
> > alias.
> 
> What is needed is for you to understand these events and provide a 
> generalization around them that makes sense. Or to declare it 
> honestly when you dont.
> 

what ??

tell me where is the problem, Is there any problem is patch.

> The numbers simply dont add up:
> 
> > >     13390918485  vec-adds                  (scaled from 57.07%)
> > >     22465091289  vec-muls                  (scaled from 57.22%)
> > >      2643789384  vec-divs                  (scaled from 57.21%)
> > >     17922784596  vec-idle-cycles           (scaled from 57.23%)
> > >      6402888606  vec-stall-cycles          (scaled from 57.17%)
> > >     55823491597  cycles                    (scaled from 57.05%)
> > >     51035264218  vec-ops                   (scaled from 57.05%)
> 
> vec-idle-cycles + vec-stall-cycles does not add up to cycles - 
> because a stall is not an 'interchangeable' term with 'busy' as you 
> claimed before, but a special state of the pipeline, a subset of 
> busy.
> 
> I prefer to apply patches from people who understand what they are 
> doing - and more importantly, who express and declare their own 
> limits properly when they _dont_ understand something and are 
> guessing.
> 

what is the problem in understanding. You raised the question, so you
was confused not me. And you got the clear picture from my points and
you are still blaming me ?


> Frankly, your patches dont give me this impression and you are also 
> babbling way too much about things you clearly dont understand, and 
> thus you hinder the discussions with noise.
> 
> It's not bad at all to not understand something (we all are at 
> various stages of a big and constantly refreshing learning curves), 
> but it's very bad to pretend you understand something while you 
> clearly dont. What we need in lkml discussions is an honest laying 
> down of facts, opinions and doubts.
> 
> Why the heck didnt you say:
> 
>  " I dont know much about PMUs or vector units yet, but I have found
>    these blurbs in the Intel and AMD docs and what do you think 
>    about structuring these events the following way. Someone who 
>    knows this stuff should review this first, it is quite likely 
>    incomplete. "


Why should I say this. Its you who need to say this.

I have clear understand that why I came up with this patch.

Thanks,
--
JSR

