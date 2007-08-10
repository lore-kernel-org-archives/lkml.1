Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXHJWuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXHJWuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXHJWtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:49:53 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1415 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbXHJWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:49:52 -0400
Date: Sat, 11 Aug 2007 00:50:08 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Willy Tarreau <w@1wt.eu>, Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070810213630.GA13910@elte.hu>
Message-ID: <Pine.LNX.4.64.0708110001420.1817@scrub.home>
References: <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home>
 <20070801190556.GA1199@elte.hu> <Pine.LNX.4.64.0708100037460.1817@scrub.home>
 <20070810054948.GA5908@elte.hu> <Pine.LNX.4.64.0708101459530.1817@scrub.home>
 <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com>
 <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu>
 <Pine.LNX.4.64.0708102235320.1817@scrub.home> <20070810213630.GA13910@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 10 Aug 2007, Ingo Molnar wrote:

> achieve that. It probably wont make a real difference, but it's really 
> easy for you to send and it's still very useful when one tries to 
> eliminate possibilities and when one wants to concentrate on the 
> remaining possibilities alone.

The thing I'm afraid about CFS is its possible unpredictability, which 
would make it hard to reproduce problems and we may end up with users with 
unexplainable weird problems. That's the main reason I'm trying so hard to 
push for a design discussion.

Just to give an idea here are two more examples of irregular behaviour, 
which are hopefully easier to reproduce.

1. Two simple busy loops, one of them is reniced to 15, according to my 
calculations the reniced task should get about 3.4% (1/(1.25^15+1)), but I 
get this:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4433 roman     20   0  1532  300  244 R 99.2  0.2   5:05.51 l
 4434 roman     35  15  1532   72   16 R  0.7  0.1   0:10.62 l

OTOH upto nice level 12 I get what I expect.

2. If I start 20 busy loops, initially I see in top that every task gets 
5% and time increments equally (as it should):

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4492 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4491 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4490 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4489 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4488 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4487 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4486 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4485 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4484 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4483 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4482 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4481 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4480 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4479 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4478 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4477 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4476 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4475 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4474 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
 4473 roman     20   0  1532  296  244 R  5.0  0.2   0:02.86 l

But if I renice all of them to -15, the time every task gets is rather 
random:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 4492 roman      5 -15  1532   68   16 R  1.0  0.1   0:07.95 l
 4491 roman      5 -15  1532   68   16 R  4.3  0.1   0:07.62 l
 4490 roman      5 -15  1532   68   16 R  3.3  0.1   0:07.50 l
 4489 roman      5 -15  1532   68   16 R  7.6  0.1   0:07.80 l
 4488 roman      5 -15  1532   68   16 R  9.6  0.1   0:08.31 l
 4487 roman      5 -15  1532   68   16 R  3.3  0.1   0:07.59 l
 4486 roman      5 -15  1532   68   16 R  6.6  0.1   0:07.08 l
 4485 roman      5 -15  1532   68   16 R 10.0  0.1   0:07.31 l
 4484 roman      5 -15  1532   68   16 R  8.0  0.1   0:07.30 l
 4483 roman      5 -15  1532   68   16 R  7.0  0.1   0:07.34 l
 4482 roman      5 -15  1532   68   16 R  1.0  0.1   0:05.84 l
 4481 roman      5 -15  1532   68   16 R  1.0  0.1   0:07.16 l
 4480 roman      5 -15  1532   68   16 R  3.3  0.1   0:07.00 l
 4479 roman      5 -15  1532   68   16 R  1.0  0.1   0:06.66 l
 4478 roman      5 -15  1532   68   16 R  8.6  0.1   0:06.96 l
 4477 roman      5 -15  1532   68   16 R  8.6  0.1   0:07.63 l
 4476 roman      5 -15  1532   68   16 R  9.6  0.1   0:07.38 l
 4475 roman      5 -15  1532   68   16 R  1.3  0.1   0:07.09 l
 4474 roman      5 -15  1532   68   16 R  2.3  0.1   0:07.97 l
 4473 roman      5 -15  1532  296  244 R  1.0  0.2   0:07.73 l

bye, Roman
