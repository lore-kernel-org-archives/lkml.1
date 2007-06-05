Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbXFERko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbXFERko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXFERkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:40:36 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:36509 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753873AbXFERkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:40:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=WhQt1iJsCo+1IHV03xkV1A0pZSoLTp/Xg6U8dhRywtNX9KVW3/EdyV+nOTWD3vESrh8RhoPrVXbVFECsjKs96EEJLHpn6YtcTdgsFl1s2SNn+np+404YK+YiqMRTfinIWOwxVVzM36SXh/Enc0W4ceoKWvwSXuP/EiCnvQn8dB4=;
Date: Tue, 5 Jun 2007 21:39:49 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
Message-ID: <20070605173949.GA27618@ms2.inr.ac.ru>
References: <20070507144351.GA12302@ms2.inr.ac.ru> <20070523072609.GC6859@elte.hu> <20070523115159.GA30251@ms2.inr.ac.ru> <1181060711.4404.114.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181060711.4404.114.camel@chaos>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Hmm, what means not expected ? -ESRCH is returned, when the owner task
> is not found. 

This is not supposed to happen with robust futexes.

glibs aborts (which is correct), or for build with disabled debugging
enters simulated deadlock (which is confusing).


> lock. Also using uval is wrong.

Yup. You are right.

This means those RETRY messages could be spurious. I must rerun the test.


> This does not really explain, why you do prevent the -ESRCH return value
> in the next cycle,

Because right curval is refetched, it already has FUTEX_OWNER_DIED bit set
and we succesfully take the lock.


> No, -EDEADLK is returned from here:
> 
> 	ret = rt_mutex_timed_lock(&q.pi_state->pi_mutex, to, 1);

Of course. It is the only place where ret is set. :-)

> 
> The rtmutex code only returns -EDEADLK, when the lock is already held by
> the task

This case.

> The fix is to remove it and to find the real cause of the problem.
> 
> I'm running the glibc tests since hours w/o tripping into it.

OK.

You need run only tst-robustpi8 in loop. It should be triggered quickly,
a few of minutes on 8-way smp here.

If you want, I can insert some debugging printks, which you need,
and run the test here.

Alexey
