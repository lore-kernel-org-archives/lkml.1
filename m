Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZBRQen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZBRQen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZBRQeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:34:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbZBRQea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:34:30 -0500
Date: Wed, 18 Feb 2009 08:33:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
 ipi fallback for smp_call_function_many())
In-Reply-To: <20090218162116.GC29863@elte.hu>
Message-ID: <alpine.LFD.2.00.0902180828430.21686@localhost.localdomain>
References: <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com>
 <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de> <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain> <20090218162116.GC29863@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Feb 2009, Ingo Molnar wrote:
> 
> But ... WRMSR should already be serializing - it is documented 
> as a serializing instruction.

Hmm. I was thinking about this some more, and I think I've come up with an 
explanation.

"wrmsr" probably serializes _after_ doing the write. After all, it's 
historically used for changing internal CPU state, so you want to do the 
write, and then wait until the effects of the write are "stable" in the 
core.

That would explain how x2apic can use both a serializing instruction 
(wrmsr) and still effectively cause the IPI to happen out of sequence: the 
IPI can reach the destination CPU before the source CPU has flushed its 
store buffers, because the IPI is actually sent before serializing the 
core.

But I would very strongly put this in the "x2apic code bug" column. If 
this is a true issue (and your TLB patch does imply it is), then we should 
just make sure that the x2apic IPI calls always do a 'sfence' before they 
happen - regardless of whether they are for TLB flushes or for generic 
kernel cross-calls, or for anything else.

			Linus
