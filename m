Return-Path: <linux-kernel-owner+w=401wt.eu-S964801AbXC0FEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbXC0FEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXC0FEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:04:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:37884 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964801AbXC0FEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:04:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/8fRtc0O38+V4kqclc8DYWXoEDaKel12CFy/GkIH
	Sg1t+wh1Ey4T9o
Subject: Re: [BUG] scheduler: strange behavor with massive interactive
	processes
From: Mike Galbraith <efault@gmx.de>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 07:04:12 +0200
Message-Id: <1174971852.16403.35.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 10:34 +0900, Satoru Takeuchi wrote:
> Hi Ingo and all,

Hi,

> When I was executing massive interactive processes, I found that some of them
> occupy CPU time and the others hardly run.
> 
> It seems that some of processes which occupy CPU time always has max effective
> prio (default+5) and the others have max - 1. What happen here is...
> 
>  1. If there are moderate number of max interactive processes, they can be
>     re-inserted into active queue without falling down its priority again and
>     again.
>  2. In this case, the others seldom run, and can't get max effective priority
>     at next exhausting because scheduler considers them to sleep too long.
>  3. Goto 1, OOPS!

Ah, that's a new twist.  Cool testcase.  A mechanism which was put in
specifically to prevent tasks from jumping straight to max interactive,
and thus hurting truly interactive tasks, is starving these not truly
interactive (but nothing says they couldn't be) tasks.

One way to prevent this may be to do something very simple like (I did
this here a while back) upon timeslice completion (or possibly better,
round-robin interval [whenever]), promote a task from a lower priority
queue.  Tasks are then always crawling up the ladder, and _will_ be
inserted into the stream no matter what is going on in the system.  The
lower the task's priority, the longer it takes to crawl up, but it will
get there.  I'll try this again, and see how it handles your testcase,
and how it affects interactivity.  There are many others ways of course,
limiting queue runtime etc etc.

	-Mike

