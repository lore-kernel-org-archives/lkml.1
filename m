Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYJBTWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYJBTWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYJBTWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:22:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42511 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbYJBTWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:22:44 -0400
Date: Thu, 2 Oct 2008 21:22:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002192223.GP19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <87fxnfpjqj.fsf@basil.nowhere.org> <20081002075511.GX19428@kernel.dk> <20081002093326.GF30001@disturbed> <20081002094537.GA19428@kernel.dk> <20081002120408.21585949@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002120408.21585949@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Arjan van de Ven wrote:
> On Thu, 2 Oct 2008 11:45:37 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > The RT folk were happy with the idea of journal I/O using the
> > > highest non-RT priority for the journal, but I never got around
> > > to testing that out as I had a bunnch of other stuff to fix at
> > > the time.
> > 
> > That's a good idea, just bump the priority a little bit. Arjan, did
> > you test that out? I'd suggest just trying prio level 0 and still
> > using best-effort scheduling. Probably still need the sync marking,
> > would be interesting to experiment with though.
> > 
> 
> ok 0 works ok enough in quick testing as well...... updated patch below
> 
> From df64cc4e2ab0c102bbac609dd948958a6f804fd3 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 1 Oct 2008 19:58:18 -0700
> Subject: [PATCH] Give kjournald a higher io priority
> 
> With latencytop, I noticed that the (in memory) file updates during my
> workload (reading mail) had latencies of 6 seconds or longer; this is
> obviously not so nice behavior. Other EXT3 journal related operations had
> similar or even longer latencies.
> 
> Digging into this a bit more, it appears to be an interaction between EXT3
> and CFQ in that CFQ tries to be fair to everyone, including kjournald.
> However, in reality, kjournald is "special" in that it does a lot of journal
> work and effectively this leads to a twisted kind of "mass priority
> inversion" type of behavior.
> 
> The good news is that CFQ already has the infrastructure to make certain
> processes special... JBD just wasn't using that quite yet.
> 
> The patch below makes kjournald of a slighlty higher priority than normal
> applications, reducing these latencies significantly.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  fs/ioprio.c            |    3 ++-
>  fs/jbd/journal.c       |   12 ++++++++++++
>  include/linux/ioprio.h |    2 ++
>  3 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ioprio.c b/fs/ioprio.c
> index da3cc46..3bd95dc 100644
> --- a/fs/ioprio.c
> +++ b/fs/ioprio.c
> @@ -27,7 +27,7 @@
>  #include <linux/security.h>
>  #include <linux/pid_namespace.h>
>  
> -static int set_task_ioprio(struct task_struct *task, int ioprio)
> +int set_task_ioprio(struct task_struct *task, int ioprio)
>  {
>  	int err;
>  	struct io_context *ioc;
> @@ -64,6 +64,7 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
>  	task_unlock(task);
>  	return err;
>  }
> +EXPORT_SYMBOL_GPL(set_task_ioprio);
>  
>  asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
>  {
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index aa7143a..a859a46 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -36,6 +36,7 @@
>  #include <linux/poison.h>
>  #include <linux/proc_fs.h>
>  #include <linux/debugfs.h>
> +#include <linux/ioprio.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
> @@ -131,6 +132,17 @@ static int kjournald(void *arg)
>  			journal->j_commit_interval / HZ);
>  
>  	/*
> +	 * kjournald is the process on which most other processes depend on
> +	 * for doing the filesystem portion of their IO. As such, there exists
> +	 * the equivalent of a priority inversion situation, where kjournald
> +	 * would get less priority as it should.
> +	 *
> +	 * For this reason we set to "medium real time priority", which is higher
> +	 * than regular tasks, but not infinitely powerful.
> +	 */
> +	set_task_ioprio(current, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0));
> +
> +	/*
>  	 * And now, wait forever for commit wakeup events.
>  	 */
>  	spin_lock(&journal->j_state_lock);
> diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
> index f98a656..76dad48 100644
> --- a/include/linux/ioprio.h
> +++ b/include/linux/ioprio.h
> @@ -86,4 +86,6 @@ static inline int task_nice_ioclass(struct task_struct *task)
>   */
>  extern int ioprio_best(unsigned short aprio, unsigned short bprio);
>  
> +extern int set_task_ioprio(struct task_struct *task, int ioprio);
> +
>  #endif
> -- 
> 1.5.5.1

Can we agree on this patch?

-- 
Jens Axboe

