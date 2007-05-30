Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbXE3LWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbXE3LWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXE3LW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:22:27 -0400
Received: from mail.screens.ru ([213.234.233.54]:48969 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXE3LW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:22:26 -0400
Date: Wed, 30 May 2007 15:22:34 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sending signals to a kernel thread, broken in 2.6.22
Message-ID: <20070530112234.GA846@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
>
> The g_file_storage driver uses a kernel thread and communicates with
> that thread in part by means of signals.  It also relies on the thread
> receiving signals from userspace as an indication that the thread
> should terminate.
>
> This was all working in 2.6.21, but as of 2.6.22-rc3 the signal
> delivery mechanism (entirely within the kernel!) is no longer
> functional.
>
> What's the story?  Do I need to do something new and different to get
> signals working again?  Should I avoid using signals entirely?

I guess you mean drivers/usb/gadget/file_storage.c

	fsg_main_thread:
		
		siginitsetinv(&fsg->thread_signal_mask, SIGTERM | ...);
		sigprocmask(SIG_SETMASK, &fsg->thread_signal_mask, NULL);

Yes?

Please look at

	change kernel threads to ignore signals instead of blocking them
	commit: 10ab825bdef8df510f99c703a5a2d9b13a4e31a5

I think you can convert the code above to use allow_signal().


Please note that it is not good to just unblock the signal, SIG_DFL means
that __group_complete_signal() starts doing SIGNAL_GROUP_EXIT things. In
particular, SIGTERM implies sigaddset(SIGKILL).

Oleg.

