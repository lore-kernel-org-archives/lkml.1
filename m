Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZFAUME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZFAUME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZFAULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:11:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58512 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZFAULz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:11:55 -0400
Date: Mon, 1 Jun 2009 22:07:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH? tracehook_report_clone: fix false positives
Message-ID: <20090601200723.GA22204@redhat.com>
References: <20090528113601.GA18725@redhat.com> <20090528114100.GA18744@redhat.com> <20090528212418.2F605FC2BD@magilla.sf.frob.com> <20090529122411.GC19812@redhat.com> <20090530185212.GA10677@redhat.com> <20090601002226.480CEFC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601002226.480CEFC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Roland McGrath wrote:
>
> ACK on the 2.6.30 patch attached.

Thanks, I am adding your Acked-by to tha patch.

> > So, I am going to send the patch below. But this leads to another question:
> > should not we move these sigaddset() + set_tsk_thread_flag() into
> > ptrace_init_task() ?
>
> It might make sense to consolidate them.  But note that ptrace_attach()
> uses send_sig_info().  With SEND_SIG_FORCED, this does almost nothing more
> than sigaddset() (i.e. no queue entry).  But it does do prepare_signal(),
> which will clear any pending SIGCONTs.  It's possible that something in
> userland manages to rely on that behavior for the asynchronous attach case
> (unrelated to startup-time races).  It wouldn't hurt for the creation-time
> case to use send_sig_info() too, though it would go through a bunch more
> code to do nothing effectual but sigaddset() in the end.

Oh, I never thought about attach && SIGCONT interaction...

But, tracehook_report_clone() has the same problems?

And if we move sigaddset to ptrace_task_init(), we should not worry about
SIGCONT? Without CLONE_THREAD the new task is not visible to user-space yet.
Even if we clone a sub-thread, ptrace_init_task() runs under ->siglock.
If SIGCONT is already pending, copy_process() won't succeed.

Or do you mean something else?

Oleg.

