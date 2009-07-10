Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZGJPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZGJPMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZGJPMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:12:16 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:36558 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZGJPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:12:15 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] sched: Move the sleeping while atomic checks early
 in cond_resched()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090710150827.GA5318@nowhere>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com>
	 <1247237391-5352-2-git-send-email-fweisbec@gmail.com>
	 <1247237995.7529.43.camel@twins>  <20090710150827.GA5318@nowhere>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 17:12:08 +0200
Message-Id: <1247238728.7529.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 17:08 +0200, Frederic Weisbecker wrote:
> On Fri, Jul 10, 2009 at 04:59:55PM +0200, Peter Zijlstra wrote:
> > On Fri, 2009-07-10 at 16:49 +0200, Frederic Weisbecker wrote:
> > 
> > > index 0cb0d8d..e357dc7 100644
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -2279,11 +2279,13 @@ extern int _cond_resched(void);
> > >  #ifdef CONFIG_PREEMPT_BKL
> > >  static inline int cond_resched(void)
> > >  {
> > > +	might_sleep();
> > >  	return 0;
> > >  }
> > >  #else
> > >  static inline int cond_resched(void)
> > >  {
> > > +	might_sleep();
> > >  	return _cond_resched();
> > >  }
> > >  #endif
> > 
> > # define might_resched() _cond_resched()
> 
> 
> Argh, indeed.
> I thought might_sleep() only wrapped __might_sleep(__FILE__, __LINE__)
> 
>  
> > # define might_sleep() \
> > 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
> > 
> > 
> > Doesn't seem to make it any better that, but yeah, moving that
> > __might_sleep() did occur to me earlier today when I touched that code.
> 
> 
> Ok.
> 
> Another idea: if cond_resched() was a macro and __might_sleep() was
> called inside, the given __FILE__ __LINE__ would be much more useful.
> 
> Only the backtraces would be useful in the current state, __FILE__
> and __LINE__ point to sched.h, which is not exactly what is needed,
> right?

Right. There's some CONFIG_PREEMPT_BKL clutter in sched.h but I think we
could largely fold might_sleep() and cond_resched().

Ingo?

