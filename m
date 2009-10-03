Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZJCFHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZJCFHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 01:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZJCFHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 01:07:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:38520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZJCFHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 01:07:08 -0400
Message-ID: <4AC6DBFE.1090103@kernel.org>
Date: Sat, 03 Oct 2009 14:07:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed workqueue
References: <4AC5E7BA.5060700@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org> <9942.1254401629@redhat.com> <31399.1254497883@redhat.com>
In-Reply-To: <31399.1254497883@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 03 Oct 2009 05:06:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Given that slow-work isn't being used too extensively yet, I was
>> thinking whether that part could be pushed down to the caller.  Or, we
>> can also wrap work and export an interface which supports the get/put
>> reference.
> 
> The caller of what?

The user of the API.  It can be implemented there too, right?

> I found the refcounting much easier to manage in slow-work when slow-work
> actively got/put refs on the work items it was queueing.  The reason for that
> is that slow-work can handle the queue/queue races and the requeue/execute
> races much more efficiently.
> 
> Part of this was due to the fact I wanted to prevent re-entry into the work
> executor, and to do that I had maintenance flags in the work item struct - but
> that meant that slow-work had to modify the work item after execution.
> 
> So I should adjust point 1 on my list.
> 
>   (1) Work items can be requeued whilst they are executing, but the execution
>       function will not be re-entered until after the current execution
>       completes, but rather the execution will be deferred.

This is already guaranteed on a single cpu, so unless a work ends up
being scheduled on a different cpu, it will be okay.  This actually is
about the same problem as how to support singlethread workqueue.  I'm
not entirely sure how to choose the cpu for such works yet.

> One possible problem with assuming that you can no longer access the work item
> after you call the execution function, is that it's slightly dodgy to retain
> the pointer to it to prevent reentry as the item can be destroyed, reallocated
> and queued before the execution function returns.

All the above is already implemented to avoid running the same work
parallelly on the same cpu and flushing.

>> Binding is usually beneficial and doesn't matter for IO intensive
>> ones, so...
> 
> The scenario I'm thinking of is this: someone who has an NFS volume cached
> through FS-Cache does a tar of a large tree of files (say a kernel source
> tree).  FS-Cache adds a long duration work item for each of those files
> (~32000) to create structure in the cache.  Will all of those wind up bound to
> the same CPU as was running tar?

Yeap, something to think about.  I considered adding a cpu workqueue
which isn't bound to any cpu to serve that type of workload but it
seemed too complex for the problem.  Maybe simple round robin with
per-cpu throttling should do the trick?

Thanks.

-- 
tejun
