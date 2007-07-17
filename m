Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbXGQPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbXGQPOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXGQPOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:14:10 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3611 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbXGQPOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:14:09 -0400
Date: Tue, 17 Jul 2007 17:12:39 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070717075346.GB13539@elte.hu>
Message-ID: <Pine.LNX.4.64.0707171633510.1817@scrub.home>
References: <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home>
 <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home>
 <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home>
 <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home>
 <20070716203117.GC11166@waste.org> <Pine.LNX.4.64.0707162304330.1817@scrub.home>
 <20070717075346.GB13539@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 17 Jul 2007, Ingo Molnar wrote:

> * Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > > > It's nice that these artifacts are gone, but that still doesn't 
> > > > explain why this ratio had to be increase that much from around 
> > > > 1:10 to 1:69.
> > > 
> > > More dynamic range is better? If you actually want a task to get 20x 
> > > the CPU time of another, the older scheduler doesn't really allow 
> > > it.
> > 
> > You can already have that, the complete range level from 19 to -20 was 
> > about 1:80.
> 
> But that is irrelevant: all tasks start out at nice 0, and what matters 
> is the dynamic range around 0.
> 
> So the dynamic range has been made uniform in the positive from 
> 1:10...1:20...1:30 to 1:69 for nice +19, and from 1:8 to 1:69 in the 
> minus. (with 1:86 nice -20) If you look at the negative nice levels 
> alone it's a substantial increase but if you compare it with positive 
> nice levels you'll similar kinds of dynamic ranges were already present 
> in the old scheduler and you'll see why we've done it.

So let's look at them:

for (i=0;i<20;i++) print i, " : ", (20-i)*5, " : ", 100*1.25^-i, " : ", e(l(2)*(-i/5))*100, "\n";
0 : 100 : 100 : 100.00000000000000000000
1 : 95 : 80.00000000000000000000 : 87.05505632961241391300
2 : 90 : 64.00000000000000000000 : 75.78582832551990411700
3 : 85 : 51.20000000000000000000 : 65.97539553864471296900
4 : 80 : 40.96000000000000000000 : 57.43491774985175034000
5 : 75 : 32.76800000000000000000 : 50.00000000000000000000
6 : 70 : 26.21440000000000000000 : 43.52752816480620695700
7 : 65 : 20.97152000000000000000 : 37.89291416275995205900
8 : 60 : 16.77721600000000000000 : 32.98769776932235648400
9 : 55 : 13.42177280000000000000 : 28.71745887492587517000
10 : 50 : 10.73741824000000000000 : 25.00000000000000000000
11 : 45 : 8.58993459200000000000 : 21.76376408240310347800
12 : 40 : 6.87194767360000000000 : 18.94645708137997602900
13 : 35 : 5.49755813888000000000 : 16.49384888466117824200
14 : 30 : 4.39804651110400000000 : 14.35872943746293758500
15 : 25 : 3.51843720888320000000 : 12.50000000000000000000
16 : 20 : 2.81474976710656000000 : 10.88188204120155173900
17 : 15 : 2.25179981368524800000 : 9.47322854068998801400
18 : 10 : 1.80143985094819840000 : 8.24692444233058912100
19 : 5 : 1.44115188075855872000 : 7.17936471873146879200

(nice level : old % : new % : my suggested %)

Your levels divert very quickly from what they used to be (upto a factor 
of 7), it's also not really easy to remember what the individual levels 
mean.
I at least try to keep them somewhat in the range they used to be (and 
the difference is limited to a factor of about 2), also every 5 levels the 
amount of cpu time is halved, which is very easy to remember.

If you need more dynamic range, is there a law that prevents us from going 
beyond 19? For example:

for (i=20;i<=30;i++) print i, " : ", (20-i)*5, " : ", 100*1.25^-i, " : ", e(l(2)*(-i/5))*100, "\n";
20 : 0 : 1.15292150460684697600 : 6.25000000000000000000
21 : -5 : .92233720368547758000 : 5.44094102060077586900
22 : -10 : .73786976294838206400 : 4.73661427034499400700
23 : -15 : .59029581035870565100 : 4.12346222116529456000
24 : -20 : .47223664828696452100 : 3.58968235936573439600
25 : -25 : .37778931862957161700 : 3.12500000000000000000
26 : -30 : .30223145490365729300 : 2.72047051030038793400
27 : -35 : .24178516392292583400 : 2.36830713517249700300
28 : -40 : .19342813113834066700 : 2.06173111058264728000
29 : -45 : .15474250491067253400 : 1.79484117968286719800
30 : -50 : .12379400392853802700 : 1.56250000000000000000

setpriority() accepts such values without error.

bye, Roman
