Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbYKLK6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbYKLK6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYKLK6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:58:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36519 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYKLK6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:58:06 -0500
Date: Wed, 12 Nov 2008 12:58:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Pirko <jpirko@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH] workqueues: turn queue_work() into the "barrier"
	for work->func()
Message-ID: <20081112115804.GA3444@redhat.com>
References: <20081111203324.GA30425@redhat.com> <9266.1226443581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9266.1226443581@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > I think the caller of queue_work() has all rights to expect that
> > the next invocation of work_func() must see "VAR == 1", but this
> > is not true if the work is already pending.
>
> As you said, queue_work() does test_and_set_bit() which implies smp_mb()
> either side of the function, so you're half way there, and run_workqueue()
> calls spin_unlock_irq() just before calling work_clear_pending()...  So might
> it make sense to move the work_clear_pending() into locked section?  Or would
> that require an smp_mb__before_clear_bit()?

This can't really help, afaics. We still need mb() between clear_bit(_PENDING)
and LOAD(VAR). Because unlock() is the "one way" barrier, LOAD(VAR) can leak
into the critical section, and it can be re-ordered with clear_bit() inside
the critical section.

Oleg.

