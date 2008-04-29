Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYD2PJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYD2PJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYD2PJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:09:27 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:61885 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994AbYD2PJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:09:25 -0400
Subject: Re: [PATCH 5/8] cpu: cpu-hotplug deadlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20080429143350.GA246@tv-sign.ru>
References: <20080429125659.GA23562@in.ibm.com>
	 <20080429130201.GF23562@in.ibm.com>  <20080429143350.GA246@tv-sign.ru>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 17:09:08 +0200
Message-Id: <1209481748.13978.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 18:33 +0400, Oleg Nesterov wrote:
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

Yeah, my skillz lie elsewhere,.. :-/

The only thing that changed is that the mutex is not held; so what we
change is:

 LOCK

 ... do the full hotplug thing ...

 UNLOCK

into

 LOCK
  set state
 UNLOCK

 ... do the full hotplug thing ...

 LOCK
  unset state
 UNLOCK

So that the lock isn't held over the hotplug operation.

> Could you explain what is the semantics difference? The current code allows
> read-in-write recursion too.

Yes, that is a requirement.

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

I even looked to see if such a thing existed - must have been blind that
day.

> > +		wake_up(&cpu_hotplug.writer_queue);
> > +	else
> > +		wake_up_all(&cpu_hotplug.reader_queue);
> 
> Please note that wake_up() and wake_up_all() doesn't differ here, because
> cpu_hotplug_begin() use prepare_to_wait(), not prepare_to_wait_exclusive().
> I'd suggest to change cpu_hotplug_begin(), and use wake_up() for both
> cases.

Ah, I was not aware of that distinction. Thanks!

> (actually, since write-locks should be very rare, perhaps we don't need
>  2 wait_queues ?)

And just let them race the wakeup race, sure that might work. Gautham
even pointed out that it never happens because there is another
exclusive lock on the write path.

But you say you like that it doesn't depend on that anymore - me too ;-)

