Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZAZWnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZAZWnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZAZWni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:43:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZAZWnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:43:37 -0500
Date: Mon, 26 Jan 2009 23:42:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       rusty@rustcorp.com.au, travis@sgi.com, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126224252.GA30160@elte.hu>
References: <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126214516.GA22142@elte.hu> <20090126140116.35f9c173.akpm@linux-foundation.org> <20090126221502.GA4542@redhat.com> <20090126222405.GA15896@elte.hu> <20090126223703.GA5508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126223703.GA5508@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/26, Ingo Molnar wrote:
> >
> > Andrew's suggestion does make sense though: for any not-in-progress
> > worklet we can dequeue that worklet and execute it in the flushing
> > context. [ And if that worklet cannot be dequeued because it's being
> > processed then that's fine and we can wait on that single worklet, without
> > waiting on any other 'unrelated' worklets. ]
> 
> Yes sure. This is easy, and I am not sure we need the special handler.
> If the caller wants this behaviour, it can do:
> 
> 	if (cancel_work_sync(work))
> 		work->func(work);
> 
> But flush_work() was specially introduced for the case when we can't
> do the above,

it would be better to have this implicit in some wait_for_work() facility 
(which flush_work() really is) - because it is not intuitive to code a 
serialization as a 'cancel + execute open-coded' sequence.

> > That does not help work_on_cpu() though: that facility really uses the 
> > fact that workqueues are implemented via per CPU threads - hence we 
> > cannot remove the worklet from the queue and execute it in the 
> > flushing context.
> 
> Yes.

it's arguably a (mild, albeit elegant) abuse of workqueue internals 
though.

	Ingo
