Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZDUSD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZDUSD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZDUSDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:03:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54456 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZDUSDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:03:10 -0400
Date: Tue, 21 Apr 2009 20:02:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Eric Dumazet <dada1@cosmosbay.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
Message-ID: <20090421180225.GA26237@elte.hu>
References: <20090417012812.GA25534@linux.vnet.ibm.com> <20090418094001.GA2369@ioremap.net> <20090418141455.GA7082@linux.vnet.ibm.com> <20090420103414.1b4c490f@nehalam> <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam> <alpine.LFD.2.00.0904210831560.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904210831560.2199@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> PS: Ingo, why do the *_bh() functions in kernel/spinlock.c do 
> _both_ a "local_bh_disable()" and a "preempt_disable()"? BH 
> disable should disable preemption too, no? Or am I confused? In 
> which case we need that in the above rdlock_bh too.

i think there might be (are?) uses of:

	spin_lock_bh(&some->lock);
	...
	spin_unlock(&some->lock);
	...
	local_bh_enable();

So we have to have two preemption control levels for that, as 
there's no knowledge at the spin_lock_bh() place whether it will be 
followed by a spin_unlock_bh() [in which case it would be safe to do 
SOFTIRQ_OFFSET only] - or by a spin_unlock() + local_bh_enable() 
pair..

[ That locking pattrn even makes a certain amount of sense: keep the 
  lock held for a short amount of time - then weaken locking to bh 
  context exclusion only. ]

What we could do is an optimization to do a compound increase the 
preempt count by SOFTIRQ_OFFSET+1 - instead of a local_bh_disable() 
+ preempt_disable()? Symmetrically we could do a compound decrease 
in the unlock case.

It might even be called: local_bh_preempt_disable() or so?

	Ingo
