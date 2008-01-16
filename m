Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYAPPf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYAPPf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYAPPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:35:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYAPPfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:35:19 -0500
Date: Wed, 16 Jan 2008 16:35:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Colin Fowler <elethiomel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive
	benchmark on 8 Core Xeon
Message-ID: <20080116153505.GB18553@elte.hu>
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com> <20080114185520.GA26540@elte.hu> <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com> <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com> <20080115220641.GC2665@elte.hu> <cf3edd8d0801151505r54bfd9d0r89f57e3835f295e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3edd8d0801151505r54bfd9d0r89f57e3835f295e1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Colin Fowler <elethiomel@gmail.com> wrote:

> > and context-switches 45K times a second. Do you know what is going 
> > on there? I thought ray-tracing is something that can be 
> > parallelized pretty efficiently, without having to contend and 
> > schedule too much.
> 
> This is a RTRT (real-time ray tracing) system and as a result differs 
> from traditional offline ray-tracers as it is optimised for speed. The 
> benchmark I ran while these data were collected renders an 80K polygon 
> scene to a 512x512 buffer at just over 100fps.
> 
> The context switches are most likely caused by the pthreads 
> synchronisation code. There are two mutexs. Each job is a 32x32 tile 
> and each mutex is therefore unlocked (512/32) * (512/32) * 100 (for 
> 100fps) * 2 =~50k. There's very likely where our context switches are 
> coming from. Larger tile sizes would of course reduce the locking 
> overhead, but then the ray-tracer suffers form load imbalance as some 
> tiles are much quicker to render than others. Empircally we've found 
> that this tile-size works the best for us.
> 
> The CPU idling occurs as the system doesn't yet perform asynchronous 
> rendering. When all tiles in a current job queue are finished the 
> current frame is done. At this point all worker threads sleep while 
> the master thread blits the image to the screen and fills the job 
> queue for the next frame. The data probably shows that one CPU is kept 
> maxed and the others reach about 90% most of the time. This is 
> something on my TODO list to fix along with a myriad of other 
> optimisations :)

is this something i could run myself and see how it behaves with various 
scheduler settings? (if yes, where can i download it and is there any 
sample scene that would show similar effects.)

	Ingo
