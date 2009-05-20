Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZETXPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZETXPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZETXPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:15:33 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:36048 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZETXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:15:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18964.36622.94267.309523@cargo.ozlabs.ibm.com>
Date: Thu, 21 May 2009 09:15:26 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: dynamically allocate tasks'
	perf_counter_context struct
In-Reply-To: <20090520171207.GA16706@elte.hu>
References: <18963.63352.489273.92145@cargo.ozlabs.ibm.com>
	<20090520171207.GA16706@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > This replaces the struct perf_counter_context in the task_struct 
> > with a pointer to a dynamically allocated perf_counter_context 
> > struct.  The main reason for doing is this is to allow us to 
> > transfer a perf_counter_context from one task to another when we 
> > do lazy PMU switching in a later patch.
> 
> Hm, i'm not sure how far this gets us towards lazy PMU switching.
> 
> In fact i'd say that the term "lazy PMU switching" is probably 
> misleading, we should use: "equivalent PMU context switching" or 
> instead.

Yes, that's what I mean.

As you say, we need to be able to detect when two tasks have
equivalent contexts - that is, when their counters are all inherited
from a common ancestor.  My idea is that in that situation we simply
swap the contexts: move the context of the outgoing task onto the
incoming task, and give the incoming task's context to the outgoing
task.  With my patch, that involves simply swapping the pointers over
and adjusting the task pointers in the two contexts.

That means that all the counters get transferred over to the incoming
task, so there is nothing in the PMU or the arch code that needs to
changed or adjusted.  The outgoing task still has a perfectly valid
context, so it doesn't matter if it migrates to another CPU.  The
nice thing is that there is nothing special or unusual about the state
after we have swapped the contexts - nothing that needs to be
remembered or undone later.

Hopefully I'll have an actual patch to show you later today.

Paul.
