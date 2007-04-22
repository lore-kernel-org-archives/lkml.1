Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXDVIIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXDVIIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXDVIIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:08:19 -0400
Received: from 1wt.eu ([62.212.114.60]:2165 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965521AbXDVIIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:08:17 -0400
Date: Sun, 22 Apr 2007 10:06:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Message-ID: <20070422080607.GA15411@1wt.eu>
References: <200704221441.48897.kernel@kolivas.org> <20070422070037.GA15092@1wt.eu> <200704221727.44430.kernel@kolivas.org> <200704221731.58724.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704221731.58724.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 05:31:58PM +1000, Con Kolivas wrote:
> On Sunday 22 April 2007 17:27, Con Kolivas wrote:
> > On Sunday 22 April 2007 17:00, Willy Tarreau wrote:
> > > On Sun, Apr 22, 2007 at 02:41:48PM +1000, Con Kolivas wrote:
> > > > A significant bugfix for SMP balancing was just posted for the
> > > > staircase deadline cpu scheduler which improves behaviour dramatically
> > > > on any SMP machine.
> > > >
> > > > Thanks to Willy Tarreau for noticing likely fault point.
> > > >
> > > > Also requested was a version in the Makefile so this version of the
> > > > patch adds -sd045 to the kernel version.
> > >
> > > Con, I'm sorry, but it is worse with this one :-(
> >
> > Well that was quick testing, thanks.
> >
> > > The lag when typing in xterms is even more noticeable and vmstat output
> > > oscillates between 8 and 65, with idle rates around 50%, as you can see
> > > below :
> > >
> > > Renicing X or not does not change anything here.
> > >
> > > I suspect that the bug you fixed was hiding another one :-/
> > > If you want me to test another patch, feel free to ask.
> 
> Just as a debug point could you please try this patch? Thanks.

OK, this time, the ocbench took ages to start. They appeared immediately
but very few of them (less than 8 out of 64) really started to work. The
system remained very responsive and smooth during the test. But I guess
I know why : all the load was sent to CPU 0 :

   procs                      memory      swap          io     system      cpu
 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
63  0  0      0 923476   6516  57456    0    0     0    28  175  1281 14 26 59
64  0  2      0 922976   6516  57456    0    0     0     0    4   261 19 31 50
64  0  0      0 922924   6516  57492    0    0     0     0    1    85 17 33 50
64  0  0      0 922924   6516  57492    0    0     0     0    0   110 25 25 50
64  0  1      0 922924   6516  57492    0    0     0     0    3    83 24 27 50
64  0  0      0 922924   6516  57492    0    0     0     4   16   267 18 33 50
64  0  0      0 922924   6516  57492    0    0     0     0   15   244 24 27 50
64  0  0      0 922956   6516  57492    0    0     0     0    8   200 20 31 49
59  0  0      0 922956   6516  57492    0    0     0     0    1    98 18 34 49
59  0  0      0 922956   6516  57492    0    0     0     0    0   105 21 30 49
64  0  0      0 922956   6516  57492    0    0     0     0    1    97 19 32 49
62  0  0      0 922972   6516  57492    0    0     0     0    0   114 23 28 49
64  0  0      0 922972   6516  57492    0    0     0     0    1    95 23 28 49
64  0  0      0 922972   6516  57492    0    0     0     0    0   104 22 29 49


CPU0 states:  45.0% user  54.0% system    0.0% nice   0.0% iowait   0.0% idle
CPU1 states:   0.1% user   0.0% system    0.0% nice   0.0% iowait  99.0% idle
Mem:  1034876k av,  112296k used,  922580k free,       0k shrd,    6524k buff
        34232k active,              45428k inactive
Swap:  497972k av,       0k used,  497972k free                   57536k cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME CPU COMMAND
 1402 willy     31   0  2272  640   548 R     2.9  0.0   0:00   0 ocbench
 1407 willy     31   0  2272  640   548 R     2.9  0.0   0:00   0 ocbench
 1452 willy     31   0  2272  640   548 R     2.9  0.0   0:00   0 ocbench
 1455 willy     31   0  2272  640   548 R     2.9  0.0   0:00   0 ocbench
 1394 willy     29   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1395 willy     29   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1396 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1400 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1401 willy     29   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1404 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1408 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1409 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1411 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1412 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench
 1413 willy     31   0  2272  640   548 R     1.9  0.0   0:00   0 ocbench


Willy

