Return-Path: <linux-kernel-owner+w=401wt.eu-S964841AbXBZJ2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbXBZJ2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964835AbXBZJ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:28:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39230 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964841AbXBZJ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:28:47 -0500
Date: Mon, 26 Feb 2007 10:28:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: malc <av1474@comtv.ru>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: CPU load
Message-ID: <20070226092837.GB3790@elf.ucw.cz>
References: <loom.20070212T063225-663@post.gmane.org> <20070212143219.GB5226@ucw.cz> <Pine.LNX.4.64.0702140059390.727@home.oyster.ru> <200702140908.44934.kernel@kolivas.org> <Pine.LNX.4.64.0702141023000.672@home.oyster.ru> <20070214204515.GA26153@elf.ucw.cz> <Pine.LNX.4.64.0702251334200.17241@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702251334200.17241@linmac.oyster.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [..snip..]
> 
> >>The current situation ought to be documented. Better yet some flag
> >>can
> >
> >It probably _is_ documented, somewhere :-). If you find nice place
> >where to document it (top manpage?) go ahead with the patch.
> 
> 
> How about this:

Looks okay to me. (You should probably add your name to it, and I do
not like html-like markup... plus please don't add extra spaces
between words)...

You probably want to send it to akpm?
								Pavel

> <Documentation/load.txt>
> CPU load
> --------
> 
> Linux exports various bits     of information via  `/proc/stat'    and
> `/proc/uptime' that userland tools,  such as top(1), use  to calculate
> the average time system spent in a particular state, for example:
> 
> <transcript>
> $ iostat
> Linux 2.6.18.3-exp (linmac)     02/20/2007
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           10.01    0.00    2.92    5.44    0.00   81.63
> 
> ...
> </transcript>
> 
> Here   the system  thinks that  over   the default sampling period the
> system spent 10.01% of the time doing work in user space, 2.92% in the
> kernel, and was overall 81.63% of the time idle.
> 
> In most cases the `/proc/stat'  information reflects the reality quite
> closely, however  due to the   nature of how/when  the kernel collects
> this data sometimes it can not be trusted at all.
> 
> So  how is this information  collected?   Whenever timer interrupt  is
> signalled the  kernel looks  what kind  of task   was running at  this
> moment  and   increments the counter  that  corresponds  to this tasks
> kind/state.  The  problem with  this is  that  the  system  could have
> switched between  various states   multiple times between    two timer
> interrupts yet the counter is incremented only for the last state.
> 
> 
> Example
> -------
> 
> If we imagine the system with one task that periodically burns cycles
> in the following manner:
> 
>  time line between two timer interrupts
> |--------------------------------------|
>  ^                                    ^
>  |_ something begins working          |
>                                       |_ something goes to sleep
>                                      (only to be awaken quite soon)
> 
> In the above  situation the system will be  0% loaded according to the
> `/proc/stat' (since  the timer interrupt will   always happen when the
> system is  executing  the idle  handler),  but in reality  the load is
> closer to 99%.
> 
> One can imagine many more situations where this behavior of the kernel
> will lead to quite erratic information inside `/proc/stat'.
> 
> 
> /* gcc -o hog smallhog.c */
> #include <time.h>
> #include <limits.h>
> #include <signal.h>
> #include <sys/time.h>
> #define HIST 10
> 
> static volatile sig_atomic_t stop;
> 
> static void sighandler (int signr)
> {
>      (void) signr;
>      stop = 1;
> }
> static unsigned long hog (unsigned long niters)
> {
>      stop = 0;
>      while (!stop && --niters);
>      return niters;
> }
> int main (void)
> {
>      int i;
>      struct itimerval it = { .it_interval = { .tv_sec = 0, .tv_usec = 1 },
>                              .it_value = { .tv_sec = 0, .tv_usec = 1 } };
>      sigset_t set;
>      unsigned long v[HIST];
>      double tmp = 0.0;
>      unsigned long n;
>      signal (SIGALRM, &sighandler);
>      setitimer (ITIMER_REAL, &it, NULL);
> 
>      hog (ULONG_MAX);
>      for (i = 0; i < HIST; ++i) v[i] = ULONG_MAX - hog (ULONG_MAX);
>      for (i = 0; i < HIST; ++i) tmp += v[i];
>      tmp /= HIST;
>      n = tmp - (tmp / 3.0);
> 
>      sigemptyset (&set);
>      sigaddset (&set, SIGALRM);
> 
>      for (;;) {
>          hog (n);
>          sigwait (&set, &i);
>      }
>      return 0;
> }
> 
> 
> References
> ----------
> 
> http://lkml.org/lkml/2007/2/12/6
> Documentation/filesystems/proc.txt (1.8)
> </Documentation/load.txt>
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
