Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbXGVAl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbXGVAl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 20:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbXGVAlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 20:41:49 -0400
Received: from ozlabs.org ([203.10.76.45]:50042 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbXGVAls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 20:41:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18082.42324.417377.935153@cargo.ozlabs.ibm.com>
Date: Sun, 22 Jul 2007 10:31:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@mandriva.com>
Subject: Re: [PATCH] pi-futex: set PF_EXITING without taking ->pi_lock
In-Reply-To: <20070721150547.GA23560@elte.hu>
References: <20070721115712.GA871@tv-sign.ru>
	<20070721123159.GB1769@elte.hu>
	<20070721141814.GA1013@tv-sign.ru>
	<20070721150547.GA23560@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > 	static inline void ccids_read_lock(void)
> > 	{
> > 		atomic_inc(&ccids_lockct);
> > 		spin_unlock_wait(&ccids_lock);
> > 	}
> > 
> > This looks racy, in theory atomic_inc() and spin_unlock_wait() could 
> > be re-ordered. However, in this particular case we have an "optimized" 
> > smp_mb_after_atomic_inc(), perhaps it is good that the caller can 
> > choose the "right" barrier by hand.
> 
> _all_ default locking and atomic APIs should be barrier-safe i believe. 
> (and that includes atomic_inc() too) Most people dont have barriers on 
> their mind when their code. _If_ someone is barrier-conscious then we 
> should have barrier-less APIs too for that purpose of squeezing the last 
> half cycle out of the code, but it should be a non-default choice. The 
> reason: nobody notices an unnecessary barrier, but a missing barrier can 
> be nasty.

The approach we have taken on powerpc is that the atomic_*_test and
atomic_*_return functions have a barrier, but the straight atomic_inc
etc. don't.

As for putting barriers in, it's not a half cycle, it's more like 50
to 100 on some processors.  Added to that, what I think you are
actually advocating is *two* full barriers - one before the increment
and one after.  That seems like an enormous penalty to pay just
because some people want to roll their own lock primitives instead of
using the standard ones.

Why is ccids_read_lock trying to implement a rwlock without using an
rwlock?  Could it be converted to an ordinary rwlock?  Or an rwsem?

Paul.

