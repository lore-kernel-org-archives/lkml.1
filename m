Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbYD3Lmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbYD3Lmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbYD3Lmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:42:40 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41731 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762962AbYD3Lmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:42:39 -0400
Date: Wed, 30 Apr 2008 15:43:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 5/8] cpu: cpu-hotplug deadlock
Message-ID: <20080430114305.GB134@tv-sign.ru>
References: <20080429125659.GA23562@in.ibm.com> <20080429130201.GF23562@in.ibm.com> <20080429143350.GA246@tv-sign.ru> <20080430053703.GB9053@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430053703.GB9053@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Gautham R Shenoy wrote:
>
> On Tue, Apr 29, 2008 at 06:33:50PM +0400, Oleg Nesterov wrote:
> >
> > Could you explain what is the semantics difference? The current code allows
> > read-in-write recursion too.
>
> How about the following ?
> ----------------------------------------------------------------------------
> cpu_hotplug: split the cpu_hotplug.lock mutex into a spinlock and a waitqueue.
>
> Consider the following callpath:
> get_online_cpus()
> .
> .
> .
> some_fn()--> takes some_lock; /* lock_acquire(some_lock) [1] */
> .
> .
> .
> get_online_cpus();  /* lock_acquire(cpu_hotplug.lock) [2] */
>
> and on the cpu_hotplug callback path, we have
> cpu_hotplug.lock /* lock_acquire(cpu_hotplug.lock) [3]*/
> .
> .
> .
> some_other_fn() ----> take some_lock /* lock_acquire(some_lock) [4]*/
>
> lockdep will treat this as a  ABBA possiblity since on the write path we
> currently hold the lock so that the readers are blocked on it.
>
> However, the write path won't be activated until the refcount goes
> to zero. Which means that lockdep yelling at [2] is a false positive.

Thanks...

So, we need these complications to avoid a false positive from lockdep...
I wonder if it is possible to simply hide this internal mutex from lockdep.

OK, at least get_online_cpus() doesn't suffer from the performance pov,
and lockdep is really important. (I didn't actually understand this until
it found the bug introduced by me ;)

BTW, not that it matters, but get_online_cpus/put_online_cpus can check
"cpu_hotplug.active_writer == current" lockless.

Thanks!

Oleg.

