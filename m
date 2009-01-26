Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZAZVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZAZVxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZAZVxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:53:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37241 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbZAZVxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:53:24 -0500
Date: Mon, 26 Jan 2009 22:50:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090126215049.GA3493@redhat.com>
References: <20090116191108.533053000@polaris-admin.engr.sgi.com> <20090124001537.7cfde78e.akpm@linux-foundation.org> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org> <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126133551.fab5e27a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Andrew Morton wrote:
>
> On Mon, 26 Jan 2009 22:27:27 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > > So if it's generic it ought to be implemented in a generic way - not a 
> > > > "dont use from any codepath that has a lock held that might 
> > > > occasionally also be held in a keventd worklet". (which is a totally 
> > > > unmaintainable proposition and which would just cause repeat bugs 
> > > > again and again.)
> > > 
> > > That's different.  The core fault here lies in the keventd workqueue 
> > > handling code.  If we're flushing work A then we shouldn't go and block 
> > > behind unrelated work B.
> > 
> > the blocking is inherent in the concept of "a queue of worklets handled by 
> > a single thread".
> > 
> > If a worklet is blocked then all other work performed by that thread is 
> > blocked as well. So by waiting on a piece of work in the queue, we wait 
> > for all prior work queued up there as well.
> > 
> > The only way to decouple that and to make them independent (and hence 
> > independently flushable) is to create more parallel flows of execution: 
> > i.e. by creating another thread (another workqueue).
> > 
> 
> Nope.  As I said, the caller of flush_work() can detach the work item
> and run it directly.

I am totally confused, just can't understand this thread...

I guess, we can't detach and execute because we can run on the
different CPU.

But "[PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in work_on_cpu."
removes get_online_cpus/put_online_cpus, this means the work can run on
the wrong CPU anyway. Or work_on_cpu() can hang forever if CPU has already
gone away before queue_work_on().

Confused.

Oleg.

