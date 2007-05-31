Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbXEaTW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbXEaTW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbXEaTWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:22:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:36192 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544AbXEaTWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:22:50 -0400
Date: Thu, 31 May 2007 23:22:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark Hounschell <markh@compro.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: floppy.c soft lockup
Message-ID: <20070531192256.GA88@tv-sign.ru>
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net> <20070531170604.GA79@tv-sign.ru> <465F179D.6080203@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465F179D.6080203@compro.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Mark Hounschell wrote:
>
> Oleg Nesterov wrote:
> > On 05/31, Mark Hounschell wrote:
> >>
> >> Basically the main RT-process (which is a CPU bound process on processor-2) signals a
> >> thread to do some I/O. That RT-thread (running on the other processor) does a simple 
> > 
> > If the main RT-process monopolizes processor-2, flush_workqueue() (or cancel_work_sync())
> > can hang of course, we can do nothing.
> > 
> >> ioctl(Q->DevSpec1, FDSETPRM, &medprm)
> >>
> >> and there is no return from the call. That thread is hung.
> > 
> > What happens if you kill the main RT-process?
> > 
> 
> When I kill the main process all its threads also go away. Including the floppy thread.
> Nothing notable happens with this kernel.

Aha, I missed the word "thread", this is the single process.

Still, this means that flush_workqueue() completes when other sub-threads go away,
otherwise the thread doing ioctl() couldn't exit.

Thank you very much.

So, the main question is: is it possible that one of RT processes/threads pins itself
to some CPU and eats 100% cpu power?

>                                            On previous (2.6.18) I would get a dump
> from the floppy driver in the syslog when I killed the process.

Could you send me this output? just in case...

> > --- OLD/drivers/block/floppy.c~	2007-04-03 13:04:58.000000000 +0400
> > +++ OLD/drivers/block/floppy.c	2007-05-31 20:50:18.000000000 +0400
> > @@ -862,6 +862,8 @@ static void set_fdc(int drive)
> >  		FDCS->reset = 1;
> >  }
> >  
> > +static DECLARE_WORK(floppy_work, NULL);
> > +
> >  /* locks the driver */
> >  static int _lock_fdc(int drive, int interruptible, int line)
> >  {
> > @@ -893,7 +895,7 @@ static int _lock_fdc(int drive, int inte
> >  		set_current_state(TASK_RUNNING);
> >  		remove_wait_queue(&fdc_wait, &wait);
> >  
> > -		flush_scheduled_work();
> > +		cancel_work_sync(&floppy_work);
> >  	}
> >  	command_status = FD_COMMAND_NONE;
> >  
> > @@ -992,8 +994,6 @@ static void empty(void)
> >  {
> >  }
> >  
> > -static DECLARE_WORK(floppy_work, NULL);
> > -
> >  static void schedule_bh(void (*handler) (void))
> >  {
> >  	PREPARE_WORK(&floppy_work, (work_func_t)handler);
> > 
> 
> The patch does make it work.

I do not understand floppy.c, absolutely, so I am not sure this patch is correct.

Even if correct, this patch doesn't solve this problem (if we really understand
what's going on). cancel_work_sync() may still hang if floppy_work->func() runs
on the starved CPU. This is unlikely, but possible.

Thanks!

Oleg.

