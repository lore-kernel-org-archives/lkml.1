Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbXBAADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbXBAADU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXBAADU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:03:20 -0500
Received: from amsfep16-int.chello.nl ([62.179.120.11]:40629 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161104AbXBAADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:03:20 -0500
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070131233229.GP2574@linux.vnet.ibm.com>
References: <20070128115118.837777000@programming.kicks-ass.net>
	 <20070128120509.719287000@programming.kicks-ass.net>
	 <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu>
	 <20070131191215.GK2574@linux.vnet.ibm.com>
	 <20070131211340.GA171@tv-sign.ru> <1170280101.10924.36.camel@lappy>
	 <20070131233229.GP2574@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 01:03:09 +0100
Message-Id: <1170288190.10924.108.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 15:32 -0800, Paul E. McKenney wrote:

> The wakeup in barrier_sync() would mean that the counter was zero
> at some point in the past.  The counter would then be rechecked, and
> if it were still zero, barrier_sync() would invoke finish_wait() and
> then return -- but the counter might well become non-zero in the
> meantime, right?
> 
> So given that barrier_sync() is permitted to return after the counter
> becomes non-zero, why can't it just rely on the fact that barrier_unlock()
> saw it as zero not long in the past?
> 
> > >  It looks like barrier_sync() is more a
> > > rw semaphore biased to readers.
> > 
> > Indeed, the locked sections are designed to be the rare case.
> 
> OK -- but barrier_sync() just waits for readers, it doesn't exclude them.
> 
> If all barrier_sync() needs to do is to wait until all pre-existing
> barrier_lock()/barrier_unlock() pairs to complete, it seems to me to
> be compatible with qrcu's semantics.
> 
> So what am I missing here?

I might be the one missing stuff, I'll have a hard look at qrcu.

The intent was that barrier_sync() would not write to memory when there
are no active locked sections, so that the cacheline can stay shared,
thus keeping is fast.

If qrcu does exactly this, then yes we have a match.

