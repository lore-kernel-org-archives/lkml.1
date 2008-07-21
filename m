Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYGUP4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYGUP4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYGUPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:55:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:44351 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYGUPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rDSnzKhXL2umIDHJ3DX0k863KUn+8by+zFue/O7D1a61j0b/7r9ShOoLSWWY6D59zu
         v2pHTXhjr9+6iy3j1urjbqKU4foUS6jrPqdpc9x3zLQtaC+5ut64budM9lmlhncwAZxI
         IbiMK9TB2fKzKhccyMwPyTPpWg7MbH9pKXlec=
Message-ID: <6101e8c40807210855o690f151i668876872cc148c6@mail.gmail.com>
Date: Mon, 21 Jul 2008 17:55:51 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer signal
Cc: "Roland McGrath" <roland@redhat.com>,
       "Mark McLoughlin" <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       stable@kernel.org
In-Reply-To: <20080721152352.GA182@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216219846-663-1-git-send-email-markmc@redhat.com>
	 <20080716162131.GA1785@tv-sign.ru> <1216292911.28332.12.camel@muff>
	 <20080717135556.GA770@tv-sign.ru> <1216377558.12300.13.camel@muff>
	 <20080719163734.GA389@tv-sign.ru>
	 <20080720065240.B3D3715421D@magilla.localdomain>
	 <20080720110856.GC143@tv-sign.ru>
	 <20080721004722.5869515421D@magilla.localdomain>
	 <20080721152352.GA182@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add stable]

On 7/21/08, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> On 07/20, Roland McGrath wrote:
>>
>> > Yes, thanks, I see. But does it have any meaning for the user-space?
>> [si_sys_private]
>>
>> No, it's not part of the user ABI.  It's not even copied out (see
>> copy_siginfo_to_user).
>
> Heh, I didn't know, thanks.
>
>> > Let me repeat. Can't we make a simple fix for now for this nasty and
>> > ancient bug, before we do the more clever changes,
>>
>> You do need to clear si_overrun there to be correct in the usual case
>> (not already queued).
>
> Indeed, I missed that. Can't we do this in send_sigqueue() ?
>
>> It would be a perfectly fine and worthwhile optimization/cleanup on its
>> own just to move all the initialization of sigq->info (everything but
>> si_sys_private) to alloc_posix_timer.
>
> Yes, we can do this in sys_timer_create(). But this is not very trivial to
> do without uglifying the code futher, note this "if (timer_event_spec)".
> And we can't do this after "->it_process = process", the timer is already
> visible to sys_timer_settime().
>
>> Even if it's a fine stopgap, I'm not comfortable calling this a real
>> "fix".
>> ...
>> I don't find it easy to be sure there aren't more bad
>> problems caused by trying to re-send the same sigqueue entry.
>
> Yes, yes, I agree. I propose this change as a first step only.
>
>> It seems likely this is the good choice for the stable branch.
>
> So, what do you and Mark think about the patch below?
>
>> > The thread which does dequeue_signal() continues and re-schedules the
>> > timer while ->sigq is queued. Then it copies sigq->info to the user
>> > space.
>>
>> The thread that dequeued the first timer signal had ceased all reference
>> to sigq by the time it unlocked siglock.  When its do_schedule_next_timer
>> call gets it_lock, it can do bookkeeping in struct k_itimer to figure out
>> what posix_timer_event or timer_settime has done lately.
>
> Yes, this should work.
>
> Oleg.
>
> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -298,12 +298,10 @@ void do_schedule_next_timer(struct sigin
>
>  int posix_timer_event(struct k_itimer *timr,int si_private)
>  {
> -	memset(&timr->sigq->info, 0, sizeof(siginfo_t));
>  	timr->sigq->info.si_sys_private = si_private;
>  	/* Send signal to the process that owns this timer.*/
>
>  	timr->sigq->info.si_signo = timr->it_sigev_signo;
> -	timr->sigq->info.si_errno = 0;
>  	timr->sigq->info.si_code = SI_TIMER;
>  	timr->sigq->info.si_tid = timr->it_id;
>  	timr->sigq->info.si_value = timr->it_sigev_value;
> @@ -435,6 +433,7 @@ static struct k_itimer * alloc_posix_tim
>  		kmem_cache_free(posix_timers_cache, tmr);
>  		tmr = NULL;
>  	}
> +	memset(&tmr->sigq->info, 0, sizeof(siginfo_t));
>  	return tmr;
>  }
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1310,6 +1310,7 @@ int send_sigqueue(struct sigqueue *q, st
>  		q->info.si_overrun++;
>  		goto out;
>  	}
> +	q->info.si_overrun = 0;
>
>  	signalfd_notify(t, sig);
>  	pending = group ? &t->signal->shared_pending : &t->pending;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
