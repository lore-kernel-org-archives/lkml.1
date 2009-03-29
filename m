Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZC2AZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZC2AZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 20:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZC2AZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 20:25:07 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:49867 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZC2AZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 20:25:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18894.48499.125187.92480@cargo.ozlabs.ibm.com>
Date: Sun, 29 Mar 2009 11:14:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH 1/9] perf_counter: unify and fix delayed counter wakeup
In-Reply-To: <20090328194929.451591360@chello.nl>
References: <20090328194359.426029037@chello.nl>
	<20090328194929.451591360@chello.nl>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> While going over the wakeup code I noticed delayed wakeups only work
> for hardware counters but basically all software counters rely on
> them.

Hmmm, I don't like the extra latency this introduces, particularly
since on powerpc we already have a good way to avoid the latency.

I did a grep for perf_swcounter_event calls that have nmi=1, and there
are a couple, to my surprise.  Why does the context switch one have
nmi=1?  It certainly isn't called from an actual NMI handler.  Is it
because of locking issues?

The other one is the tracepoint call in perf_tpcounter_event.  I
assume you have put nmi=1 there because you don't know what context
we're in.  That means we'll always delay the wakeup even when we might
be in an ordinary interrupt-on process context.  Couldn't we do
better?

Paul.
