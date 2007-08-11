Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbXHKKof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbXHKKof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 06:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbXHKKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 06:44:25 -0400
Received: from [212.12.190.136] ([212.12.190.136]:32969 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753964AbXHKKoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 06:44:24 -0400
From: Al Boldi <a1426z@gawab.com>
Subject: Re: CFS review
Date: Sat, 11 Aug 2007 13:44:42 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708111344.42934.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> On Fri, 10 Aug 2007, Ingo Molnar wrote:
> > achieve that. It probably wont make a real difference, but it's really
> > easy for you to send and it's still very useful when one tries to
> > eliminate possibilities and when one wants to concentrate on the
> > remaining possibilities alone.
>
> The thing I'm afraid about CFS is its possible unpredictability, which
> would make it hard to reproduce problems and we may end up with users with
> unexplainable weird problems. That's the main reason I'm trying so hard to
> push for a design discussion.
>
> Just to give an idea here are two more examples of irregular behaviour,
> which are hopefully easier to reproduce.
>
> 1. Two simple busy loops, one of them is reniced to 15, according to my
> calculations the reniced task should get about 3.4% (1/(1.25^15+1)), but I
> get this:
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  4433 roman     20   0  1532  300  244 R 99.2  0.2   5:05.51 l
>  4434 roman     35  15  1532   72   16 R  0.7  0.1   0:10.62 l
>
> OTOH upto nice level 12 I get what I expect.
>
> 2. If I start 20 busy loops, initially I see in top that every task gets
> 5% and time increments equally (as it should):
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  4492 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4491 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4490 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4489 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4488 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4487 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4486 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4485 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4484 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4483 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4482 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4481 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4480 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4479 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4478 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4477 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4476 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4475 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4474 roman     20   0  1532   68   16 R  5.0  0.1   0:02.86 l
>  4473 roman     20   0  1532  296  244 R  5.0  0.2   0:02.86 l
>
> But if I renice all of them to -15, the time every task gets is rather
> random:
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  4492 roman      5 -15  1532   68   16 R  1.0  0.1   0:07.95 l
>  4491 roman      5 -15  1532   68   16 R  4.3  0.1   0:07.62 l
>  4490 roman      5 -15  1532   68   16 R  3.3  0.1   0:07.50 l
>  4489 roman      5 -15  1532   68   16 R  7.6  0.1   0:07.80 l
>  4488 roman      5 -15  1532   68   16 R  9.6  0.1   0:08.31 l
>  4487 roman      5 -15  1532   68   16 R  3.3  0.1   0:07.59 l
>  4486 roman      5 -15  1532   68   16 R  6.6  0.1   0:07.08 l
>  4485 roman      5 -15  1532   68   16 R 10.0  0.1   0:07.31 l
>  4484 roman      5 -15  1532   68   16 R  8.0  0.1   0:07.30 l
>  4483 roman      5 -15  1532   68   16 R  7.0  0.1   0:07.34 l
>  4482 roman      5 -15  1532   68   16 R  1.0  0.1   0:05.84 l
>  4481 roman      5 -15  1532   68   16 R  1.0  0.1   0:07.16 l
>  4480 roman      5 -15  1532   68   16 R  3.3  0.1   0:07.00 l
>  4479 roman      5 -15  1532   68   16 R  1.0  0.1   0:06.66 l
>  4478 roman      5 -15  1532   68   16 R  8.6  0.1   0:06.96 l
>  4477 roman      5 -15  1532   68   16 R  8.6  0.1   0:07.63 l
>  4476 roman      5 -15  1532   68   16 R  9.6  0.1   0:07.38 l
>  4475 roman      5 -15  1532   68   16 R  1.3  0.1   0:07.09 l
>  4474 roman      5 -15  1532   68   16 R  2.3  0.1   0:07.97 l
>  4473 roman      5 -15  1532  296  244 R  1.0  0.2   0:07.73 l

That's because granularity increases when decreasing nice, and results in 
larger timeslices, which affects smoothness negatively.  chew.c easily shows 
this problem with 2 background cpu-hogs at the same nice-level.

pid 908, prio   0, out for    8 ms, ran for    4 ms, load  37%
pid 908, prio   0, out for    8 ms, ran for    4 ms, load  37%
pid 908, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 908, prio   0, out for    8 ms, ran for    4 ms, load  38%
pid 908, prio   0, out for    2 ms, ran for    1 ms, load  47%

pid 908, prio  -5, out for   23 ms, ran for    3 ms, load  14%
pid 908, prio  -5, out for   17 ms, ran for    9 ms, load  35%
pid 908, prio  -5, out for   18 ms, ran for    6 ms, load  27%
pid 908, prio  -5, out for   20 ms, ran for   10 ms, load  34%
pid 908, prio  -5, out for    9 ms, ran for    3 ms, load  30%

pid 908, prio -10, out for   69 ms, ran for    8 ms, load  11%
pid 908, prio -10, out for   35 ms, ran for   19 ms, load  36%
pid 908, prio -10, out for   58 ms, ran for   20 ms, load  26%
pid 908, prio -10, out for   34 ms, ran for   17 ms, load  34%
pid 908, prio -10, out for   58 ms, ran for   23 ms, load  28%

pid 908, prio -15, out for  164 ms, ran for   20 ms, load  11%
pid 908, prio -15, out for   21 ms, ran for   11 ms, load  36%
pid 908, prio -15, out for   21 ms, ran for   12 ms, load  37%
pid 908, prio -15, out for  115 ms, ran for   14 ms, load  11%
pid 908, prio -15, out for   27 ms, ran for   22 ms, load  45%
pid 908, prio -15, out for  125 ms, ran for   33 ms, load  21%
pid 908, prio -15, out for   54 ms, ran for   16 ms, load  22%
pid 908, prio -15, out for   34 ms, ran for   33 ms, load  49%
pid 908, prio -15, out for   94 ms, ran for   15 ms, load  14%
pid 908, prio -15, out for   29 ms, ran for   21 ms, load  42%
pid 908, prio -15, out for  108 ms, ran for   20 ms, load  15%
pid 908, prio -15, out for   44 ms, ran for   20 ms, load  31%
pid 908, prio -15, out for   34 ms, ran for  110 ms, load  76%
pid 908, prio -15, out for  132 ms, ran for   21 ms, load  14%
pid 908, prio -15, out for   42 ms, ran for   39 ms, load  48%
pid 908, prio -15, out for   57 ms, ran for  124 ms, load  68%
pid 908, prio -15, out for   44 ms, ran for   17 ms, load  28%

It looks like the larger the granularity, the more unpredictable it gets, 
which probably means that this unpredictability exists even at smaller 
granularity but is only exposed with larger ones.


Thanks!

--
Al

