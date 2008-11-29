Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYK2TVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYK2TVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 14:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYK2TVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 14:21:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYK2TVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 14:21:02 -0500
Date: Sat, 29 Nov 2008 11:19:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] sched: prevent divide by zero error in
 cpu_avg_load_per_task
In-Reply-To: <20081127020554.533035163@goodmis.org>
Message-ID: <alpine.LFD.2.00.0811291107400.24125@nehalem.linux-foundation.org>
References: <20081127020423.460116740@goodmis.org> <20081127020554.533035163@goodmis.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Nov 2008, Steven Rostedt wrote:
>  {
>  	struct rq *rq = cpu_rq(cpu);
> +	unsigned long nr_running = rq->nr_running;
>  
> -	if (rq->nr_running)
> -		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
> +	if (nr_running)
> +		rq->avg_load_per_task = rq->load.weight / nr_running;
>  	else
>  		rq->avg_load_per_task = 0;

I don't think this necessarily fixes it.

There's nothing that keeps gcc from deciding not to reload rq->nr_running. 

Of course, in _practice_, I don't think gcc ever will (if it decides that 
it will spill, gcc is likely going to decide that it will literally spill 
the local variable to the stack rather than decide to reload off the 
pointer), but it's a valid compiler optimization, and it even has a name 
(rematerialization).

So I suspect that your patch does fix the bug, but it still leaves the 
fairly unlikely _potential_ for it to re-appear at some point.

We have ACCESS_ONCE() as a macro to guarantee that the compiler doesn't 
rematerialize a pointer access. That also would clarify the fact that we 
access something unsafe outside a lock.

			Linus
