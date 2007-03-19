Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbXCSUwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbXCSUwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbXCSUwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:52:53 -0400
Received: from [212.12.190.22] ([212.12.190.22]:32943 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753312AbXCSUww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:52:52 -0400
From: Al Boldi <a1426z@gawab.com>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: RSDL v0.31
Date: Mon, 19 Mar 2007 23:53:19 +0300
User-Agent: KMail/1.5
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
In-Reply-To: <45FEB54A.3040602@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703192353.19673.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Al Boldi wrote:
> >..
> > Mike, I'm not saying RSDL is perfect, but v0.31 is by far better than
> > mainline.  Try this easy test:
> >
> > startx with the vesa driver
> > run reflect from the mesa5.0-demos
> > load 5 cpu-hogs
> > start moving the mouse
> >
> > On my desktop, mainline completely breaks down, and no nicing may
> > rescue.
> >
> > On RSDL, even without nicing, the desktop is at least useable.
>
> I use a simpler, far more common (for lkml participants) workload:
>
> Dell notebook, single P-M-2GHz, ATI X300, open source X.org:
> (1) build a kernel in one window with "make -j$((NUMBER_OF_CPUS + 1))".
> (2) try to read email and/or surf in Firefox/Thunderbird.
>
> Stock scheduler wins easily, no contest.

Try this on RSDL:

--- sched.bak.c	2007-03-16 23:07:23.000000000 +0300
+++ sched.c	2007-03-19 23:49:40.000000000 +0300
@@ -938,7 +938,11 @@ static void activate_task(struct task_st
 				     (now - p->timestamp) >> 20);
 	}
 
-	p->quota = rr_quota(p);
+	/*
+	 * boost factor hardcoded to 5; adjust to your liking
+	 * higher means more likely to DoS
+	 */
+	p->quota = rr_quota(p) + (((now - p->timestamp) >> 20) * 5);
 	p->prio = effective_prio(p);
 	p->timestamp = now;
 	__activate_task(p, rq);


Thanks!

--
Al

