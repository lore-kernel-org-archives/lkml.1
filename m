Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZKIS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZKIS44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZKIS4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:56:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:42632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZKIS4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:56:55 -0500
Subject: Re: [RFC,PATCH] mutex: mutex_is_owner() helper
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4AF1B7A7.6030902@gmail.com>
References: <4AF19D06.3060401@gmail.com> <20091104154015.GA32567@elte.hu>
	 <4AF1B7A7.6030902@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 19:56:27 +0100
Message-ID: <1257792987.4108.364.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 18:19 +0100, Eric Dumazet wrote:
> 
> BTW, I was thinking of a mutex_yield() implementation, but could not
> cook it without hard thinking, maybe you already have some nice
> implementation ?

Why? Yield sets off alarm bells, since 99.9%, and possibly more, of its
uses are wrong.

> int mutex_yield(struct mutex *lock)
> {
>         int ret = 0;
> 
>         if (mutex_needbreak(lock) || should_resched()) {
>                 mutex_unlock(lock); 
>                 __cond_resched();
>                 mutex_lock(lock);
>                 ret = 1;
>         }
>         return ret;
> } 

That reads like it should be called cond_resched_mutex(), except that
the should_resched() thing seems daft (but maybe it makes sense for
silly preemption modes like voluntary).

iirc we actually have something similar in -rt in order to implement the
lock-break for the rt-mutex based spinlocks, we set ->needbreak when a
higher priority task contends -- a policy for regular mutexes might be
'interesting' though.

As to your 'debug' helper that started this thread, doesn't
lockdep_assert_held() work for you?

