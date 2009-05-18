Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZERPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZERPno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZERPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:43:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZERPnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:43:35 -0400
Date: Mon, 18 May 2009 17:42:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, davem@davemloft.net, dada1@cosmosbay.com,
       zbr@ioremap.net, jeff.chua.linux@gmail.com, paulus@samba.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v5 expedited "big hammer" RCU grace periods
Message-ID: <20090518154241.GA27047@elte.hu>
References: <20090517191141.GA25915@linux.vnet.ibm.com> <20090518075630.GA10687@elte.hu> <20090518151421.GB6768@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518151421.GB6768@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > i might be missing something fundamental here, but why not just 
> > have per CPU helper threads, all on the same waitqueue, and wake 
> > them up via a single wake_up() call? That would remove the SMP 
> > cross call (wakeups do immediate cross-calls already).
> 
> My concern with this is that the cache misses accessing all the 
> processes on this single waitqueue would be serialized, slowing 
> things down. In contrast, the bitmask that smp_call_function() 
> traverses delivers on the order of a thousand CPUs' worth of bits 
> per cache miss.  I will give it a try, though.

At least if you go via the migration threads, you can queue up 
requests to them locally. But there's going to be cachemisses 
_anyway_, since you have to access them all from a single CPU, and 
then they have to fetch details about what to do, and then have to 
notify the originator about completion.

	Ingo
