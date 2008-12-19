Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYLSLm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYLSLm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYLSLmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:42:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58567 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbYLSLmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:42:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081219041401.GA29316@us.ibm.com>
References: <20081219041401.GA29316@us.ibm.com> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for doing very slow work items [ver #41]
Date: Fri, 19 Dec 2008 11:42:40 +0000
Message-ID: <10438.1229686960@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> > +	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
> 
> Can you explain the purpose of the SLOW_WORK_PENDING bit a bit more?
> I don't understand why you need it, or what exactly you're doing here.

If you look at the line immediately following that:

	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
		spin_lock_irqsave(&slow_work_queue_lock, flags);

you'll notice that it disables interrupts and takes a spinlock.  We'd like to
avoid that if we can.

> Seems like if someone enqueues a work item twice in a row, behavior
> is unpredicatble?  If it's done fast enough, the second submission
> will be ignored.

Yes, that's fine.  The facility promises to invoke the work function at some
time in the future; it doesn't promise to run it once per enqueuement request.

Another way to look at it is that if you call slow_work_enqueue(), you can be
certain that the work function will be run sometime in the future.

I could count the number of enquements and run the work function once per
enqueuement, but that isn't really necessary.  The work function can be made
to work that out for itself.  It can even enqueue itself if it thinks it
should be run again.

> If slow enough, then the first will have started executing already, so
> PENDING bit will have cleared, so this will set the DEFERRED bit.  But I
> suspect I'm completely misunderstanding?

The PENDING bit promises that the work function will be run in the future.

The ENQ_DEFERRED bit is an delayed form of queueing.  If a work item is
currently under execution, we cannot at this point queue it for further
execution as we promise that a work function will only be executing in one
thread at any one time.  If we did immediately stick it on the to-be-executed
queue, someone might come along and try executing it.

The ENQ_DEFERRED bit is handled at the end of execution, after the EXECUTING
bit has been cleared, but before the spinlock is dropped.  If the ENQ_DEFERRED
bit is set, the PENDING bit must also be set.

I guess I need to stick a comment in slow_work_enqueue() to detail this,
though the comments in slow_work_execute() do talk about it.

David
