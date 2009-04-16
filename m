Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZDPOi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZDPOi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZDPOiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:38:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45714 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZDPOiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:38:17 -0400
Date: Thu, 16 Apr 2009 16:33:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Trond.Myklebust@netapp.com,
       serue@us.ibm.com, steved@redhat.com, viro@zeniv.linux.org.uk,
       Daire.Byrne@framestore.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Message-ID: <20090416143351.GD6532@redhat.com>
References: <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14561.1239873018@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, David Howells wrote:
>
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > I wonder if slow_work_cull_timeout() should have some sort of barrier,
> > so the write is suitably visible to the woken thread.
>
> That's an interesting question.  Should wake_up() imply a barrier of any sort,
> I wonder.  Well, __wake_up() does impose a barrier as it uses a spinlock, but
> I wonder if that's sufficient.

wake_up() does imply the barrier. Note the smp_wmb() in try_to_wake_up().
And in fact this wmb() implies mb(), because spin_lock() itself is STORE,
and the futher LOADs can't leak up before spin_lock().

But afaics, this doesn't matter? prepare_to_wait() sets task->state under
wait_queue_head_t->lock and wake_up() takes this look too, so we can't miss
the event.

Or I completely misunderstood the issue...

Oleg.

