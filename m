Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZJBPkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZJBPkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZJBPkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:40:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZJBPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:40:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4AC5E7BA.5060700@kernel.org>
References: <4AC5E7BA.5060700@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org> <9942.1254401629@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed workqueue
Date: Fri, 02 Oct 2009 16:38:03 +0100
Message-ID: <31399.1254497883@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Given that slow-work isn't being used too extensively yet, I was
> thinking whether that part could be pushed down to the caller.  Or, we
> can also wrap work and export an interface which supports the get/put
> reference.

The caller of what?

I found the refcounting much easier to manage in slow-work when slow-work
actively got/put refs on the work items it was queueing.  The reason for that
is that slow-work can handle the queue/queue races and the requeue/execute
races much more efficiently.

Part of this was due to the fact I wanted to prevent re-entry into the work
executor, and to do that I had maintenance flags in the work item struct - but
that meant that slow-work had to modify the work item after execution.

So I should adjust point 1 on my list.

  (1) Work items can be requeued whilst they are executing, but the execution
      function will not be re-entered until after the current execution
      completes, but rather the execution will be deferred.

One possible problem with assuming that you can no longer access the work item
after you call the execution function, is that it's slightly dodgy to retain
the pointer to it to prevent reentry as the item can be destroyed, reallocated
and queued before the execution function returns.

Anyway, don't let me put you off re-implementing the whole shebang - it needs
doing.

> Binding is usually beneficial and doesn't matter for IO intensive
> ones, so...

The scenario I'm thinking of is this: someone who has an NFS volume cached
through FS-Cache does a tar of a large tree of files (say a kernel source
tree).  FS-Cache adds a long duration work item for each of those files
(~32000) to create structure in the cache.  Will all of those wind up bound to
the same CPU as was running tar?

David
