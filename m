Return-Path: <linux-kernel-owner+w=401wt.eu-S1030300AbXCVJTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030300AbXCVJTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 05:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030310AbXCVJTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 05:19:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60548 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030300AbXCVJTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 05:19:15 -0400
Date: Thu, 22 Mar 2007 10:18:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
Message-ID: <20070322091824.GD15328@elte.hu>
References: <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04> <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org> <20070320061152.GW943@1wt.eu> <1174377787.9756.21.camel@Homer.simpson.net> <1174489064.5379.42.camel@Homer.simpson.net> <1174492966.16411.1.camel@twins> <1174547256.7414.129.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174547256.7414.129.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Actually, the numbers are an interesting curiosity point, but not as 
> interesting as the fact that the deadline mechanism isn't kicking in.

it's not just the scheduling accounting being off, RSDL also seems to be 
accessing stale data here:

> >From pull_task():
> 	/*
> 	 * If this task has already been running on src_rq this priority
> 	 * cycle, make the new runqueue think it has been on its cycle
> 	 */
> 	if (p->rotation == src_rq->prio_rotation)
> 		p->rotation = this_rq->prio_rotation;
> 
> The intent here is clearly that this task continue on the new cpu as
> if nothing has happened.  However, when the task was dequeued,
> p->array was left as it was, points to the last place it was queued.
> Stale data.

it might point to a hot-unplugged CPU's runqueue as well. Which might 
work accidentally, but we want this fixed nevertheless.

	Ingo
