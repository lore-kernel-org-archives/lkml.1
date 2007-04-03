Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXDCFbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXDCFbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXDCFbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:31:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:37602 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752694AbXDCFbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:31:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18pv0wa/7Yp8x7vjya74pWqVjyyUTBMRSaeY/1/Fs
	q77/ubXiXvP99x
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704031237.21946.kernel@kolivas.org>
References: <200703290237.38777.kernel@kolivas.org>
	 <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <200704031237.21946.kernel@kolivas.org>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 07:31:10 +0200
Message-Id: <1175578270.6342.12.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 12:37 +1000, Con Kolivas wrote:
> On Thursday 29 March 2007 15:50, Mike Galbraith wrote:
> > On Thu, 2007-03-29 at 09:44 +1000, Con Kolivas wrote:
> > + * This contains a bitmap for each dynamic priority level with empty slots
> > + * for the valid priorities each different nice level can have. It allows
> > + * us to stagger the slots where differing priorities run in a way that
> > + * keeps latency differences between different nice levels at a minimum.
> > + * ie, where 0 means a slot for that priority, priority running from left
> > to + * right:
> > + * nice -20 0000000000000000000000000000000000000000
> > + * nice -10 1001000100100010001001000100010010001000
> > + * nice   0 0101010101010101010101010101010101010101
> > + * nice   5 1101011010110101101011010110101101011011
> > + * nice  10 0110111011011101110110111011101101110111
> > + * nice  15 0111110111111011111101111101111110111111
> > + * nice  19 1111111111111111111011111111111111111111
> 
> Try two instances of chew.c at _differing_ nice levels on one cpu on mainline, 
> and then SD. This is why you can't renice X on mainline.

How about something more challenging instead :)

The numbers below are from my scheduler tree with massive_intr running
at nice 0, and chew at nice 5.  Below these numbers are 100 lines from
the exact center of chew's output.

(interactivity remains intact with this rather heavy load)

root@Homer: ./massive_intr 30 180
005671  00001506
005657  00001506
005651  00001491
005647  00001466
005661  00001484
005660  00001475
005645  00001514
005668  00001384
005673  00001516
005656  00001449
005664  00001512
005659  00001507
005667  00001513
005663  00001521
005670  00001440
005649  00001522
005652  00001487
005648  00001405
005665  00001472
005669  00001418
005662  00001489
005674  00001523
005650  00001480
005655  00001476
005672  00001530
005653  00001463
005654  00001427
005646  00001499
005658  00001510
005666  00001476

100 sequential lines from the middle of chew's logged output.

pid 5642, prio   5, out for    2 ms, ran for    1 ms, load  34%
pid 5642, prio   5, out for 1268 ms, ran for   63 ms, load   4%
pid 5642, prio   5, out for   52 ms, ran for    0 ms, load   0%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  14%
pid 5642, prio   5, out for    9 ms, ran for    1 ms, load  12%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    9 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  12%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  18%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  11%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  18%
pid 5642, prio   5, out for    4 ms, ran for    1 ms, load  22%
pid 5642, prio   5, out for 1395 ms, ran for   50 ms, load   3%
pid 5642, prio   5, out for   26 ms, ran for    0 ms, load   3%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    9 ms, ran for    1 ms, load  11%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  13%
pid 5642, prio   5, out for    7 ms, ran for    0 ms, load  11%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  11%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  14%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  20%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  14%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  13%
pid 5642, prio   5, out for 1400 ms, ran for   53 ms, load   3%
pid 5642, prio   5, out for   22 ms, ran for    1 ms, load   6%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  18%
pid 5642, prio   5, out for    9 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    2 ms, ran for    1 ms, load  49%
pid 5642, prio   5, out for 1281 ms, ran for   50 ms, load   3%
pid 5642, prio   5, out for   50 ms, ran for    0 ms, load   1%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  13%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  11%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  12%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    4 ms, ran for    1 ms, load  31%
pid 5642, prio   5, out for 1248 ms, ran for   53 ms, load   4%
pid 5642, prio   5, out for   44 ms, ran for    0 ms, load   1%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    9 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  11%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  13%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for 1311 ms, ran for   55 ms, load   4%
pid 5642, prio   5, out for  121 ms, ran for    0 ms, load   0%
pid 5642, prio   5, out for   22 ms, ran for    0 ms, load   1%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  18%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  12%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  16%
pid 5642, prio   5, out for    6 ms, ran for    1 ms, load  14%
pid 5642, prio   5, out for 1289 ms, ran for   50 ms, load   3%
pid 5642, prio   5, out for   38 ms, ran for    0 ms, load   1%
pid 5642, prio   5, out for    9 ms, ran for    1 ms, load  14%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  19%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  12%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  14%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  16%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  14%
pid 5642, prio   5, out for    9 ms, ran for    1 ms, load  11%
pid 5642, prio   5, out for    6 ms, ran for    1 ms, load  22%
pid 5642, prio   5, out for 1348 ms, ran for   53 ms, load   3%
pid 5642, prio   5, out for    8 ms, ran for    0 ms, load  10%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  15%
pid 5642, prio   5, out for    7 ms, ran for    0 ms, load  11%
pid 5642, prio   5, out for    8 ms, ran for    1 ms, load  12%
pid 5642, prio   5, out for 1385 ms, ran for   65 ms, load   4%
pid 5642, prio   5, out for 1385 ms, ran for   74 ms, load   5%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    7 ms, ran for    1 ms, load  17%
pid 5642, prio   5, out for    6 ms, ran for    1 ms, load  20%
pid 5642, prio   5, out for 1375 ms, ran for   66 ms, load   4%


