Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbXHLFRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbXHLFRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 01:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXHLFRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 01:17:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbXHLFRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 01:17:45 -0400
Date: Sun, 12 Aug 2007 07:17:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Roman Zippel <zippel@linux-m68k.org>, Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070812051734.GB18291@elte.hu>
References: <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home> <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com> <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu> <Pine.LNX.4.64.0708102235320.1817@scrub.home> <20070810213630.GA13910@elte.hu> <Pine.LNX.4.64.0708110001420.1817@scrub.home> <20070811052840.GB24082@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811052840.GB24082@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> > 1. Two simple busy loops, one of them is reniced to 15, according to 
> > my calculations the reniced task should get about 3.4% 
> > (1/(1.25^15+1)), but I get this:
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >  4433 roman     20   0  1532  300  244 R 99.2  0.2   5:05.51 l
> >  4434 roman     35  15  1532   72   16 R  0.7  0.1   0:10.62 l
> 
> Could this be caused by typos in some tables like you have found in 
> wmult ?

note that the typo was not in the weight table but in the inverse weight 
table which didnt really affect CPU utilization (that's why we didnt 
notice the typo sooner). Regarding the above problem with nice +15 being 
beefier than intended i'd suggest to re-test with a doubled 
/proc/sys/kernel/sched_runtime_limit value, or with:

  echo 30 > /proc/sys/kernel/sched_features

(which turns off sleeper fairness)

> >  4477 roman      5 -15  1532   68   16 R  8.6  0.1   0:07.63 l
> >  4476 roman      5 -15  1532   68   16 R  9.6  0.1   0:07.38 l
> >  4475 roman      5 -15  1532   68   16 R  1.3  0.1   0:07.09 l
> >  4474 roman      5 -15  1532   68   16 R  2.3  0.1   0:07.97 l
> >  4473 roman      5 -15  1532  296  244 R  1.0  0.2   0:07.73 l
> 
> Do you see this only at -15, or starting with -15 and below ?

i think this was scheduling jitter caused by the larger granularity of 
negatively reniced tasks. This got improved recently, with latest -git i 
get:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3108 root       5 -15  1576  248  196 R  5.0  0.0   0:07.26 loop_silent
 3109 root       5 -15  1576  248  196 R  5.0  0.0   0:07.26 loop_silent
 3110 root       5 -15  1576  248  196 R  5.0  0.0   0:07.26 loop_silent
 3111 root       5 -15  1576  244  196 R  5.0  0.0   0:07.26 loop_silent
 3112 root       5 -15  1576  248  196 R  5.0  0.0   0:07.26 loop_silent
 3113 root       5 -15  1576  248  196 R  5.0  0.0   0:07.26 loop_silent

that's picture-perfect CPU time distribution. But, and that's fair to 
say, i never ran such an artificial workload of 20x nice -15 infinite 
loops (!) before, and boy does interactivity suck (as expected) ;)

	Ingo
