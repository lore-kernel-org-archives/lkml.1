Return-Path: <linux-kernel-owner+w=401wt.eu-S965111AbXBYUQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111AbXBYUQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965058AbXBYUQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:16:44 -0500
Received: from mail.screens.ru ([213.234.233.54]:40507 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976AbXBYUQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:16:43 -0500
Date: Sun, 25 Feb 2007 23:16:41 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, mingo@elte.hu, hch@infradead.org, akpm@osdl.org,
       stern@rowland.harvard.edu
Subject: Re: [PATCH] QRCU with lockless fastpath
Message-ID: <20070225201641.GA2266@tv-sign.ru>
References: <20070225062349.GA17468@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225062349.GA17468@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Paul E. McKenney wrote:
> 
> This is an updated version of Oleg Nesterov's QRCU that avoids the
> earlier lock acquisition on the synchronize_qrcu() fastpath.  This passes
> rcutorture on x86 and the weakly ordered POWER.  A promela model of the
> code passes as noted before for 2 readers and 3 updaters and for 3 readers
> and 2 updaters.  3 readers and 3 updaters runs every machine that I have
> access to out of memory -- nothing like a little combinatorial explosion!
> However, after some thought, the proof ended up being simple enough:
> 
> 1.	If synchronize_qrcu() exits too soon, then by definition
> 	there has been a reader present during synchronize_srcu()'s
> 	full execution.
> 
> 2.	The counter corresponding to this reader will be at least
> 	1 at all times.
> 
> 3.	The synchronize_qrcu() code forces at least one of the counters
> 	to be at least one at all times -- if there is a reader, the
> 	sum will be at least two.  (Unfortunately, we cannot fetch
> 	the pair of counters atomically.)
> 
> 4.	Therefore, the only way that synchronize_qrcu()s fastpath can
> 	see a sum of 1 is if it races with another synchronize_qrcu() --
> 	the first synchronize_qrcu() must read one of the counters before
> 	the second synchronize_qrcu() increments it, and must read the
> 	other counter after the second synchronize_qrcu() decrements it.
> 	There can be at most one reader present through this entire
> 	operation -- otherwise, the first synchronize_qrcu() will see
> 	a sum of 2 or greater.
> 
> 5.	But the second synchronize_qrcu() will not release the mutex
> 	until after the reader is done.  During this time, the first
> 	synchronize_qrcu() will always see a sum of at least 2, and
> 	therefore cannot take the remainder of the fastpath until the
> 	reader is done.
> 
> 6.	Because the second synchronize_qrcu() holds the mutex, no other
> 	synchronize_qrcu() can manipulate the counters until the reader
> 	is done.  A repeat of the race called out in #4 above therefore
> 	cannot happen until after the reader is done, in which case it
> 	is safe for the first synchronize_qrcu() to proceed.
> 
> Therefore, two summations of the counter separated by a memory barrier
> suffices and the implementation shown below also suffices.
> 
> (And, yes, the fastpath -could- check for a sum of zero and exit
> immediately, but this would help only in case of a three-way race
> between two synchronize_qrcu()s and a qrcu_read_unlock(), would add
> another compare, so is not worth it.)
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks! This fastpath really improves QRCU.

Oleg.


