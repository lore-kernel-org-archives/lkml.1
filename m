Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZBAKlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZBAKlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZBAKky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:40:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50527 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbZBAKkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:40:53 -0500
Date: Sun, 1 Feb 2009 11:38:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kthreads: move sched-realeted initialization from
	kthreadd context
Message-ID: <20090201103817.GB5728@redhat.com>
References: <20090130123350.GA26206@redhat.com> <200901312117.17082.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901312117.17082.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31, Rusty Russell wrote:
>
> On Friday 30 January 2009 23:03:50 Oleg Nesterov wrote:
> > (on top of kthread-dont-looking-for-a-task-in-create_kthread-2.patch)
>
> Hi Oleg,
>
>    Thanks for the cc: Vitaliy, I never saw that patch.  I've included it in my queue now.
>
> As to this patch, it seems marginal.  I've never been convinced that we should
> be trying to rescue root if they choose to set kthreadd's prio anyway,

I agree. Personally, I never understood this too. But if we want to
remove this code we need the separate discussion, so I just moved it
to the caller's context.

> but I'm also wondering why we care about kthread_create scalability!

It is always better to speedup things and to decrease the latency ;)

But I also think this and the next patch make the code simpler and
more clean. Now the only thing create_kthread() does is a plain fork()
and nothing else, this is imho good.

> Still, I'm happy to apply it with one change:
>
> > +		/*
> > +		 * root may have changed our (kthreadd's) priority or CPU mask.
> > +		 * The kernel thread should not inherit these properties.
> > +		 */
> > +		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
> > +		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
> > +		set_cpus_allowed_ptr(create.result, CPU_MASK_ALL_PTR);
>
> cpu_all_mask is the non-deprecated replacement for CPU_MASK_ALL_PTR.

Great, thanks.

(btw, I thought about avoiding CPU_MASK_ALL_PTR too, but I didn't
 dare to mix 2 different things in one patch).

Oleg.

