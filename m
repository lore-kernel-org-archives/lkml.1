Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbZESMGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbZESMGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZESMGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:06:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZESMGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:06:36 -0400
Date: Tue, 19 May 2009 14:00:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency at
	cleanup_workqueue_thread
Message-ID: <20090519120010.GA14782@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local> <20090518194749.GA3501@redhat.com> <1242723104.17164.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242723104.17164.5.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Johannes Berg wrote:
>
> On Mon, 2009-05-18 at 21:47 +0200, Oleg Nesterov wrote:
>
> > > Maybe it shouldn't do that from the CPU_POST_DEAD
> > > notifier?
> >
> > Well, in any case we should understand why we have the problem, before
> > changing the code. And CPU_POST_DEAD is not special, why should we treat
> > it specially and skip lock_map_acquire(wq->lockdep_map) ?
>
> I'm not familiar enough with the code -- but what are we really trying
> to do in CPU_POST_DEAD? It seems to me that at that time things must
> already be off the CPU, so ...?

Yes, this cpu is dead, we should do cleanup_workqueue_thread() to kill
cwq->thread.

> On the other hand that calls
> flush_cpu_workqueue() so it seems it would actually wait for the work to
> be executed on some other CPU, within the CPU_POST_DEAD notification?

Yes. Because we can't just kill cwq->thread, we can have the pending
work_structs so we have to flush.

Why can't we move these works to another CPU? We can, but this doesn't
really help. Because in any case we should at least wait for
cwq->current_work to complete.

Why do we use CPU_POST_DEAD, and not (say) CPU_DEAD to flush/kill ?
Because work->func() can sleep in get_online_cpus(), we can't flush
until we drop cpu_hotplug.lock.

Oleg.

