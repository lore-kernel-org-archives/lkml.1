Return-Path: <linux-kernel-owner+w=401wt.eu-S2993139AbXCIVIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993139AbXCIVIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993141AbXCIVIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:08:05 -0500
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:46186 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993139AbXCIVID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:08:03 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Date: Sat, 10 Mar 2007 08:07:43 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
References: <20070309053931.GA10459@waste.org> <200703091939.05535.kernel@kolivas.org> <20070309204623.GE10394@waste.org>
In-Reply-To: <20070309204623.GE10394@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100807.43582.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 07:46, Matt Mackall wrote:
> Ok, I've now disabled sched_yield (I'm using xorg radeon drivers).

Great.

> So far:
>
>           rc2-mm2   RSDL  RSDL+NO_HZ  RSDL+NO_HZ+no_yield  estimated CPU
> no load
>  beryl    good      good  great       great                ~30% at 600MHz
>  galeon   good      good  good        good                 100% at 600MHz
>  mp3      good      good  good        good                 < 5% at 600MHz
>  terminal good      good  good        good                 ~0
>  mouse    good      good  good        good                 ~0
> make
>  beryl              awful ok          good
>  galeon             bad   ok          good
>  mp3                good  good        good
>  terminal           bad   good        good
>  mouse              bad   good        good

It's sad that sched_yield is still in our graphics card drivers ...

> make -j2
>  beryl              awful             bad/ok
>  metacity                             bad/ok  <- it's not beryl-specifc
>  galeon             bad               bad/ok
>  mp3                good              good
>  terminal           bad               bad/ok
>  mouse              bad               bad/ok
> make -j5
>  beryl    ok        awful awful       awful/bad
>  galeon   ok        bad   bad         bad
>  mp3      good      good  good        a couple skips
>  terminal ok        bad   bad         bad
>  mouse    good      bad   bad         bad
> memload x5
>  beryl                                ok/good
>  galeon                               ok/good
>  mp3                                  good
>  terminal                             ok/good
>  mouse                                ok/good
>
>
> good = no problems
> ok = noticeable latency
> bad = hard to use
> awful = completely unusable
>
> By the way, make -j5 is my usual kernel compile because it gives me
> the best wall time on this box.
>
> A priori, this load should be manageable by RSDL as the interactive
> loads are all pretty small. So I wrote a little Python script that
> basically continuously memcpys some 16MB chunks of memory:
>
> #!/usr/bin/python
> a = "a" * 16 * 1024 * 1024
> while 1:
>     b = a[1:] + "b"
>     a = b[1:] + "c"
>
> I've got 1.5G of RAM, so I can run quite a few of these without
> killing my pagecache. This should test whether a) Beryl's actually
> running up against memory bandwidth issues and b) whether "simple"
> static loads work. As you can see, running 5 instances of this script
> leaves me in good shape still. 10 is still in "ok" territory, with top
> showing each getting 9.7-10% of the CPU. 15 starts to feel sluggish.
> 20 the mouse jumps a bit and I got an MP3 skip. 30 is getting pretty
> bad, but still not as bad as the make -j 5 load.
>
> My suspicion is the problem lies in giving too much quanta to
> newly-started processes.

Ah that's some nice detective work there. Mainline does some rather complex 
accounting on sched_fork including (possibly) a whole timer tick which rsdl 
does not do. make forks off continuously so what you say may well be correct. 
I'll see if I can try to revert to the mainline behaviour in sched_fork 
(which was obviously there for a reason).

-- 
-ck
