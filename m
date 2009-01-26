Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbZAZNzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbZAZNzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZAZNzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:55:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZAZNzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:55:06 -0500
Subject: Re: CPU scheduler question/problem
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Dziekonski <dzieko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2cd4df870901260548s2376a01anae0db9707dcfa14@mail.gmail.com>
References: <2cd4df870901221334n7e242e79ka961f899c03c70cb@mail.gmail.com>
	 <1232725219.4826.131.camel@laptop>
	 <2cd4df870901260548s2376a01anae0db9707dcfa14@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 14:55:00 +0100
Message-Id: <1232978100.4863.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 14:48 +0100, Pawel Dziekonski wrote:
> 2009/1/23 Peter Zijlstra <peterz@infradead.org>:
> 
> > The pipe workload you mentioned has would behave that way because pipes
> > 'assume' a produces/consumer behaviour, and thus are more likely to
> > place both tasks on the same cpu -- but will eventually pull them apart
> > if they want to run concurrently.
> >
> > You might enable SCHED_DEBUG=y and try
> >  echo NO_SYNC_WAKEUPS > /debug/sched_features
> 
> Hello,
> 
> that did the trick. Openssl now gets a whole core exclusively and gives full
> performance.
> 
> Regarding quantum chemistry application -- it is also using pipes
> for communication between worker processes. Now this app works OK.

Hmm, how long does a worker run for each received packet? The thing is,
if the data is cache affine for the issuing cpu, and the worker runs
short it often doesn't make sense to run it remote, as the cache
transfer will hurt more.

If it runs longer, the balancer will usually pick it up and move it
around.

/debug/sched_features is mostly a debug tool, its not a supported/stable
tuning interface.

> Where I can read more on tuning sched_features for different workloads?

kernel/sched*.[ch] ;-)

> Also, is there a way get a list of available schedulers and how to switch
> between them?

include/linux/sched.h:

#define SCHED_NORMAL		0
#define SCHED_FIFO		1
#define SCHED_RR		2
#define SCHED_BATCH		3
/* SCHED_ISO: reserved but not implemented yet */
#define SCHED_IDLE		5

and the posix sched_{set,get}schedule() functions.

