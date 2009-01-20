Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZATMea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZATMea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZATMeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:34:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:50114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbZATMeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:34:20 -0500
Date: Tue, 20 Jan 2009 13:34:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120123418.GG19505@wotan.suse.de>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120112634.GA20858@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 12:26:34PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Hi,
> > 
> > I'm looking at regressions since 2.6.16, and one is lat_mmap has slowed 
> > down. On further investigation, a large part of this is not due to a 
> > _regression_ as such, but the introduction of CONFIG_PARAVIRT=y.
> > 
> > Now, it is true that lat_mmap is basically a microbenchmark, however it 
> > is exercising the memory mapping and page fault handler paths, so we're 
> > talking about pretty important paths here. So I think it should be of 
> > interest.
> > 
> > I've run the tests on a 2s8c AMD Barcelona system, binding the test to 
> > CPU0, and running 100 times (stddev is a bit hard to bring down, and my 
> > scripts needed 100 runs in order to pick up much smaller changes in the 
> > results -- for CONFIG_PARAVIRT, just a couple of runs should show up the 
> > problem).
> > 
> > Times I believe are in nanoseconds for lmbench, anyway lower is better.
> > 
> > non pv   AVG=464.22 STD=5.56
> > paravirt AVG=502.87 STD=7.36
> > 
> > Nearly 10% performance drop here, which is quite a bit... hopefully 
> > people are testing the speed of their PV implementations against non-PV 
> > bare metal :)
> 
> Ouch, that looks unacceptably expensive. All the major distros turn 
> CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
> promise to have no measurable runtime overhead.
> 
> ( And i suspect the real life mmap cost is probably even more expensive,
>   as on a Barcelona all of lmbench fits into the cache hence we dont see
>   any real $cache overhead. )

The PV kernel has over 100K larger text size, nearly 40K alone in mm/ and
kernel/. Definitely we don't see the worst of the icache or branch buffer 
overhead on this microbenchmark. (wow, that's a nasty amount of bloat :( )

 
> Jeremy, any ideas where this slowdown comes from and how it could be 
> fixed?

I had a bit of a poke around the profiles, but nothing stood out. However
oprofile counted 50% more cycles in the kernel with PV than with non-PV.
I'll have to take a look at the user/system times, because 50% seems
ludicrous.... hopefully it's just oprofile noise.
