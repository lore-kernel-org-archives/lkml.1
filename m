Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbXD0GB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbXD0GB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXD0GB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:01:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:36702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754045AbXD0GB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:01:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/0/44rI1z0049Hbb/ynE87cIcSXr/XTfk4lsaSX6
	+s6Srj/9Bi6VSH
Subject: Re: [patch] CFS scheduler, -v6
From: Mike Galbraith <efault@gmx.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Gene Heskett <gene.heskett@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177646573.6520.4.camel@Homer.simpson.net>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost>
	 <1177646573.6520.4.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 08:01:19 +0200
Message-Id: <1177653679.25885.23.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 06:02 +0200, Mike Galbraith wrote:
> On Thu, 2007-04-26 at 22:09 +0200, Kasper Sandberg wrote:
> > On Thu, 2007-04-26 at 10:41 -0400, Gene Heskett wrote:
> > <snip>
> > > 
> > > Compared to mainline?  I still think this is a 100% keeper for desktop users 
> > > like me.
> > 
> > Here its alot worse, just playing an ogg with ogg123 even without
> > anything reniced (X is 0), just pressing a link in konqueror can make
> > audio skip (ogg123 fails to fill the alsa buffer, and thus it skips).
> 
> What arguments are you passing to ogg123?  I'm creating some ogg files
> right now, and would like to reproduce these skips to see why they're
> happening if possible.

Well, I can't reproduce any skips with my config.  That doesn't mean
anything wrt _your_ skips of course.  Maybe it's a config or hardware
difference.  With my 3GHz P4 low latency desktop full preempt setup,
ogg123 works absolutely flawlessly (using default settings) both in UP
and SMP configurations, even under quite hefty load.

I do get some ALSA gripes when doing heavy IO...

root@Homer: grep ALSA /ogg123.log
Audio Device:   Advanced Linux Sound Architecture (ALSA) output
ALSA: underrun, at least 0ms.04:49.37  (103.0 kbps)  Output Buffer  12.5%
ALSA: underrun, at least 0ms.04:15.20  (102.1 kbps)  Output Buffer  12.5%
ALSA: underrun, at least 0ms.03:30.80  (126.7 kbps)  Output Buffer  96.9%
ALSA: underrun, at least 0ms.05:15.93  ( 99.9 kbps)  Output Buffer  25.0%

...but no audible effect whatsoever.  Heavy IO to my very full and
likely fragmented ext3 filesystem is a very big problem here no matter
what CPU or IO scheduler I'm using.
 
As I write this, I've got a heavy kernel build running, and was browsing
around with firefox and konqueror, checking mail etc etc as it was
running.  I definitely feel the load (no surprise;), but ogg123 is
delivering dropout free audio.  (this is the UP cfs-v6 kernel)

top - 07:34:56 up  1:00, 13 users,  load average: 35.92, 34.72, 24.21
Tasks: 294 total,  31 running, 263 sleeping,   0 stopped,   0 zombie
Cpu(s): 93.8%us,  6.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
24878 root      20   0 28628  24m 4176 R  3.5  2.5   0:01.56 cc1
25236 root      20   0 22608  18m 3964 R  3.5  1.9   0:00.47 cc1
25385 root      20   0 17184  11m 2196 R  3.5  1.2   0:00.23 cc1
25405 root      20   0 15996  10m 2196 R  3.5  1.0   0:00.18 cc1
24668 root      20   0 35828  31m 4152 R  3.0  3.1   0:02.07 cc1
24763 root      20   0 36420  32m 4160 R  3.0  3.2   0:01.86 cc1
24976 root      20   0 26880  23m 4156 R  3.0  2.3   0:01.23 cc1
25054 root      20   0 25016  21m 4140 R  3.0  2.1   0:01.00 cc1
25058 root      20   0 28272  24m 4140 R  3.0  2.4   0:00.97 cc1
25090 root      20   0 27384  23m 4140 R  3.0  2.4   0:00.94 cc1
25123 root      20   0 26068  22m 4120 R  3.0  2.2   0:00.89 cc1
25270 root      20   0 22584  18m 3976 R  3.0  1.8   0:00.42 cc1
25303 root      20   0 18232  14m 4024 R  3.0  1.5   0:00.33 cc1
25310 root      20   0 20436  15m 2196 R  3.0  1.5   0:00.32 cc1
25348 root      20   0 19176  14m 3948 R  3.0  1.5   0:00.29 cc1
25349 root      20   0 19408  14m 2196 R  3.0  1.4   0:00.29 cc1
25360 root      20   0 19432  13m 2196 R  3.0  1.4   0:00.28 cc1
25395 root      20   0 17136  11m 2196 R  3.0  1.1   0:00.21 cc1
25426 root      20   0 12608 7732 2184 R  3.0  0.7   0:00.10 cc1
25432 root      20   0 12528 6936 2184 R  3.0  0.7   0:00.09 cc1
23766 root      20   0 44116  39m 4104 R  2.5  4.0   0:03.74 cc1
25124 root      20   0  6380 4084  972 R  2.5  0.4   0:00.05 as
25183 root      20   0 24948  20m 4052 R  2.5  2.1   0:00.73 cc1
25363 root      20   0 17156  13m 3820 S  2.5  1.3   0:00.26 cc1
25445 root      20   0 10268 5404 2140 R  2.5  0.5   0:00.05 cc1
25452 root      20   0 10096 3680 1384 R  1.5  0.4   0:00.03 cc1
 5355 root      15  -5  185m  26m 4716 S  1.0  2.6   3:11.71 Xorg
25184 root      20   0  5576 3284  848 R  1.0  0.3   0:00.02 as
 6396 root      20   0 14960 3100 2168 R  0.5  0.3   0:12.50 ogg123


