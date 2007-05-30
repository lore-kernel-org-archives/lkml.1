Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbXE3MdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbXE3MdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXE3MdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:33:07 -0400
Received: from mail.screens.ru ([213.234.233.54]:51409 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbXE3MdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:33:06 -0400
Date: Wed, 30 May 2007 16:33:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sending signals to a kernel thread, broken in 2.6.22
Message-ID: <20070530123315.GA927@tv-sign.ru>
References: <20070530112234.GA846@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530112234.GA846@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Oleg Nesterov wrote:
>
> Alan Stern wrote:
> >
> > The g_file_storage driver uses a kernel thread and communicates with
> > that thread in part by means of signals.  It also relies on the thread
> > receiving signals from userspace as an indication that the thread
> > should terminate.
> >
> > This was all working in 2.6.21, but as of 2.6.22-rc3 the signal
> > delivery mechanism (entirely within the kernel!) is no longer
> > functional.
> 
> I guess you mean drivers/usb/gadget/file_storage.c
> 
> 	fsg_main_thread:
> 		
> 		siginitsetinv(&fsg->thread_signal_mask, SIGTERM | ...);
> 		sigprocmask(SIG_SETMASK, &fsg->thread_signal_mask, NULL);
> 
> Yes?
> 
> Please look at
> 
> 	change kernel threads to ignore signals instead of blocking them
> 	commit: 10ab825bdef8df510f99c703a5a2d9b13a4e31a5
> 
> I think you can convert the code above to use allow_signal().

something like untested/uncompiled patch below, what do you think?

Oleg.

--- u/drivers/usb/gadget/file_storage.c~	2007-05-30 16:24:19.000000000 +0400
+++ u/drivers/usb/gadget/file_storage.c	2007-05-30 16:29:21.000000000 +0400
@@ -686,7 +686,6 @@ struct fsg_dev {
 	int			thread_wakeup_needed;
 	struct completion	thread_notifier;
 	struct task_struct	*thread_task;
-	sigset_t		thread_signal_mask;
 
 	int			cmnd_size;
 	u8			cmnd[MAX_COMMAND_SIZE];
@@ -3277,8 +3276,7 @@ static void handle_exception(struct fsg_
 	/* Clear the existing signals.  Anything but SIGUSR1 is converted
 	 * into a high-priority EXIT exception. */
 	for (;;) {
-		sig = dequeue_signal_lock(current, &fsg->thread_signal_mask,
-				&info);
+		sig = dequeue_signal_lock(current, &current->blocked, &info);
 		if (!sig)
 			break;
 		if (sig != SIGUSR1) {
@@ -3431,10 +3429,10 @@ static int fsg_main_thread(void *fsg_)
 
 	/* Allow the thread to be killed by a signal, but set the signal mask
 	 * to block everything but INT, TERM, KILL, and USR1. */
-	siginitsetinv(&fsg->thread_signal_mask, sigmask(SIGINT) |
-			sigmask(SIGTERM) | sigmask(SIGKILL) |
-			sigmask(SIGUSR1));
-	sigprocmask(SIG_SETMASK, &fsg->thread_signal_mask, NULL);
+	allow_signal(SIGINT);
+	allow_signal(SIGTERM);
+	allow_signal(SIGKILL);
+	allow_signal(SIGUSR1);
 
 	/* Arrange for userspace references to be interpreted as kernel
 	 * pointers.  That way we can pass a kernel pointer to a routine

