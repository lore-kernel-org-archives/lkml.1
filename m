Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZJATNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZJATNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbZJATM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:12:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbZJATM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:12:59 -0400
Date: Thu, 1 Oct 2009 12:11:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Avi Kivity <avi@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tejun Heo <tj@kernel.org>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 03/19] scheduler: implement workqueue scheduler class
In-Reply-To: <4AC4FC47.4010405@redhat.com>
Message-ID: <alpine.LFD.2.01.0910011207180.6996@localhost.localdomain>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-4-git-send-email-tj@kernel.org> <alpine.LFD.2.01.0910010953010.6996@localhost.localdomain> <20091001184824.GA21357@elte.hu> <4AC4FC47.4010405@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Avi Kivity wrote:
> 
> Sure, but it would mean that we need a new notifier.  sched_out, sched_in, and
> wakeup (and, return to userspace, with the new notifier).

Ok, see the email I just sent out.

And I don't think we want a new notifier - mainly because I don't think we 
want to walk the list four times (prepare, out, in, final - we need to 
make sure that these things nest properly, so even if "in" and "final" 
happen with the same state, they aren't the same, because "in" only 
happens if "out" was called, while "final" would happen if "prepare" was 
called)

So it would be better to have separate lists, in order to avoid walking 
the lists four times just because there was a single notifier that just 
wanted to be called for the inner (or outer) cases.

> btw, I've been thinking we should extend concurrency managed workqueues to
> userspace.  Right now userspace can spawn a massive amount of threads, hoping
> to hide any waiting by making more work available to the scheduler.  That has
> the drawback of increasing latency due to involuntary preemption.  Or
> userspace can use one thread per cpu, hope it's the only application on the
> machine, and go all-aio.

This is what the whole next-gen AIO was supposed to do with the 
threadlets, ie avoid doing a new thread if it could do the IO all cached 
and without being preempted. 

			Linus
