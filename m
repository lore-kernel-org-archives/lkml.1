Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZJDIjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZJDIjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 04:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZJDIjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 04:39:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZJDIjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 04:39:52 -0400
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed
 workqueue
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Oct 2009 10:41:27 +0200
Message-Id: <1254645687.26976.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 17:08 +0900, Tejun Heo wrote:
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
> 
> Please read the patch description of the last patch for more details.
> 
> This patchset contains the following 19 patches and most of these are
> not signed off yet.

Like Linus, I dislike the sched_class bits (as in really hate them).

Also, from a quick look it looks like this scheme does not allow
priority inheritance of worklets, like we used to do in -rt.


