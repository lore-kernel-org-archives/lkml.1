Return-Path: <linux-kernel-owner+w=401wt.eu-S1030844AbXDNNbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844AbXDNNbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030846AbXDNNbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:31:14 -0400
Received: from 1wt.eu ([62.212.114.60]:1852 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030844AbXDNNbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:31:13 -0400
Date: Sat, 14 Apr 2007 15:01:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414130101.GA2538@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070414105338.GB19454@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 12:53:39PM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > Forking becomes very slow above a load of 100 it seems. Sometimes, the 
> > shell takes 2 or 3 seconds to return to prompt after I run "scheddos 
> > &"
> 
> this might be changed/impacted by the parent-requeue fix that is in the 
> updated (for real, promise! ;) patch. Right now on CFS a forking parent 
> shares its own run stats with the child 50%/50%. This means that heavy 
> forkers are indeed penalized. Another logical choice would be 100%/0%: a 
> child has to earn its own right.
> 
> i kept the 50%/50% rule from the old scheduler, but maybe it's a more 
> pristine (and smaller/faster) approach to just not give new children any 
> stats history to begin with. I've implemented an add-on patch that 
> implements this, you can find it at:
> 
>     http://redhat.com/~mingo/cfs-scheduler/sched-fair-fork.patch

Not tried yet, it already looks better with the update and sched-fair-hog.
Now xterm open "instantly" even with 1000 running processes.

> > Those are very promising results, I nearly observe the same 
> > responsiveness as I had on a solaris 10 with 10k running processes on 
> > a bigger machine.
> 
> cool and thanks for the feedback! (Btw., as another test you could also 
> try to renice "scheddos" to +19. While that does not push the scheduler 
> nearly as hard as nice 0, it is perhaps more indicative of how a truly 
> abusive many-tasks workload would be run in practice.)

Good idea. The machine I'm typing from now has 1000 scheddos running at +19,
and 12 gears at nice 0. Top keeps reporting different cpu usages for all gears,
but I'm pretty sure that it's a top artifact now because the cumulated times
are roughly identical :

 14:33:13  up 13 min,  7 users,  load average: 900.30, 443.75, 177.70
1088 processes: 80 sleeping, 1008 running, 0 zombie, 0 stopped
CPU0 states:  56.0% user  43.0% system   23.0% nice   0.0% iowait   0.0% idle
CPU1 states:  94.0% user   5.0% system    0.0% nice   0.0% iowait   0.0% idle
Mem:  1034764k av,  223788k used,  810976k free,       0k shrd,    7192k buff
       104400k active,              51904k inactive
Swap:  497972k av,       0k used,  497972k free                   68020k cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME CPU COMMAND
 1325 root      20   0 69240 9400  3740 R    27.6  0.9   4:46   1 X
 1412 willy     20   0  6284 2552  1740 R    14.2  0.2   1:09   1 glxgears
 1419 willy     20   0  6256 2384  1612 R    10.7  0.2   1:09   1 glxgears
 1409 willy     20   0  2824 1940   788 R     8.9  0.1   0:25   1 top
 1414 willy     20   0  6280 2544  1728 S     8.9  0.2   1:08   0 glxgears
 1415 willy     20   0  6256 2376  1600 R     8.9  0.2   1:07   1 glxgears
 1417 willy     20   0  6256 2384  1612 S     8.9  0.2   1:05   1 glxgears
 1420 willy     20   0  6284 2552  1740 R     8.9  0.2   1:07   1 glxgears
 1410 willy     20   0  6256 2372  1600 S     7.1  0.2   1:11   1 glxgears
 1413 willy     20   0  6260 2388  1612 S     7.1  0.2   1:08   0 glxgears
 1416 willy     20   0  6284 2544  1728 S     6.2  0.2   1:06   0 glxgears
 1418 willy     20   0  6252 2384  1612 S     6.2  0.2   1:09   0 glxgears
 1411 willy     20   0  6280 2548  1740 S     5.3  0.2   1:15   1 glxgears
 1421 willy     20   0  6280 2536  1728 R     5.3  0.2   1:05   1 glxgears

>From time to time, one of the 12 aligned gears will quickly perform a full
quarter of round while others slowly turn by a few degrees. In fact, while
I don't know this process's CPU usage pattern, there's something useful in
it : it allows me to visually see when process accelerate/deceleraet. What
would be best would be just a clock requiring low X ressources and eating
vast amounts of CPU between movements. It will help visually monitor CPU
distribution without being too much impacted by X.

I've just added another 100 scheddos at nice 0, and the system is still
amazingly usable. I just tried exchanging a 1-byte token between 188 "dd"
processes which communicate through circular pipes. The context switch
rate is rather high but this has no impact on the rest :

willy@pcw:c$ dd if=/tmp/fifo bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | dd bs=1 | (echo -n a;dd bs=1) | dd bs=1 of=/tmp/fifo

   procs                      memory      swap          io     system      cpu
 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
1105  0  1      0 781108   8364  68180    0    0     0    12    5 82187 59 41  0
1114  0  1      0 781108   8364  68180    0    0     0     0    0 81528 58 42  0
1112  0  1      0 781108   8364  68180    0    0     0     0    1 80899 58 42  0
1113  0  1      0 781108   8364  68180    0    0     0     0   26 83466 58 42  0
1106  0  2      0 781108   8376  68168    0    0     0     8   91 83193 58 42  0
1107  0  1      0 781108   8376  68180    0    0     0     4    7 79951 58 42  0
1106  0  1      0 781108   8376  68180    0    0     0     0   46 80939 57 43  0
1114  0  1      0 781108   8376  68180    0    0     0     0   21 82019 56 44  0
1116  0  1      0 781108   8376  68180    0    0     0     0   16 85134 56 44  0
1114  0  3      0 781108   8388  68168    0    0     0    16   20 85871 56 44  0
1112  0  1      0 781108   8388  68168    0    0     0     0   15 80412 57 43  0
1112  0  1      0 781108   8388  68180    0    0     0     0  101 83002 58 42  0
1113  0  1      0 781108   8388  68180    0    0     0     0   25 82230 56 44  0

Playing with the sched_max_hog_history_ns does not seem to change anything.
Maybe it's useful for other workloads. Anyway, I have nothing to complain
about, because it's not common for me to be able to normally type a mail on
a system with more than 1000 running processes ;-)

Also, mixed with this load, I have started injecting HTTP requests between
two local processes. The load is stable at 7700 req/s (11800 when alone),
and what I was interested in is the response time. It's perfectly stable
between 9.0 and 9.4 ms with a standard deviation of about 6.0 ms. Those were
varying a lot under stock scheduler, with some sessions sometimes pausing
for seconds. (RSDL fixed this though).

Well, I'll stop heating the room for now as I get out of ideas about how
to defeat it. I'm convinced. I'm impatient to read about Mike's feedback
with his workload which behaves strangely on RSDL. If it works OK here,
it will be the proof that heuristics should not be needed.

Congrats !
Willy

