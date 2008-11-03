Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYKCGrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYKCGrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 01:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYKCGq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 01:46:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYKCGq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 01:46:56 -0500
Date: Mon, 3 Nov 2008 07:46:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Message-ID: <20081103064647.GA4826@elte.hu>
References: <490E3F73.1000405@gmail.com> <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 3 Nov 2008, Frederic Weisbecker wrote:
> 
> > When I tried to figure out why my experimental function's return 
> > tracer was hanging, I discovered that it was partially caused by 
> > the fact that the ring buffer might use the usual spinlocks during 
> > entry insertion.
> > 
> > ring_buffer_lock_reserve() -> rb_reserve_next_event() -> 
> > __rb_reserve_next() -> spin_lock_irqsave()
> > 
> > Since this last function is traced, the result is a recursion 
> > during the trace. I guess it happens too with the function tracer.
> > 
> > We should use the raw_spin_locks which are not traced.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Frederic,
> 
> Ingo has been very adamant about not using raw_spin_locks in the 
> ring buffers. My original code did this, and he nacked it. The 
> reason being (and he eventually convinced me) was that by using raw, 
> we not only do not trace the locking, we also remove the lock 
> checking. This code can easily produce deadlocks, so we do not want 
> the lock checking removed.
> 
> The real fix is to find a way in your tracer to detect the 
> recursion, and be able to prevent it. Like the atomic disables I use 
> in ftrace. It does the same thing. It leaves the lockdep checking on 
> its own locks, but can also detect if the lock checking caused it to 
> recurse. When the recusion is detected, the tracer itself will not 
> trace.

i'm wondering, does the changing to raw-spinlocks fix the deadlock? 
It's generally just the lack of recursion checking that is causing 
lockdep troubles - and recursion checking we want for all the more 
intrusive ftrace plugins anyway.

Frederic, do you have trouble finding the source of the deadlock? In 
theory the NMI watchdog should be able to punch through it. (if not 
then we need to improve things so that it can)

	Ingo
