Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbXEaRGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbXEaRGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXEaRGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:06:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:36817 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbXEaRGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:06:13 -0400
Date: Thu, 31 May 2007 21:06:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark Hounschell <markh@compro.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: floppy.c soft lockup
Message-ID: <20070531170604.GA79@tv-sign.ru>
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org> <465EDB97.5070908@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465EDB97.5070908@compro.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Mark Hounschell wrote:
>
> Andrew Morton wrote:
> > On Tue, 29 May 2007 13:31:05 -0400 Mark Hounschell <markh@compro.net> wrote:
> > 
> >> Changes in floppy.c from 2.6.17 and 2.6.18 have broken an application I have. I have tracked 
> >> it down to a single line of code. When the following patch is applied to the version in 2.6.18
> >> my application works.
> >>
> >> --- linux-2.6.18/drivers/block/floppy.c 2006-09-19 23:42:06.000000000 -0400
> >> +++ linux-2.6.18-crt/drivers/block/floppy.c     2007-05-29 09:12:20.000000000 -0400
> >> @@ -893,7 +893,6 @@
> >>                 set_current_state(TASK_RUNNING);
> >>                 remove_wait_queue(&fdc_wait, &wait);
> >>
> >> -               flush_scheduled_work();
> >>         }
> >>         command_status = FD_COMMAND_NONE;
> >>
> > Interesting.  I'd expect that the calling process is spinning, with realtime
> > policy and is expecting some other process to do something (ie: run a workqueue).
> > 
> > If you keep the process and irq affinities, and disable the realtime policy
> > does that also prevent the problem?
> > 
> 
> Yes it does.
> 
> > It would be interesting it you could capture a few task traces while it is stuck:
> > echo 1 > /proc/sys/kernel/sysrq then do ALT-SYSRQ-P a bunch of times and ALT-SYSRQ-T,
> > see if you can work out where the CPU is stuck.
> > 
> 
> I've attached the syslog output as a result of doing the above. I can't really make any kind of
> determination from it myself as I don't really knowing what I'm looking at.

Could you show the full output? There are no events/* or process doing ioctl()
in sysrq.txt you attached.

> > ALso, 2.6.22-rc3 might have accidentally fixed this.
> > 
> 
> No. Same thing there.  The traces attached are using 2.6.22-rc3.
> 
> Basically the main RT-process (which is a CPU bound process on processor-2) signals a
> thread to do some I/O. That RT-thread (running on the other processor) does a simple 

If the main RT-process monopolizes processor-2, flush_workqueue() (or cancel_work_sync())
can hang of course, we can do nothing.

> ioctl(Q->DevSpec1, FDSETPRM, &medprm)
> 
> and there is no return from the call. That thread is hung.

What happens if you kill the main RT-process?

Could you try the patch below? Just to see if it makes any difference.

Oleg.

(against 2.6.22-rcX)

--- OLD/drivers/block/floppy.c~	2007-04-03 13:04:58.000000000 +0400
+++ OLD/drivers/block/floppy.c	2007-05-31 20:50:18.000000000 +0400
@@ -862,6 +862,8 @@ static void set_fdc(int drive)
 		FDCS->reset = 1;
 }
 
+static DECLARE_WORK(floppy_work, NULL);
+
 /* locks the driver */
 static int _lock_fdc(int drive, int interruptible, int line)
 {
@@ -893,7 +895,7 @@ static int _lock_fdc(int drive, int inte
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&fdc_wait, &wait);
 
-		flush_scheduled_work();
+		cancel_work_sync(&floppy_work);
 	}
 	command_status = FD_COMMAND_NONE;
 
@@ -992,8 +994,6 @@ static void empty(void)
 {
 }
 
-static DECLARE_WORK(floppy_work, NULL);
-
 static void schedule_bh(void (*handler) (void))
 {
 	PREPARE_WORK(&floppy_work, (work_func_t)handler);

