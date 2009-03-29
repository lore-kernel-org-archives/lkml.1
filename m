Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZC2JQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZC2JQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 05:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZC2JQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 05:16:35 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:38952 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZC2JQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 05:16:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/9] perf_counter: unify and fix delayed counter wakeup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Eric Dumazet <dada1@cosmosbay.com>
In-Reply-To: <18894.48499.125187.92480@cargo.ozlabs.ibm.com>
References: <20090328194359.426029037@chello.nl>
	 <20090328194929.451591360@chello.nl>
	 <18894.48499.125187.92480@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Sun, 29 Mar 2009 11:16:41 +0200
Message-Id: <1238318201.23852.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 11:14 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > While going over the wakeup code I noticed delayed wakeups only work
> > for hardware counters but basically all software counters rely on
> > them.
> 
> Hmmm, I don't like the extra latency this introduces, particularly
> since on powerpc we already have a good way to avoid the latency.

Right, so I can re-instate the powerpc bits and have it call
perf_counter_do_pending() whenever it finds the per-cpu pending bit set.

I'd have to look into the fancy new per-cpu stuff for the x86 bits, but
I'm reasonably sure something like that should be doable.

> I did a grep for perf_swcounter_event calls that have nmi=1, and there
> are a couple, to my surprise.  Why does the context switch one have
> nmi=1?  It certainly isn't called from an actual NMI handler.  Is it
> because of locking issues?

Yeah, can't do a wakeup while holding the rq->lock.

> The other one is the tracepoint call in perf_tpcounter_event.  I
> assume you have put nmi=1 there because you don't know what context
> we're in.  That means we'll always delay the wakeup even when we might
> be in an ordinary interrupt-on process context.  Couldn't we do
> better?

Maybe, not only real in_nmi() tracepoints have that problem, we also
have lock_acquire() like tracepoints that could call into the event code
in the middle of a lock acquisition (which might be rq->lock).

So always using nmi=1 for those seemed like the safe way out.

