Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZH0Dqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZH0Dqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZH0Dqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:46:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:42932 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZH0Dqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:46:42 -0400
Subject: Re: [v2 PATCH 2/2]: pseries: Implement Pseries Processor Idle idle
 module.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: arun@linux.vnet.ibm.com, Joel Schopp <jschopp@austin.ibm.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1251286038.1329.1.camel@twins>
References: <20090826110721.GA29759@linux.vnet.ibm.com>
	 <20090826111003.GC29759@linux.vnet.ibm.com> <1251286038.1329.1.camel@twins>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 13:44:09 +1000
Message-Id: <1251344649.20467.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 13:27 +0200, Peter Zijlstra wrote:
> On Wed, 2009-08-26 at 16:40 +0530, Arun R Bharadwaj wrote:
> > +void (*pm_idle)(void);
> > +EXPORT_SYMBOL_GPL(pm_idle);
> 
> Seriously.. this caused plenty problems over on x86 and you're doing the
> exact same dumb thing?

I already said I didn't want this export.

First thing first: We already have a ppc_md.power_save() callback,
filled by the platform. which implements the "low level" part of idle on
powerpc (ie, the actual putting of the CPU into some kind of wait state)
and is called by our idle loop.

We -also- have a higher level ppc_md.idle_loop() which allows the
platform to completely override the idle loop, though we rarely do it (I
think only iSeries does it nowadays).

So I see no need to -add- another callback here. I'm not entirely sure
what the cpuidle framework does, it's no obvious from Arun commit
messages I must say, but it doesn't look like the right approach for
integration. In fact, pSeries already have a choice between different
powersave models depending on what kind of hypervisor is there.

So Arun, please try to fit nicely within the existing interfaces, or if
you want to add a new one, please justify very precisely what design
decisions lead you to that.

Finally, there's also a problem with your first patch 1/2: You are
setting a Kconfig flag unconditionally indicating that the arch supports
some idle wait function, but you only implement it somewhere in
arch/powerpc/platform/pseries, so you'll break the build of any other
platform. You also prevent another platform to implement a different one
and be built in the same kernel.

For such generic callbacks, if it's justified (and only if it is), you
can add a ppc_md. hook for the platform to fill, and you need to cater
for platforms that don't.

Cheers,
Ben.


