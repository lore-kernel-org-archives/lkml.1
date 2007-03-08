Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbXCHQip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbXCHQip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbXCHQip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:38:45 -0500
Received: from mail.screens.ru ([213.234.233.54]:54300 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXCHQio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:38:44 -0500
Date: Thu, 8 Mar 2007 19:38:44 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel threads
Message-ID: <20070308163844.GA6638@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
> > On Tue, 6 Mar 2007 11:03:48 -0500 "linux-os \(Dick Johnson\)" <linux-os@analogic.com> wrote:
> >
> > In linux-2.6.16.24, there is a problem with kernel threads
> > and the aic79xx.c driver.
> >
> > When nash is executing /initrd/linuxrc in the initial RAM disk
> > during boot, it will be installing drivers. One driver, aic79xx.c
> > creates some kernel threads that will exit after the initialization
> > procedure. Actually the number of tasks depends upon the number
> > of disks found as the driver spawns these tasks so initialization
> > can occur in the background. The kernel tasks have been 'parented'
> > to init. This may be fine for the real init, but nash and other
> > shells receive the SIGCHLD signal and think that the fork()/exec()
> > they have executed is complete. This makes nash insert drivers
> > when the needed previous ones have not yet initialized. Also, when
> > booting a shell, the signals from the exiting kernel tasks confuse
> > it.
>
> ug.  I've always disliked the kernel's dependence upon init to reap exitted
> kernel threads.  It Just Seems Wrong.

Yes. It is ugly to kick init to reap the kernel thread. I was going to
do this change a long ago, but I don't have time to do even a minimal
testing now.

reparent_to_init() expects that thread_group_empty() == true anyway,
we can set ->exit_signal = -1 and make this thread invisible to init.

Roland, what do you think?

Oleg.

--- WQ/kernel/exit.c~rti	2007-02-18 22:56:49.000000000 +0300
+++ WQ/kernel/exit.c	2007-03-08 19:26:39.000000000 +0300
@@ -276,8 +276,8 @@ static void reparent_to_init(void)
 	current->parent = child_reaper(current);
 	add_parent(current);
 
-	/* Set the exit signal to SIGCHLD so we signal init on exit */
-	current->exit_signal = SIGCHLD;
+	/* make the task autoreap */
+	current->exit_signal = -1;
 
 	if (!has_rt_policy(current) && (task_nice(current) < 0))
 		set_user_nice(current, 0);

