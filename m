Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbZJAIlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbZJAIlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbZJAIlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:41:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34303 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZJAIli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:41:38 -0400
Date: Thu, 1 Oct 2009 10:40:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed
	workqueue
Message-ID: <20091001084040.GA15345@elte.hu>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, all.
> 
> This rather large patchset implements concurrency managed workqueue. 
> It's not complete yet.  Singlethread workqueue handling needs more 
> work and workqueue users need to be audited and simplified and async 
> and slow-work should be reimplemented in terms of workqueue.  Although 
> this patchset currently adds ~2000 lines of code, I'm fairly 
> optimistic that after the whole conversion is done, it would be a net 
> decrease in lines of code.
> 
> This patchset reimplements workqueue such that it auto-regulates 
> concurrency and thus relieves its users from the managing duty.  It 
> works by managing single shared pool of per-cpu workers and hooking 
> into the scheduler to get notifications about workers going to sleep 
> and waking up.  Using the mechanism, workqueue implementation keeps 
> track of the current level of concurrency and schedules only the 
> necessary number of workers to keep the cpu occupied.

Ok, this looks fairly interesting - and the way you reused scheduler 
classes to auto-regulate with no impact on regular performance is quite 
an ingenious idea as well. (KVM's preempt notifiers should probably use 
this trick too, instead of an ugly notifier in the scheduler hotpath)

This mechanism could be used to implement threadlets/syslets too btw., 
and other forms of asynchronous IO.

My main worry is that in practice workqueues arent all that performance 
critical - so we are shooting to optimize something that doesnt 
necessarily use all the potential goodness inherent in this approach.

	Ingo
