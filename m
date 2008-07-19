Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYGSXc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYGSXc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 19:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYGSXcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 19:32:19 -0400
Received: from saeurebad.de ([85.214.36.134]:52368 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbYGSXcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 19:32:18 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: kill mm->core_done
References: <20080715140715.GA25824@tv-sign.ru>
Date: Sun, 20 Jul 2008 01:31:49 +0200
In-Reply-To: <20080715140715.GA25824@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 15 Jul 2008 18:07:15 +0400")
Message-ID: <87d4l9jvru.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Now that we have core_state->dumper list we can use it to wake up the
> sub-threads waiting for the coredump completion.
>
> This uglifies the code and .text grows by 47 bytes, but otoh mm_struct
> lessens by sizeof(struct completion). Also, with this change we can
> decouple exit_mm() from the coredumping code.
>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
>  include/linux/mm_types.h |    4 +---
>  kernel/exit.c            |    8 +++++++-
>  fs/exec.c                |   25 ++++++++++++++++++++++---
>  3 files changed, 30 insertions(+), 7 deletions(-)
>
> --- 26-rc2/include/linux/mm_types.h~5_KILL_CORE_DONE	2008-07-13 18:28:36.000000000 +0400
> +++ 26-rc2/include/linux/mm_types.h	2008-07-15 17:06:58.000000000 +0400
> @@ -229,9 +229,7 @@ struct mm_struct {
>  
>  	unsigned long flags; /* Must use atomic bitops to access the bits */
>  
> -	/* coredumping support */
> -	struct core_state *core_state;
> -	struct completion core_done;
> +	struct core_state *core_state; /* coredumping support */
>  
>  	/* aio bits */
>  	rwlock_t		ioctx_list_lock;	/* aio lock */
> --- 26-rc2/kernel/exit.c~5_KILL_CORE_DONE	2008-07-13 19:58:19.000000000 +0400
> +++ 26-rc2/kernel/exit.c	2008-07-15 17:06:58.000000000 +0400
> @@ -680,7 +680,13 @@ static void exit_mm(struct task_struct *
>  		if (atomic_dec_and_test(&core_state->nr_threads))
>  			complete(&core_state->startup);
>  
> -		wait_for_completion(&mm->core_done);
> +		for (;;) {
> +			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> +			if (!self.task) /* see coredump_finish() */

kernel/exit.c: In function `exit_mm':
kernel/exit.c:686: error: `self' undeclared (first use in this function)
kernel/exit.c:686: error: (Each undeclared identifier is reported only once
kernel/exit.c:686: error: for each function it appears in.)
make[1]: *** [kernel/exit.o] Error 1

	Hannes
