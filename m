Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbXFASgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbXFASgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761227AbXFASgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:36:39 -0400
Received: from mail.screens.ru ([213.234.233.54]:52728 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760441AbXFASgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:36:38 -0400
Date: Fri, 1 Jun 2007 22:36:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: Mark Hounschell <markh@compro.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
Message-ID: <20070601183642.GA92@tv-sign.ru>
References: <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net> <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru> <466028DB.3060509@compro.net> <20070601151605.GA108@tv-sign.ru> <4660534E.6050903@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4660534E.6050903@cfl.rr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Mark Hounschell wrote:
>
> Oleg Nesterov wrote:
> > 
> > Could you apply the trivial patch below, and change the i/o thread to do
> > 
> > 		prctl(1234);				// hangs ???
> > 		printf(something);
> > 		ioctl(Q->DevSpec1, FDSETPRM, &medprm);	// this hangs
> > 
> > to see if prctl() hangs or not? This way we can narrow the problem.
> > (of course, you can just kill the above ioctl() if this is possible).
> > 
> > Thanks!
> > 
> > Oleg.
> > 
> > --- OLD/kernel/sys.c~	2007-04-03 13:05:02.000000000 +0400
> > +++ OLD/kernel/sys.c	2007-06-01 18:56:22.000000000 +0400
> > @@ -2147,6 +2147,11 @@ asmlinkage long sys_prctl(int option, un
> >  {
> >  	long error;
> >  
> > +	if (option == 1234) {
> > +		flush_scheduled_work();
> > +		return 0;
> > +	}
> > +
> >  	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
> >  	if (error)
> >  		return error;
> > 
> > -
> 
> 
> Ok the prctl never returned. I just replaced the ioctl with it and added
> a printf before and after. I only get the one before. The thread is hung
> at this point just as if I'd done the ioctl?

Thanks. So we can rule out floppy.c. flush_scheduled_work/flush_workqueue
is broken by this RT application. Imho, this is not the kernel problem.

Now I am very sure that the initial suspect was correct: cpu starvation.
I can cook a debug patch to be 100% sure tomorrow, which kernel version is
most convenient to you?

Oleg.

