Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYHAJcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYHAJcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYHAJcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:32:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33715
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbYHAJcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:32:14 -0400
Date: Fri, 01 Aug 2008 02:32:14 -0700 (PDT)
Message-Id: <20080801.023214.117218567.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080801092219.GA15691@elte.hu>
References: <20080729.214503.126934382.davem@davemloft.net>
	<20080731163943.GF26393@elte.hu>
	<20080801092219.GA15691@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 1 Aug 2008 11:22:19 +0200

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > > lockdep: Fix combinatorial explosion in lock subgraph traversal.
> > 
> > applied to tip/core/locking - thanks David. I guess we need to test 
> > this a bit, the patch is far from simple :-)
> 
> small build fallout fix below.

Thanks.

BTW, until something like Peter's attempt is working, we need to also
scale some of the lockdep limits by NR_CPUS.  The formula I came up
with that worked with my 32-cpu, 64-cpu and 128-cpu machines was:

#define __LOCKDEP_NR_CPU_SCALE	\
	((NR_CPUS <= 16) ? 0 : ilog2(NR_CPUS) - 4)

#define MAX_LOCKDEP_ENTRIES	(8192UL << __LOCKDEP_NR_CPU_SCALE)

#define MAX_LOCKDEP_CHAINS_BITS	(16 + __LOCKDEP_NR_CPU_SCALE)
#define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)

But this is going to explode for NR_CPUS=4096, but it is the only way
to get a working lockdep currently, due to the runqueue lock classes.

Also, when these limits reached triggered, we get the same printk
wakeup deadlock problem I hit with Peter's patch.

I think a non-trivial number of people hit that printk deadlock bug,
but just didn't report it because the machine essentially hard hangs
silently.  At best you'd see the:

========================================

initial line from lockdep, but often even that doesn't make it to the
console.
