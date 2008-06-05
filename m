Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbYFEQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbYFEQDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYFEQDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:03:10 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37909 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYFEQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:03:09 -0400
Date: Thu, 5 Jun 2008 20:04:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: TASK_WAKEKILL && /sbin/init (was: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race)
Message-ID: <20080605160450.GA323@tv-sign.ru>
References: <20080604170905.GA10273@tv-sign.ru> <20080604173318.GH3549@parisc-linux.org> <20080605152316.GA257@tv-sign.ru> <20080605154844.GN3549@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605154844.GN3549@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Matthew Wilcox wrote:
>
> On Thu, Jun 05, 2008 at 07:23:16PM +0400, Oleg Nesterov wrote:
> > 
> > If lock_page_killable() fails because the task was killed by SIGKILL or
> > another fatal signal, do_generic_file_read() returns -EIO.
> > 
> > This seems to be OK, because in fact the userspace won't see this error, the
> > task will dequeue SIGKILL and exit.
> > 
> > However, /sbin/init is different, it will dequeue SIGKILL, ignore it, and be
> > confused by this bogus -EIO. Please note that while this bug is not likely,
> > it is _not_ theoretical. It does happen that user-space sends the unhandled
> > fatal signals to init.
> 
> Have you actually tested this?

No I didn't. And I would be happy to be wrong. But,

> I thought it was handled by:
> 
>                 /*
>                  * Global init gets no signals it doesn't want.
>                  */
>                 if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
>                     !signal_group_exit(signal))
>                         continue;
> 
> in get_signal_to_deliver().

This is what I am talking about. The SIGNAL_UNKILLABLE task (init) dequeues
the pending SIGKILL and just ignores it. Then it returns to the user space
with -EIO.

But when we send SIGKILL, the sender wakes up the TASK_KILLABLE task, and
after that fatal_signal_pending() is true. Once again, it is not hard to
fix this problem in kernel/signal.c, but _perhaps_ the change in filemap.c
makes sense anyway.

Oleg.

