Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYJ2SDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYJ2SDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYJ2SC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:02:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYJ2SC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:02:56 -0400
Subject: Re: [PATCH 1/2] lockdep: implement full check without irq checking
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1224791072.6002.63.camel@johannes.berg>
References: <1224790541.6002.53.camel@johannes.berg>
	 <1224791072.6002.63.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 16:23:16 +0100
Message-Id: <1225293796.9315.4.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 21:44 +0200, Johannes Berg wrote: 
> This patch implements a new check type "3" which means "full validation
> but without irq tracing" in order to allow some certain fake locks that
> are only added for deadlock detection to not cause inconsistent state
> warnings which would be inappropriate for them.

This thing worries me, can you help my exhausted brain a long a little..

So I take it the idea is to couple the lock chains of the site calling
del_timer_sync and the actual timer.

We do this by holding a fake lock while executing the timer, so that its
lock chain starts with that lock.

We then acquire the fake lock on del_timer_sync so as to establish a
relation.

Now you get warnings about using a lock in hardirq context that was
previously used !irq-safe, right?

So why not simply write something like:


del_timer_sync():

  local_irq_save(flags);
  lock_aquire(my fake timer lock);
  lock_release(...);
  local_irq_restore(flags);

and make that conditional CONFIG_PROVE_LOCKING and or wrap it up
somewhere..



