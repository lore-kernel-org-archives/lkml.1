Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZIFKSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZIFKSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 06:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZIFKSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 06:18:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:52614 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754720AbZIFKSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 06:18:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WKLA/3h0WlG4SokG/fnynrZW0drOmOpDrNe91+0
	K7YNoeeaDG106O
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Ani <asinha@zeugmasystems.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1252218779.6126.17.camel@marge.simson.net>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 12:18:09 +0200
Message-Id: <1252232289.29247.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 08:32 +0200, Mike Galbraith wrote:
> On Sat, 2009-09-05 at 19:32 -0700, Ani wrote: 
> > On Sep 5, 3:50 pm, Lucas De Marchi <lucas.de.mar...@gmail.com> wrote:
> > >
> > > Indeed. I've tested this same test program in a single core machine and it
> > > produces the expected behavior:
> > >
> > > rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
> > > 95%                              4.48%
> > > 60%                              54.84%
> > > 50%                              86.03%
> > > 40%                              OTHER completed first
> > >
> > 
> > Hmm. This does seem to indicate that there is some kind of
> > relationship with SMP. So I wonder whether there is a way to turn this
> > 'RT bandwidth accumulation' heuristic off.
> 
> No there isn't, but maybe there should be, since this isn't the first
> time it's come up.  One pro argument is that pinned tasks are thoroughly
> screwed when an RT hog lands on their runqueue.  On the con side, the
> whole RT bandwidth restriction thing is intended (AFAIK) to allow an
> admin to regain control should RT app go insane, which the default 5%
> aggregate accomplishes just fine.
> 
> Dunno.  Fly or die little patchlet (toss). 

btw, a _kinda sorta_ pro is that it can prevent IO lockups like the
below.  Seems kjournald can end up depending on kblockd/3, which ain't
going anywhere with that 100% RT hog in the way, so the whole box is
fairly hosed.  (much better would be to wake some other kblockd)

top - 12:01:49 up 56 min, 20 users,  load average: 8.01, 4.96, 2.39
Tasks: 304 total,   4 running, 300 sleeping,   0 stopped,   0 zombie
Cpu(s): 25.8%us,  0.3%sy,  0.0%ni,  0.0%id, 73.7%wa,  0.3%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
13897 root      -2   0  7920  592  484 R  100  0.0   1:13.43 3 xx
12716 root      20   0  8868 1328  860 R    1  0.0   0:01.44 0 top
   14 root      15  -5     0    0    0 R    0  0.0   0:00.02 3 events/3
   94 root      15  -5     0    0    0 R    0  0.0   0:00.00 3 kblockd/3
 1212 root      15  -5     0    0    0 D    0  0.0   0:00.04 2 kjournald
14393 root      20   0  9848 2296  756 D    0  0.1   0:00.01 0 make
14404 root      20   0 38012  25m 5552 D    0  0.8   0:00.21 1 cc1
14405 root      20   0 20220 8852 2388 D    0  0.3   0:00.02 1 as
14437 root      20   0 24132  10m 2680 D    0  0.3   0:00.06 2 cc1
14448 root      20   0 18324 1724 1240 D    0  0.1   0:00.00 2 cc1
14452 root      20   0 12540  792  656 D    0  0.0   0:00.00 2 mv


