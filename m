Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbYD3Fh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbYD3Fh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 01:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYD3FhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 01:37:14 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:47946 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYD3FhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 01:37:13 -0400
Date: Wed, 30 Apr 2008 11:07:03 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 5/8] cpu: cpu-hotplug deadlock
Message-ID: <20080430053703.GB9053@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080429125659.GA23562@in.ibm.com> <20080429130201.GF23562@in.ibm.com> <20080429143350.GA246@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429143350.GA246@tv-sign.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 06:33:50PM +0400, Oleg Nesterov wrote:
> On 04/29, Gautham R Shenoy wrote:
> >
> > cpu_hotplug.mutex is basically a lock-internal lock; but by keeping it locked
> > over the 'write' section (cpu_hotplug_begin/done) a lock inversion happens when
> > some of the write side code calls into code that would otherwise take a
> > read lock.
> >
> > And it so happens that read-in-write recursion is expressly permitted.
> >
> > Fix this by turning cpu_hotplug into a proper stand alone unfair reader/writer
> > lock that allows reader-in-reader and reader-in-writer recursion.
> 
> While the patch itself is very clean and understandable, I can't understand
> the changelog ;)
> 
> Could you explain what is the semantics difference? The current code allows
> read-in-write recursion too.

How about the following ?
----------------------------------------------------------------------------
cpu_hotplug: split the cpu_hotplug.lock mutex into a spinlock and a waitqueue.

Consider the following callpath:
get_online_cpus()
.
.
.
some_fn()--> takes some_lock; /* lock_acquire(some_lock) [1] */
.
.
.
get_online_cpus();  /* lock_acquire(cpu_hotplug.lock) [2] */

and on the cpu_hotplug callback path, we have
cpu_hotplug.lock /* lock_acquire(cpu_hotplug.lock) [3]*/
.
.
.
some_other_fn() ----> take some_lock /* lock_acquire(some_lock) [4]*/

lockdep will treat this as a  ABBA possiblity since on the write path we
currently hold the lock so that the readers are blocked on it.

However, the write path won't be activated until the refcount goes
to zero. Which means that lockdep yelling at [2] is a false positive.

Hence we need to split the mutex into a seperate spin_lock under which
the refcount can be incremented, and introduce a waitqueue where the readers
can block during a ongoing cpu-hotplug operation, and provide lockdep
annotation only when the reader is about to block.
----------------------------------------------------------------------------

> 
> The only difference I can see is that now cpu_hotplug_begin() doesn't rely
> on cpu_add_remove_lock any longer (currently the caller must hold this lock),
> but this (good) change is not documented.
> 
> >  static void cpu_hotplug_done(void)
> >  {
> > +	spin_lock(&cpu_hotplug.lock);
> >  	cpu_hotplug.active_writer = NULL;
> > -	mutex_unlock(&cpu_hotplug.lock);
> > +	if (!list_empty(&cpu_hotplug.writer_queue.task_list))
> 
> waitqueue_active() ?
> 
> > +		wake_up(&cpu_hotplug.writer_queue);
> > +	else
> > +		wake_up_all(&cpu_hotplug.reader_queue);
> 
> Please note that wake_up() and wake_up_all() doesn't differ here, because
> cpu_hotplug_begin() use prepare_to_wait(), not prepare_to_wait_exclusive().
> I'd suggest to change cpu_hotplug_begin(), and use wake_up() for both
> cases.
> 
> (actually, since write-locks should be very rare, perhaps we don't need
>  2 wait_queues ?)
>
> Oleg.

-- 
Thanks and Regards
gautham
