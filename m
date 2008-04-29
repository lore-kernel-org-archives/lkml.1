Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbYD2Qpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbYD2Qpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbYD2QpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:45:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55402 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbYD2QpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:45:05 -0400
Date: Tue, 29 Apr 2008 20:45:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 5/8] cpu: cpu-hotplug deadlock
Message-ID: <20080429164524.GA298@tv-sign.ru>
References: <20080429125659.GA23562@in.ibm.com> <20080429130201.GF23562@in.ibm.com> <20080429143350.GA246@tv-sign.ru> <1209481748.13978.84.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209481748.13978.84.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Peter Zijlstra wrote:
>
> The only thing that changed is that the mutex is not held; so what we
> change is:
> 
>  LOCK
> 
>  ... do the full hotplug thing ...
> 
>  UNLOCK
> 
> into
> 
>  LOCK
>   set state
>  UNLOCK
> 
>  ... do the full hotplug thing ...
> 
>  LOCK
>   unset state
>  UNLOCK
> 
> So that the lock isn't held over the hotplug operation.

Well, yes I see, but... Ugh, I have a a blind spot here ;)

why this makes any difference from the semantics POV ? why it is bad
to hold the mutex throughout the "full hotplug thing" ?

> > (actually, since write-locks should be very rare, perhaps we don't need
> >  2 wait_queues ?)
> 
> And just let them race the wakeup race, sure that might work. Gautham
> even pointed out that it never happens because there is another
> exclusive lock on the write path.
> 
> But you say you like that it doesn't depend on that anymore - me too ;-)

Yes. but let's suppose we have the single wait_queue, this doesn't make
any difference from the correctness POV, no?

To clarify: I am not arguing! this makes sense, but I'm asking to be sure
I didn't miss a subtle reason why do we "really" need 2 wait_queues.

Also. Let's suppose we have both read- and write- waiters, and cpu_hotplug_done()
does wake_up(writer_queue). It is possible that another reader comes and does
get_online_cpus() and increments .refcount first. After that, cpu_hotplug
is "opened" for the read-lock, but other read-waiters continue to sleep, and
the final put_online_cpus() wakes up write-waiters only. Yes, this all is
correct, but not "symmetrical", and leads to the question "do we really need
2 wait_queues" again.

Oleg.

