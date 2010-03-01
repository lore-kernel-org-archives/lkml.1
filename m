Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab0CASxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:53:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab0CASxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:53:47 -0500
Date: Mon, 1 Mar 2010 19:51:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 20/43] workqueue: reimplement work flushing using linked
	works
Message-ID: <20100301185153.GA18607@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-21-git-send-email-tj@kernel.org> <20100301145344.GA9815@redhat.com> <4B8C00BB.4090500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8C00BB.4090500@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Tejun Heo wrote:
>
> On 03/01/2010 11:53 PM, Oleg Nesterov wrote:
> >
> > and in this case we put this barrier at the head of ->scheduled list.
> >
> > This means, this barrier will run after that work W, not before it?
>
> Yes, the barrier will run after the target work as it should.

You are right. it will run after target work == current_work and before
the next pending work W.

Because,

> > Hmm. And what if there are no pending works but ->current_work == target ?
> > Again, we add the barrier to ->scheduled, but in this case worker_thread()
> > can't even notice ->scheduled is not empty because it only checks ->worklist?
>
> A worker always checks ->scheduled after a work is finished.

Yes! I missed this, thanks.



> > insert_wq_barrier() also does:
> >
> > 	unsigned long *bits = work_data_bits(target);
> > 	...
> > 	*bits |= WORK_STRUCT_LINKED;
> >
> > perhaps this needs atomic_long_set(), although I am not sure this really
> > matters.
>
> Yeah, well, work->data access is pretty messed up.  At this point,
> there's no reason for atomic_long_t to begin with.

grep, grep, grep... arch/sparc/lib/atomic32.c uses spinlocks for
atomic_set() and ___set_bit(). Probably that is why atomic_long_set()
is really needed to avoid the race with test_and_set_bit(PENDING).

Oleg.

