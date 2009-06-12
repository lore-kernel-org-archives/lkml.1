Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbZFLHK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbZFLHK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZFLHKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:10:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbZFLHKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:10:21 -0400
Subject: Re: [PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with
 __exit_signal()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090612084910.1b63b0af@dhcp-lab-109.englab.brq.redhat.com>
References: <20090612084910.1b63b0af@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 09:09:58 +0200
Message-Id: <1244790598.6691.956.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 08:49 +0200, Stanislaw Gruszka wrote:
> Protect thread_group_cputime() call by siglock, to avoid possible (but
> to be honest - very improbable) double times accounting of exiting task.
> This is revert of commit 2b5fe6de58276d0b5a7c884d5dbfc300ca47db78
> "thread_group_cputime: move a couple of callsites outside of ->siglock",
> but implementation of thread_group_cputime() was different then.

Would be nice to have a description of exactly how you'd end up
accounting twice (and thus how this patch fixes it).

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  kernel/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index e7998cf..0805d08 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -913,8 +913,8 @@ void do_sys_times(struct tms *tms)
>  	struct task_cputime cputime;
>  	cputime_t cutime, cstime;
>  
> -	thread_group_cputime(current, &cputime);
>  	spin_lock_irq(&current->sighand->siglock);
> +	thread_group_cputime(current, &cputime);
>  	cutime = current->signal->cutime;
>  	cstime = current->signal->cstime;
>  	spin_unlock_irq(&current->sighand->siglock);

