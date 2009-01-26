Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZAZWR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZAZWR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZAZWRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:17:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbZAZWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:17:17 -0500
Date: Mon, 26 Jan 2009 14:16:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090126141605.707877bb.akpm@linux-foundation.org>
In-Reply-To: <20090126220537.GA6755@elte.hu>
References: <200901261711.43943.rusty@rustcorp.com.au>
	<20090125230130.bcdab2e5.akpm@linux-foundation.org>
	<20090126171618.GA32091@elte.hu>
	<20090126103529.cb124a58.akpm@linux-foundation.org>
	<20090126202022.GA8867@elte.hu>
	<20090126130046.37b8f34e.akpm@linux-foundation.org>
	<20090126212727.GA13670@elte.hu>
	<20090126133551.fab5e27a.akpm@linux-foundation.org>
	<20090126214516.GA22142@elte.hu>
	<20090126140116.35f9c173.akpm@linux-foundation.org>
	<20090126220537.GA6755@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 23:05:37 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Well it turns out that I was having a less-than-usually-senile moment:
> > 
> > :     implement flush_work()
> 
> > Why isn't that working in this case??
> 
> how would that work in this case? We defer processing into the workqueue 
> exactly because we want its per-CPU properties.

It detaches the work item, moves it to head-of-queue, reinserts it then
waits on it.  I think.

This might have a race+hole.  If a currently-running "unrelated"
work item tries to take the lock which the flush_work() caller is holding
then there's no way in which keventd will come back to execute
the work item which we just put on the head of queue.

> We want work_on_cpu() to 
> be done in the workqueue context on the CPUs that were specified, not in 
> the local CPU context.

flush_work() is supposed to work in the way which you describe.

But Oleg's "we may be running on a different CPU" comment has me all
confused.

