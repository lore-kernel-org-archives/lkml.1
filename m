Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbYKKWrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbYKKWrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbYKKWrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:47:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40707 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKKWrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:47:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081111203324.GA30425@redhat.com>
References: <20081111203324.GA30425@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Pirko <jpirko@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH] workqueues: turn queue_work() into the "barrier" for work->func()
Date: Tue, 11 Nov 2008 22:46:21 +0000
Message-ID: <9266.1226443581@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> I think the caller of queue_work() has all rights to expect that
> the next invocation of work_func() must see "VAR == 1", but this
> is not true if the work is already pending.

As you said, queue_work() does test_and_set_bit() which implies smp_mb()
either side of the function, so you're half way there, and run_workqueue()
calls spin_unlock_irq() just before calling work_clear_pending()...  So might
it make sense to move the work_clear_pending() into locked section?  Or would
that require an smp_mb__before_clear_bit()?

David
