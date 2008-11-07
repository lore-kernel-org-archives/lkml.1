Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbYKGLwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbYKGLwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYKGLwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:52:45 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:15109 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYKGLwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:52:44 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC patch 17/18] MIPS : Trace clock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20081107053351.329744816@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
	 <20081107053351.329744816@polymtl.ca>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 12:53:17 +0100
Message-Id: <1226058797.2697.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 00:23 -0500, Mathieu Desnoyers wrote:
> Note for Peter Zijlstra :
> You should probably have a look at lockdep.c raw_spinlock_t lockdep_lock usage.
> I suspect it may be used with preemption enabled in graph_lock(). (not sure
> though, but it's worth double-checking.

Are you worried about the graph_lock() instance in
lookup_chain_cache() ?

That is the locking for validate_chain,

__lock_acquire()
 validate_chain()
   look_up_chain_cache()
     graph_lock()
   check_prevs_add()
     check_prev_add()
       graph_unlock()
       graph_lock()
   graph_unlock()

which is all done without modifying IRQ state.

However, __lock_acquire() is only called with IRQs disabled:

lock_acquire()
  raw_local_irq_save()
  __lock_acquire()

lock_release()
  raw_local_irq_save()
  __lock_release()
    lock_release_nested()
      __lock_acquire()
    lock_release_non_nested()
      __lock_acquire()

lock_set_subclass()
  raw_local_irq_save()
  __lock_set_subclass()
    __lock_acquire()

So I think we're good.

