Return-Path: <linux-kernel-owner+w=401wt.eu-S964991AbXHYW3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991AbXHYW3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 18:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbXHYW3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 18:29:36 -0400
Received: from [212.12.190.205] ([212.12.190.205]:32921 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755883AbXHYW3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 18:29:35 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Sun, 26 Aug 2007 01:27:32 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708220127.30698.a1426z@gawab.com> <20070824134510.GA21382@elte.hu>
In-Reply-To: <20070824134510.GA21382@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708260127.32238.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > > > The problem is that consecutive runs don't give consistent results
> > > > and sometimes stalls.  You may want to try that.
> > >
> > > well, there's a natural saturation point after a few hundred tasks
> > > (depending on your CPU's speed), at which point there's no idle time
> > > left. From that point on things get slower progressively (and the
> > > ability of the shell to start new ping tasks is impacted as well),
> > > but that's expected on an overloaded system, isnt it?
> >
> > Of course, things should get slower with higher load, but it should be
> > consistent without stalls.
> >
> > To see this problem, make sure you boot into /bin/sh with the normal
> > VGA console (ie. not fb-console).  Then try each loop a few times to
> > show different behaviour; loops like:
> >
> > # for ((i=0; i<3333; i++)); do ping 10.1 -A > /dev/null & done
> >
> > # for ((i=0; i<3333; i++)); do nice -99 ping 10.1 -A > /dev/null & done
> >
> > # { for ((i=0; i<3333; i++)); do
> >         ping 10.1 -A > /dev/null &
> >     done } > /dev/null 2>&1
> >
> > Especially the last one sometimes causes a complete console lock-up,
> > while the other two sometimes stall then surge periodically.
>
> ok. I think i might finally have found the bug causing this. Could you
> try the fix below, does your webserver thread-startup test work any
> better?

It seems to help somewhat, but the problem is still visible.  Even v20.3 on 
2.6.22.5 didn't help.

It does look related to ia-boosting, so I turned off __update_curr like Roman 
mentioned, which had an enormous smoothing effect, but then nice levels 
completely break down and lockup the system.

There is another way to show the problem visually under X (vesa-driver), by 
starting 3 gears simultaneously, which after laying them out side-by-side 
need some settling time before smoothing out.  Without __update_curr it's 
absolutely smooth from the start.


Thanks!

--
Al

