Return-Path: <linux-kernel-owner+w=401wt.eu-S2993225AbXDSKW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993225AbXDSKW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 06:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030949AbXDSKW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 06:22:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030925AbXDSKW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 06:22:56 -0400
Date: Thu, 19 Apr 2007 12:22:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Al Boldi <a1426z@gawab.com>,
       Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Gene Heskett <gene.heskett@gmail.com>, Willy Tarreau <w@1wt.eu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Announce - Staircase Deadline cpu scheduler v0.42
Message-ID: <20070419102245.GD14885@wotan.suse.de>
References: <200704190959.06432.kernel@kolivas.org> <200704191212.15151.kernel@kolivas.org> <20070419032204.GA487@wotan.suse.de> <200704191940.04715.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704191940.04715.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 07:40:04PM +1000, Con Kolivas wrote:
> On Thursday 19 April 2007 13:22, Nick Piggin wrote:
> > On Thu, Apr 19, 2007 at 12:12:14PM +1000, Con Kolivas wrote:
> > > Version 0.42
> > >
> > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.42.patch
> >
> > OK, I run some tests later today...
> 
> 
> Thank you very much.

lmbench numbers are roughly comparable to mainline (lmbench seems to be
a bit erratic, but there isn't the obvious drop that cfs has).

Didn't worry about hackbench ;)

kbuild:
2.6.21-rc7
508.87user 32.47system 2:17.82elapsed 392%CPU
509.05user 32.25system 2:17.84elapsed 392%CPU
508.75user 32.26system 2:17.83elapsed 392%CPU
508.63user 32.17system 2:17.88elapsed 392%CPU
509.01user 32.26system 2:17.90elapsed 392%CPU
509.08user 32.20system 2:17.95elapsed 392%CPU

2.6.21-rc7-sd42
512.78user 31.99system 2:18.41elapsed 393%CPU
512.55user 31.90system 2:18.57elapsed 392%CPU
513.05user 31.78system 2:18.48elapsed 393%CPU
512.46user 32.06system 2:18.63elapsed 392%CPU
512.78user 31.81system 2:18.49elapsed 393%CPU
512.41user 32.08system 2:18.70elapsed 392%CPU

sd42 is doing about 745 context switches per second here, and perfomance is
slightly below mainline. But it isn't doing badly.

507.87user 32.53system 2:17.50elapsed 392%CPU
508.47user 32.40system 2:17.56elapsed 393%CPU
508.59user 32.27system 2:17.53elapsed 393%CPU 

A few runs with rr_interval at 100 show that ctxsw numbers drop to 587, and
performance is up to slightly above mainline.

With the results I've got so far with all scedulers (actually I didn't try
nicksched with a small timeslice, but I'm sure it would give the expected
result)... I'd say 5ms might be too small a timeslice. Even 15ms will hurt
some people I think.

Although we could arguably tolerate this kind of regression, my box only
has 1MB caches, and kbuild is naturally context switching at over 500 per
second anyway. On something with bigger caches and less context switchy /
more cache sensitive workloads, the regression could be quite a bit worse.

(not directed at anyone in particular, but food for thought)
