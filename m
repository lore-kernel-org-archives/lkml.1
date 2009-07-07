Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZGGMsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZGGMsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbZGGMsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:48:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46337 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755073AbZGGMsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:48:04 -0400
Subject: Re: kmemleak not tainted
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090707115128.GA3238@localdomain.by>
References: <20090707115128.GA3238@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 07 Jul 2009 13:47:39 +0100
Message-Id: <1246970859.9451.34.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 12:47:40.0875 (UTC) FILETIME=[1D5241B0:01C9FF01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 14:51 +0300, Sergey Senozhatsky wrote:
> kernel: [ 1917.133154] INFO: RCU detected CPU 0 stall (t=485140/3000 jiffies)

That's the relevant message. With CONFIG_RCU_CPU_STALL_DETECTOR you may
get these messages.

> static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
> {
> 	unsigned long flags;
> 	struct kmemleak_object *object = NULL;
> 
> 	rcu_read_lock();
> 	read_lock_irqsave(&kmemleak_lock, flags);
> 	if (ptr >= min_addr && ptr < max_addr)
> 		object = lookup_object(ptr, alias);
> >>	read_unlock_irqrestore(&kmemleak_lock, flags);
> 
> 	/* check whether the object is still available */
> 	if (object && !get_object(object))
> 		object = NULL;
> 	rcu_read_unlock();
> 
> 	return object;
> }

It just happened here because that's where the interrupts were enabled
and the timer routine invoked. The rcu-locked region above should be
pretty short (just a tree look-up).

What I think happens is that the kmemleak thread runs for several
seconds for scanning the memory and there may not be any context
switches. I have a patch to add more cond_resched() calls throughout the
kmemleak_scan() function which I hope will get merged. I don't get any
of these messages with CONFIG_PREEMPT enabled.

-- 
Catalin

