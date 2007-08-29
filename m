Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbXH2F7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbXH2F7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXH2F73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:59:29 -0400
Received: from [212.12.190.209] ([212.12.190.209]:32816 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752101AbXH2F72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:59:28 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Wed, 29 Aug 2007 08:58:32 +0300
User-Agent: KMail/1.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Keith Packard <keith.packard@intel.com>
References: <200708111344.42934.a1426z@gawab.com> <200708290719.24422.a1426z@gawab.com> <20070829045316.GA15064@elte.hu>
In-Reply-To: <20070829045316.GA15064@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708290858.32909.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > I have narrowed it down a bit to add_wait_runtime.
>
> the scheduler is a red herring here. Could you "strace -ttt -TTT" one of
> the glxgears instances (and send us the cfs-debug-info.sh output, with
> CONFIG_SCHED_DEBUG=y and CONFIG_SCHEDSTATS=y as requested before) so
> that we can have a closer look?
>
> i reproduced something similar and there the stall is caused by 1+
> second select() delays on the X client<->server socket. The scheduler
> stats agree with that:
>
>  se.sleep_max             :          2194711437
>  se.block_max             :                   0
>  se.exec_max              :              977446
>  se.wait_max              :             1912321
>
> the scheduler itself had a worst-case scheduling delay of 1.9
> milliseconds for that glxgears instance (which is perfectly good - in
> fact - excellent interactivity) - but the task had a maximum sleep time
> of 2.19 seconds. So the 'glitch' was not caused by the scheduler.

2.19sec is probably the time you need to lay them out side by side.  You see, 
gears sleeps when it is covered by another window, so once you lay them out 
it starts running, and that's when they start to stutter for about 10sec.  
After that they should run smoothly, because they used up all the sleep 
bonus.

If you like, I can send you my straces, but they are kind of big though, and 
you need to strace each gear, as stracing itself changes the workload 
balance.

Let's first make sure what we are looking for:
1. start # gears & gears & gears &
2. lay them out side by side, don't worry about sleep times yet.
3. now they start stuttering for about 10sec
4. now they run out of sleep bonuses and smooth out

If this is the sequence you get on your machine, then try disabling 
add_wait_runtime to see the difference.


Thanks!

--
Al

