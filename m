Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbZE0Sfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbZE0Sfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbZE0Sfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:35:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34536 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105AbZE0Sfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:35:46 -0400
Date: Wed, 27 May 2009 20:31:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090527183109.GA30574@redhat.com>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wkjobbm.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Andi Kleen wrote:
>
> When a signal happens during core dump the core dump to a pipe
> can fail, because the write returns short, but the ELF core dumpers
> cannot handle that.
>
> There's no reason to handle signals during core dumping, so just
> block them all.

Actually, I think there is a strong reason to handle signals during
core dumping. The coredump can take a lot of time/resources, not good
it looks like unkillable procees to users.

Please look at

	killable/interruptible coredumps
	http://marc.info/?l=linux-kernel&m=121665710711931

at least, I think SIGKILL should terminate core dumping.

> Open issue: ELF puts blocked signals into the core dump and
> that will be always fully blocked now.  Need to save it somewhere?
>
> --- linux-2.6.30-rc5-ak.orig/fs/exec.c	2009-05-14 11:46:24.000000000 +0200
> +++ linux-2.6.30-rc5-ak/fs/exec.c	2009-05-26 22:22:12.000000000 +0200
> @@ -1760,6 +1760,12 @@
>  		goto fail;
>  	}
>
> +	/* block all signals */
> +	spin_lock_irq(&current->sighand->siglock);
> +	sigfillset(&current->blocked);
> +	/* No recalc sigpending */
> +	spin_unlock_irq(&current->sighand->siglock);

Perhaps it makes sense to do

	--- a/kernel/signal.c
	+++ b/kernel/signal.c
	@@ -644,6 +644,7 @@ static int prepare_signal(int sig, struc
			/*
			 * The process is in the middle of dying, nothing to do.
			 */
	+		 return 0;
		} else if (sig_kernel_stop(sig)) {
			/*
			 * This is a stop signal.  Remove SIGCONT from all queues.

instead, this was discussed before. This way the exiting/coredumping
task ignores all signals, and we cab simplify complete_signal() a bit.


This all needs more discussion, but imho for now something like
Paul's patch http://marc.info/?l=linux-kernel&m=124340506200729
is the best workaround. Note that we have the same dump_write()
in binfmt_elf.c and binfmt_aout.c, perhaps it makes sense to
create coredump_file_write() helper in fs/exec.c.

Oleg.

