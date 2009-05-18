Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZERTxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZERTxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZERTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:53:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58116 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZERTxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:53:14 -0400
Date: Mon, 18 May 2009 21:47:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency at
	cleanup_workqueue_thread
Message-ID: <20090518194749.GA3501@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242559101.28127.63.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17, Johannes Berg wrote:
>
> I'm not entirely sure yet, but I would think the problem might be a
> false positive in the workqueue code -- remember this report only
> triggers because cleanup_workqueue_thread() acquires the fake lock for
> the workqueue.

I spent a lot of time, but I can't explain this report too :( Even
if it is false positive, I don't understand why lockdep complains.

> Maybe it shouldn't do that from the CPU_POST_DEAD
> notifier?

Well, in any case we should understand why we have the problem, before
changing the code. And CPU_POST_DEAD is not special, why should we treat
it specially and skip lock_map_acquire(wq->lockdep_map) ?


But, I am starting to suspect we have some problems with lockdep too.
OK, I can't explain what I mean... But consider this code:

	DEFINE_SPINLOCK(Z);
	DEFINE_SPINLOCK(L1);
	DEFINE_SPINLOCK(L2);

	#define L(l)	spin_lock(&l)
	#define U(l)	spin_unlock(&l)

	void t1(void)
	{
		L(L1);
		L(L2);

		U(L2);
		U(L1);
	}

	void t2(void)
	{
		L(L2);
			L(Z);
		L(L1);

		U(L1);
			U(Z);
		U(L2);
	}

	void tst(void)
	{
		t1();
		t2();
	}

We have the trivial AB-BA deadlock with L1 and L2, but lockdep says:

	[ INFO: possible circular locking dependency detected ]
	2.6.30-rc6-00043-g22ef37e-dirty #3
	-------------------------------------------------------
	perl/676 is trying to acquire lock:
	 (L1){+.+...}, at: [<ffffffff802522b8>] t2+0x28/0x50

	but task is already holding lock:
	 (Z){+.+...}, at: [<ffffffff802522ac>] t2+0x1c/0x50

	which lock already depends on the new lock.


	the existing dependency chain (in reverse order) is:

	-> #2 (Z){+.+...}:

	-> #1 (L2){+.+...}:

	-> #0 (L1){+.+...}:

	other info that might help us debug this:

	2 locks held by perl/676:
	 #0:  (L2){+.+...}, at: [<ffffffff802522a0>] t2+0x10/0x50
	 #1:  (Z){+.+...}, at: [<ffffffff802522ac>] t2+0x1c/0x50

This output looks obviously wrong, Z does not depend on L1 or any
other lock.

Oleg.

