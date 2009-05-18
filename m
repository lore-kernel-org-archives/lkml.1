Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZERUV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZERUV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZERUVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:21:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbZERUVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:21:48 -0400
Date: Mon, 18 May 2009 22:16:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency at
	cleanup_workqueue_thread
Message-ID: <20090518201650.GA4384@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local> <20090518194749.GA3501@redhat.com> <1242676857.32543.1343.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242676857.32543.1343.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Peter Zijlstra wrote:
>
> On Mon, 2009-05-18 at 21:47 +0200, Oleg Nesterov wrote:
> >
> > But, I am starting to suspect we have some problems with lockdep too.
> > OK, I can't explain what I mean... But consider this code:
> >
> > 	DEFINE_SPINLOCK(Z);
> > 	DEFINE_SPINLOCK(L1);
> > 	DEFINE_SPINLOCK(L2);
> >
> > 	#define L(l)	spin_lock(&l)
> > 	#define U(l)	spin_unlock(&l)
> >
> > 	void t1(void)
> > 	{
> > 		L(L1);
> > 		L(L2);
> >
> > 		U(L2);
> > 		U(L1);
> > 	}
>
> (1) L1 -> L2
>
> > 	void t2(void)
> > 	{
> > 		L(L2);
> > 			L(Z);
>
> (2) L2 -> Z
>
> > 		L(L1);
>
> (3) Z -> L1
>
> > 		U(L1);
> > 			U(Z);
> > 		U(L2);
> > 	}
> >
> > 	void tst(void)
> > 	{
> > 		t1();
> > 		t2();
> > 	}
> >
> > We have the trivial AB-BA deadlock with L1 and L2, but lockdep says:
> >
> > 	[ INFO: possible circular locking dependency detected ]
> > 	2.6.30-rc6-00043-g22ef37e-dirty #3
> > 	-------------------------------------------------------
> > 	perl/676 is trying to acquire lock:
> > 	 (L1){+.+...}, at: [<ffffffff802522b8>] t2+0x28/0x50
> >
> > 	but task is already holding lock:
> > 	 (Z){+.+...}, at: [<ffffffff802522ac>] t2+0x1c/0x50
> >
> >
> > This output looks obviously wrong, Z does not depend on L1 or any
> > other lock.
>
> It does, L1 -> L2 -> Z as per 1 and 2
> which 3 obviously reverses.

Yes, yes, I see. And, as I said, I can't explain what I mean.

I mean... The output above looks as if we take L1 and Z in wrong order.
But Z has nothing to do with this deadlock, it can't depend on any lock
from the correctness pov. Except yes, we have it in L1->L2->Z->L1 cycle.

Oleg.

