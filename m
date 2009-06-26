Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbZFZMo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbZFZMo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZFZMov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:44:51 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47682 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbZFZMou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:44:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19012.49854.67117.211218@cargo.ozlabs.ibm.com>
Date: Fri, 26 Jun 2009 22:44:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [RFC][PATCH] perf_counter: Complete counter swap.
In-Reply-To: <1246014623.31755.195.camel@twins>
References: <new-submission>
	<tip-bfbd3381e63aa2a14c6706afb50ce4630aa0d9a2@git.kernel.org>
	<1246014623.31755.195.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Right, so I convinced myself we indeed want to swap the times as well,
> and realized we need to update the userpage after modifying these
> counters.
> 
> Then again, since inherited counters tend to wander around
> self-monitoring mmap() + inherit is bound to be broken.. hmm?
> 
> Do we want to fix that or shall we simply say: don't do that then!

We only swap the contexts around if all the counters in both contexts
have been inherited, i.e. neither context is a top-level parent
context.  Now I had been going to say that a counter that had been
inherited couldn't be used for self-monitoring, and I think that is
actually true, but I guess the problem is that the child could have
inherited the fd and the mmap too, but the mmap will be on the parent
counter not the inherited child counter.  And there's no way for the
child (or anyone) to mmap the inherited counter since there's no fd
for it.

Currently we don't do anything to stop people trying to read the
counters directly when they're not self-monitoring - they just get
bogus data.  Maybe we should put the tid of the task the counter's on
into the first page of the mmap so that userspace can at least check
if it's the task being monitored.

Unless you can see some way to change the mmap on fork to point to the
child counter rather than the parent...  Which would possibly be a bit
nasty anyway since then the child's address space wouldn't be clone of
the parent's like you would expect after a fork.

Paul.
