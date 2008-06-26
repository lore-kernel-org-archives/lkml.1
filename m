Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbYFZLEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbYFZLEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZLE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:04:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:60040 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbYFZLE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:04:26 -0400
Date: Thu, 26 Jun 2008 15:06:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: hrtimers: simplify lockdep handling
Message-ID: <20080626110624.GA110@tv-sign.ru>
References: <Pine.LNX.4.58.0806251539180.405@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0806251539180.405@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 06/25, Steven Rostedt wrote:
> 
> I'm currently porting -rt to 26-rc7 and I came across this change:
> 
> Commit:     8e60e05fdc7344415fa69a3883b11f65db967b47
> 
> With the
> 
> -	double_spin_lock(&new_base->lock, &old_base->lock,
> -			 smp_processor_id() < cpu);
> +	spin_lock(&new_base->lock);
> +	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
> 
> 
> What's the reason that this is possible?  Is it because the migration
> happens only on CPU hotplugging and that the CPU hotplugging code has
> locks that would prevent a reversal of the lock taking?

Yes. Even if we ignore CPU hotplugging locks, it is not possible that
2 migrate_timers()'s can take these locks in reverse order, this means
that both CPUs are dead and we are doing something meaningless.

> I'm not arguing that the code is incorrect, but this looks like a subtlety
> that can bite us later.
>
> In other words, we really need comments around this code to explain to
> casual viewers why this code is not deadlock prone. The change log here
> and for 0d180406f2914aea3a78ddb880e2fe9ac78a9372 does not explain why the
> straight forward taking of the locks is OK.

OK, I agree, I'll try to make the trivial doc patch.

But please note that the old code was confusing too, imho. It looked as
if we really have to avoid the deadlock, and the casual viewer (me) was
very confused when noticed the changes which added base_lock_keys and
double_spin_lock ;)

Oleg.

