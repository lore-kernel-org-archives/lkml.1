Return-Path: <linux-kernel-owner+w=401wt.eu-S966156AbXDCK6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966156AbXDCK6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 06:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966158AbXDCK6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 06:58:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:58739 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966156AbXDCK6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 06:58:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/XSbZqd37XkR0FmiIcvfvtjx8UeYs8cFG+b+57It
	rqMZk/hTB3eZYw
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <1175578270.6342.12.camel@Homer.simpson.net>
References: <200703290237.38777.kernel@kolivas.org>
	 <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <200704031237.21946.kernel@kolivas.org>
	 <1175578270.6342.12.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 12:57:57 +0200
Message-Id: <1175597877.6650.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 07:31 +0200, Mike Galbraith wrote:
> On Tue, 2007-04-03 at 12:37 +1000, Con Kolivas wrote:
> > On Thursday 29 March 2007 15:50, Mike Galbraith wrote:
> > > On Thu, 2007-03-29 at 09:44 +1000, Con Kolivas wrote:
> > > + * This contains a bitmap for each dynamic priority level with empty slots
> > > + * for the valid priorities each different nice level can have. It allows
> > > + * us to stagger the slots where differing priorities run in a way that
> > > + * keeps latency differences between different nice levels at a minimum.
> > > + * ie, where 0 means a slot for that priority, priority running from left
> > > to + * right:
> > > + * nice -20 0000000000000000000000000000000000000000
> > > + * nice -10 1001000100100010001001000100010010001000
> > > + * nice   0 0101010101010101010101010101010101010101
> > > + * nice   5 1101011010110101101011010110101101011011
> > > + * nice  10 0110111011011101110110111011101101110111
> > > + * nice  15 0111110111111011111101111101111110111111
> > > + * nice  19 1111111111111111111011111111111111111111
> > 
> > Try two instances of chew.c at _differing_ nice levels on one cpu on mainline, 
> > and then SD. This is why you can't renice X on mainline.
> 
> How about something more challenging instead :)
> 
> The numbers below are from my scheduler tree with massive_intr running
> at nice 0, and chew at nice 5.  Below these numbers are 100 lines from
> the exact center of chew's output.
> 
> (interactivity remains intact with this rather heavy load)
> 
> root@Homer: ./massive_intr 30 180
> 005671  00001506
> 005657  00001506
> 005651  00001491
> 005647  00001466
> 005661  00001484
> 005660  00001475
> 005645  00001514
> 005668  00001384
> 005673  00001516
> 005656  00001449
> 005664  00001512
> 005659  00001507
> 005667  00001513
> 005663  00001521
> 005670  00001440
> 005649  00001522
> 005652  00001487
> 005648  00001405
> 005665  00001472
> 005669  00001418
> 005662  00001489
> 005674  00001523
> 005650  00001480
> 005655  00001476
> 005672  00001530
> 005653  00001463
> 005654  00001427
> 005646  00001499
> 005658  00001510
> 005666  00001476

Taking a little break from tinkering, I built/ran rsd-0.38 as well.
While chew usually says "out for N < 500ms", I see spikes like those
below the massive_intr numbers.

root@Homer: ./massive_intr 30 180 (nice 0)
006596  00001346
006613  00001475
006605  00001463
006606  00001423
006598  00001279
006609  00001458
006600  00001378
006591  00001491
006610  00001413
006588  00001361
006602  00001401
006601  00001412
006607  00001373
006604  00001449
006599  00001398
006608  00001269
006611  00001464
006593  00001349
006614  00001335
006612  00001512
006615  00001422
006589  00001363
006617  00001362
006597  00001435
006592  00001354
006595  00001425
006616  00001348
006603  00001308
006594  00001360
006590  00001397

(spikes from run above)
pid 6585, prio   0, out for  178 ms, ran for   12 ms, load   6%
pid 6585, prio   0, out for  175 ms, ran for   13 ms, load   7%
pid 6585, prio   0, out for 1901 ms, ran for   12 ms, load   0%
pid 6585, prio   0, out for   61 ms, ran for   12 ms, load  17%
...
pid 6585, prio   0, out for  148 ms, ran for   11 ms, load   7%
pid 6585, prio   0, out for  229 ms, ran for   13 ms, load   5%
pid 6585, prio   0, out for  182 ms, ran for   11 ms, load   6%
pid 6585, prio   0, out for 1306 ms, ran for   11 ms, load   0%
pid 6585, prio   0, out for   72 ms, ran for   12 ms, load  15%
pid 6585, prio   0, out for  252 ms, ran for   11 ms, load   4%
....
(spikes from massive_intr at nice 0 and chew at nice -20)
pid 6547, prio -20, out for  132 ms, ran for  119 ms, load  47%
pid 6547, prio -20, out for   52 ms, ran for  119 ms, load  69%
pid 6547, prio -20, out for    4 ms, ran for   96 ms, load  95%
pid 6547, prio -20, out for 1251 ms, ran for   24 ms, load   1%
pid 6547, prio -20, out for   78 ms, ran for 1561 ms, load  95%
pid 6547, prio -20, out for   89 ms, ran for  120 ms, load  57%
pid 6547, prio -20, out for   69 ms, ran for  119 ms, load  63%
pid 6547, prio -20, out for 4125 ms, ran for  119 ms, load   2%
pid 6547, prio -20, out for   73 ms, ran for  119 ms, load  62%
pid 6547, prio -20, out for  110 ms, ran for  120 ms, load  52%
pid 6547, prio -20, out for   57 ms, ran for  119 ms, load  67%


