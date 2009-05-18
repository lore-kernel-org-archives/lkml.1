Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZERQDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZERQDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZERQC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:02:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46831 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbZERQC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:02:56 -0400
Date: Mon, 18 May 2009 09:02:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, davem@davemloft.net, dada1@cosmosbay.com,
       zbr@ioremap.net, jeff.chua.linux@gmail.com, paulus@samba.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v5 expedited "big hammer" RCU grace periods
Message-ID: <20090518160254.GD6768@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090517191141.GA25915@linux.vnet.ibm.com> <20090518075630.GA10687@elte.hu> <20090518151421.GB6768@linux.vnet.ibm.com> <20090518154241.GA27047@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518154241.GA27047@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 05:42:41PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > i might be missing something fundamental here, but why not just 
> > > have per CPU helper threads, all on the same waitqueue, and wake 
> > > them up via a single wake_up() call? That would remove the SMP 
> > > cross call (wakeups do immediate cross-calls already).
> > 
> > My concern with this is that the cache misses accessing all the 
> > processes on this single waitqueue would be serialized, slowing 
> > things down. In contrast, the bitmask that smp_call_function() 
> > traverses delivers on the order of a thousand CPUs' worth of bits 
> > per cache miss.  I will give it a try, though.
> 
> At least if you go via the migration threads, you can queue up 
> requests to them locally. But there's going to be cachemisses 
> _anyway_, since you have to access them all from a single CPU, and 
> then they have to fetch details about what to do, and then have to 
> notify the originator about completion.

Ah, so you are suggesting that I use smp_call_function() to run code on
each CPU that wakes up that CPU's migration thread?  I will take a look
at this.

							Thanx, Paul
