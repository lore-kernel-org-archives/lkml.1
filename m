Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXFEVBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXFEVBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbXFEVBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:01:09 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:42882 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932891AbXFEVBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:01:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=nfvifJLg3Zm0cSt82E4bevsTJAsQjSccJllITdFRBV6mrRr7WcFvnwmyLWsy3jDowQqkyp5TkPslxqnj1hTeeXXE3YvT7jFuPMhpetDB1+npIoiji9rfcVBhjdFKfoMqCvT2/+iBNXcWzGqtii2LEI3rmdIf+TUSJbztoQZ3reA=;
Date: Wed, 6 Jun 2007 01:00:28 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
Message-ID: <20070605210028.GA10084@ms2.inr.ac.ru>
References: <20070507144351.GA12302@ms2.inr.ac.ru> <20070523072609.GC6859@elte.hu> <20070523115159.GA30251@ms2.inr.ac.ru> <1181060711.4404.114.camel@chaos> <20070605173949.GA27618@ms2.inr.ac.ru> <1181069306.4404.145.camel@chaos> <1181070953.4404.149.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181070953.4404.149.camel@chaos>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> We actually need to do something about this, as we might loop for ever
> there. The robust cleanup code can fail (e.g. due to list corruption)
> and we would see exit_state != 0 and the OWNER_DIED bit would never be
> set, so we are stuck in a busy loop.

Yes...

It is possible to take read_lock(&tasklist_lock) before:

        inc_preempt_count();
        curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
        dec_preempt_count();

and drop it after lookup_pi_state().

In this case exiting task will set FUTEX_OWNER_DIED, but will
spin in exit_notify(), we will find valid pi_state and go slow path
taking rtmutex.

Alexey
