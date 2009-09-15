Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZIOKr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZIOKr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZIOKry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:47:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:36383 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752031AbZIOKrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:47:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19hohY7AQphZhqwp2JmpgpPLFkdNqKicphnfaTJoB
	SB55grL9nayAnU
Subject: Re: More BFS benchmarks and scheduler issues
From: Mike Galbraith <efault@gmx.de>
To: Jason Garrett-Glaser <darkshikari@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <28f2fcbc0909141529n4ee32d6t47ca8bdaf02dad@mail.gmail.com>
References: <28f2fcbc0909141529n4ee32d6t47ca8bdaf02dad@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 12:47:47 +0200
Message-Id: <1253011667.9128.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 15:29 -0700, Jason Garrett-Glaser wrote:
> As an x264 developer, I have no position on the whole debate over
> BFS/CFS (nor am I a kernel hacker), but a friend of mine recently ran
> this set of tests with BFS vs CFS that still doesn't make any sense to
> me and suggests some sort of serious suboptimality in the existing
> scheduler:

Yup, I confirmed your friend's results.

> >>>>>>>>>>>>>>>>>>
> 
> Background information necessary to replicate test:
> 
> Input file: http://media.xiph.org/video/derf/y4m/soccer_4cif.y4m
> x264 source: git://git.videolan.org/x264.git
> revision of x264 used: e553a4c
> CPU: Core 2 Quad Q9300 (2.5GHz)
> Kernel/distro/platform: 2.6.31 patched with the gentoo patchset, Gentoo, x86_64.
> BFS patch: Latest available (BFS 220).
> Methodology: Each test was run 3 times. The median of the three was
> then selected.
> 
> ./x264/x264 --preset ultrafast --no-scenecut --sync-lookahead 0 --qp
> 20 samples/soccer_4cif.y4m -o /dev/null --threads X
>     BFS                 CFS
> 1: 124.79 fps       131.69 fps
> 2: 252.14 fps       192.14 fps
> 3: 376.55 fps       223.24 fps
> 4: 447.69 fps       242.54 fps
> 5: 447.98 fps       252.43 fps
> 6: 447.87 fps       253.56 fps
> 7: 444.79 fps       250.37 fps
> 8: 441.08 fps       251.95 fps

After a bit of testing, it turns out that NEXT_BUDDY and LB_BIAS
features are _both_ doing injury to this load.  We've been looking at
NEXT_BUDDY, but LB_BIAS is a new target.

Thanks a bunch for the nice repeatable testcase!

	-Mike

x264 --preset ultrafast --no-scenecut --sync-lookahead 0 --qp 20 -o /dev/null --threads $THREADS soccer_4cif.y4m

2.6.32-tip-smp
4  encoded 600 frames, 280.07 fps, 22096.60 kb/s
   encoded 600 frames, 280.67 fps, 22096.60 kb/s
   encoded 600 frames, 274.80 fps, 22096.60 kb/s

8  encoded 600 frames, 269.57 fps, 22096.60 kb/s
   encoded 600 frames, 282.96 fps, 22096.60 kb/s
   encoded 600 frames, 279.66 fps, 22096.60 kb/s

2.6.31-bfs221-smp
4  encoded 600 frames, 408.38 fps, 22096.60 kb/s
   encoded 600 frames, 409.17 fps, 22096.60 kb/s
   encoded 600 frames, 407.50 fps, 22096.60 kb/s

8  encoded 600 frames, 409.82 fps, 22096.60 kb/s
   encoded 600 frames, 413.00 fps, 22096.60 kb/s
   encoded 600 frames, 411.10 fps, 22096.60 kb/s

test test test...

2.6.32-tip-smp NO_NEXT_BUDDY NO_LB_BIAS
4  encoded 600 frames, 418.07 fps, 22096.60 kb/s
   encoded 600 frames, 418.72 fps, 22096.60 kb/s
   encoded 600 frames, 419.10 fps, 22096.60 kb/s

8  encoded 600 frames, 425.75 fps, 22096.60 kb/s
   encoded 600 frames, 425.45 fps, 22096.60 kb/s
   encoded 600 frames, 422.49 fps, 22096.60 kb/s


