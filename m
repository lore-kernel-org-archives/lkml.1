Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbZJAIYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbZJAIYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbZJAIYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:24:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45246 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbZJAIYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:24:08 -0400
Date: Thu, 1 Oct 2009 10:24:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed
	workqueue
Message-ID: <20091001082411.GM14918@kernel.dk>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01 2009, Tejun Heo wrote:
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
> 
> Concurrency managed workqueue has the following benefits.
> 
> * Workqueue users no longer have to worry about managing concurrency
>   and, in most cases, deadlocks.  The workqueue will manage it
>   automatically and unless the deadlock chain involves many (currently
>   127) works, it won't happen.
> 
> * There's one single shared pool of workers per cpu and one rescuer
>   for each workqueue which requires it, so there are far fewer number
>   of kthreads.
> 
> * More efficient.  Although it adds considerable amount of code, the
>   code added to hot path isn't big and works will be executed on the
>   local cpu and in batch as much as possible using minimal number of
>   kthreads leading to fewer task switches and lower cache
>   footprint. <NEED SOME BACKING NUMBERS>
> 
> * As concurrency is no longer a problem, most types of asynchronous
>   jobs can be done using generic workqueue and other async mechanisms,
>   including slow-work, async and adhoc subsystem custom ones, can be
>   removed.  ie. It can serve as the unified async thread pool
>   mechanism.

Awesome work so far Tejun, I have high hopes for this patchset! I'll
take some time to review this when I have it, just consider this so far
a big encouragement to crank away on this. It's always annoyed me that
we have various methods for doing async work, this promises to unify
that very nicely.

-- 
Jens Axboe

