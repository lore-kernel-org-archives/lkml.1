Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYGBUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYGBUA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYGBUAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:00:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYGBUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:00:49 -0400
Date: Wed, 2 Jul 2008 16:00:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: benh@kernel.crashing.org, Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
Message-ID: <20080702200047.GA385@goodmis.org>
References: <1214916335.20711.141.camel@pasglop> <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop> <1215007896.3330.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215007896.3330.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 09:11:36AM -0500, James Bottomley wrote:
> 
> If you really need the full scheduling capabilities of threads, then it
> sounds like a threadpool is all you need (and we should just provide a
> unified interface).

Something like this may also be useful for the RT kernel as well. Being
able to push off tasks that we could prioritize would be greatly
beneficial.

Too bad we don't have a lighter task. Looking at the task_struct it
looks quite heavy, to be storing lots of threads. Perhaps we can clean
it up some time and remove out anything that would only be useful for
userspace threads. Not sure how much that would save us.

As for interrupt threads, those would help for some non-RT issues
(having a better desktop feel) but not for the issue that Ben has been
stating. I would be interested in knowing exactly what is needing to
handle a page fault inside the kernel.  If we need to do something for a
user space task, as soon as that task is found the work should be passed
to that thread.

> 
> Initially you were implying you'd prefer some type of non blockable
> workqueue (i.e. a workqueue that shifts to the next work item when and
> earlier item blocks).   I can see this construct being useful because it
> would have easier to use semantics and be more lightweight than a full
> thread spawn.  It strikes me we could use some of the syslets work to do
> this ... all the queue needs is an "next activation head", which will be
> the next job in the queue in the absence of blocking.  When a job
> blocks, syslets informs the workqueue and it moves on to the work on the
> "next activation head".  If a prior job unblocks, syslets informs the
> queue and it moves the "next activation head" to the unblocked job.
> What this is doing is implementing a really simple scheduler within a
> single workqueue, which I'm unsure is actually a good idea since
> schedulers are complex and tricky things, but it is probably worthy of
> discussion.

I think doing a "mini scheduler" inside a workgroup thread would be a
major hack.  We would have to have hooks into the normal scheduler to
let the mini-scheduler know something is blocking, and then have that
scheduler do some work. Not to mention that we need to handle
preemption.

Having a thread pool sounds much more reasonable and easier to
implement.

BTW, if something like this is implemented, I think that it should be a
replacement for softirqs and tasklets.

-- Steve

