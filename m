Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbXHQH52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbXHQH52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbXHQH5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:57:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57237 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151AbXHQH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:56:59 -0400
Subject: Re: [PATCH] lockdep: annotate rcu_read_{,un}lock()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, herbert@gondor.apana.org.au,
       123.oleg@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Daniel Walker <dwalker@mvista.com>, josht@linux.vnet.ibm.com
In-Reply-To: <20070816160145.GA16957@linux.vnet.ibm.com>
References: <af57f1ac0708141130v729fa636k3150673809ec20a8@mail.gmail.com>
	 <E1ILEJr-0005Fl-00@gondolin.me.apana.org.au>
	 <20070815.144628.104052147.davem@davemloft.net>
	 <1187274307.6114.92.camel@twins>
	 <20070816160145.GA16957@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 09:56:45 +0200
Message-Id: <1187337405.6114.123.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 09:01 -0700, Paul E. McKenney wrote:
> On Thu, Aug 16, 2007 at 04:25:07PM +0200, Peter Zijlstra wrote:
> > 
> > There seem to be some unbalanced rcu_read_{,un}lock() issues of late,
> > how about doing something like this:
> 
> This will break when rcu_read_lock() and rcu_read_unlock() are invoked
> from NMI/SMI handlers -- the raw_local_irq_save() in lock_acquire() will
> not mask NMIs or SMIs.
> 
> One approach would be to check for being in an NMI/SMI handler, and
> to avoid calling lock_acquire() and lock_release() in those cases.

It seems:

#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)

Should make it all work out just fine. (for NMIs at least, /me fully
ignorant of the workings of SMIs)

> Another approach would be to use sparse, which has checks for
> rcu_read_lock()/rcu_read_unlock() nesting.

Yeah, but one more method can never hurt, no? :-)


