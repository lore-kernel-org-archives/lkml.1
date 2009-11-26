Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZKZO6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZKZO6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760270AbZKZO6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:58:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:46753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753899AbZKZO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:58:35 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/OOJ1S/9vOeCHBXmnYOcCwB8wdHeDly02hMGBMT9
	MsaASz5Do0uAkG
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259244563.31676.53.camel@laptop>
References: <1258891781.14325.34.camel@marge.simson.net>
	 <1259173672.4027.732.camel@laptop>
	 <1259197270.6186.17.camel@marge.simson.net>
	 <1259199068.6186.33.camel@marge.simson.net> <1259228139.4273.6.camel@twins>
	 <1259230578.15079.12.camel@marge.simson.net>
	 <1259244563.31676.53.camel@laptop>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 15:58:38 +0100
Message-Id: <1259247518.6465.41.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 15:09 +0100, Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 11:16 +0100, Mike Galbraith wrote:
> > > min_vruntime should only ever be poked at when holding the respective
> > > rq->lock, even with a barrier a 64bit read on a 32bit machine can go all
> > > funny.
> > 
> > Yeah, but we're looking at an unlocked runqueue.  But never mind...
> 
> The patch is also poking at rq->clock without rq->lock held... not very
> nice.

To the users on the remote runqueue, it doesn't matter, they always
update before using, so will always have accurate time.

What bothers me is that I don't see what prevents a SCHED_IDLE task
making a huge min_vruntime update on the remote CPU while you're
queueing a sleeper here, who used to live over there, while you're
reading.

But, they're all instantaneous values anyway, so I suppose memory speed
is fine.  It works... and I really doubt that the yet another paranoid
barrier I just put in will make diddly spit difference, but I did just
put an smp_rmb() there anyway to see with my own eyes ;-)

> Gah, I hate that we're doing migration things without holding both rq's,
> this is making live so very interesting ;-)

Yes.

	-Mike

