Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXHTWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXHTWTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXHTWTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:19:39 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2759 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbXHTWTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:19:38 -0400
Date: Tue, 21 Aug 2007 00:19:47 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Willy Tarreau <w@1wt.eu>, Michael Chang <thenewme91@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <20070811003052.GA18812@elte.hu>
Message-ID: <Pine.LNX.4.64.0708191936110.1817@scrub.home>
References: <Pine.LNX.4.64.0708011955430.1817@scrub.home> <20070801190556.GA1199@elte.hu>
 <Pine.LNX.4.64.0708100037460.1817@scrub.home> <20070810054948.GA5908@elte.hu>
 <Pine.LNX.4.64.0708101459530.1817@scrub.home>
 <b14e81f00708100954w71e953fcm8a5cca464e4b27df@mail.gmail.com>
 <Pine.LNX.4.64.0708101919270.1817@scrub.home> <20070810194705.GH6002@1wt.eu>
 <Pine.LNX.4.64.0708102235320.1817@scrub.home> <20070810213630.GA13910@elte.hu>
 <20070811003052.GA18812@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 11 Aug 2007, Ingo Molnar wrote:

> the only relevant thing that comes to mind at the moment is that last 
> week Peter noticed a buggy aspect of sleeper bonuses (in that we do not 
> rate-limit their output, hence we 'waste' them instead of redistributing 
> them), and i've got the small patch below in my queue to fix that - 
> could you give it a try?

It doesn't make much of a difference. OTOH if I disabled the sleeper code 
completely in __update_curr(), I get this:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3139 roman     20   0  1796  344  256 R 21.7  0.3   0:02.68 lt
 3138 roman     20   0  1796  344  256 R 21.7  0.3   0:02.68 lt
 3137 roman     20   0  1796  520  432 R 21.7  0.4   0:02.68 lt
 3136 roman     20   0  1532  268  216 R 34.5  0.2   0:06.82 l

Disabling this code completely via sched_features makes only a minor 
difference:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3139 roman     20   0  1796  344  256 R 20.4  0.3   0:09.94 lt
 3138 roman     20   0  1796  344  256 R 20.4  0.3   0:09.94 lt
 3137 roman     20   0  1796  520  432 R 20.4  0.4   0:09.94 lt
 3136 roman     20   0  1532  268  216 R 39.1  0.2   0:19.20 l

> this is just a blind stab into the dark - i couldnt see any real impact 
> from that patch in various workloads (and it's not upstream yet), so it 
> might not make a big difference.

Can we please skip to the point, where you try to explain the intention a 
little more?
If I had to guess that this is supposed to keep the runtime balance, then 
it would be better to use wait_runtime to adjust fair_clock, from where it 
would be evenly distributed to all tasks (but this had to be done during 
enqueue and dequeue). OTOH this also had then a consequence for the wait 
queue, as fair_clock is used to calculate fair_key.
IMHO current wait_runtime should have some influence in calculating the 
sleep bonus, so that wait_runtime doesn't constantly overflow for tasks 
which only run occasionally.

bye, Roman
