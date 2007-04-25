Return-Path: <linux-kernel-owner+w=401wt.eu-S1423249AbXDYHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423249AbXDYHRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423250AbXDYHRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:17:30 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34127 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423249AbXDYHR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:17:29 -0400
Date: Wed, 25 Apr 2007 09:17:24 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Shani Moideen <shani.moideen@wipro.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [PATCH]:Replacing current->state with set_current_state in
 kernel/signal.c
Message-Id: <20070425091724.6f2c212b.dada1@cosmosbay.com>
In-Reply-To: <1177483138.27118.25.camel@shani-win>
References: <1177483138.27118.25.camel@shani-win>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 12:08:58 +0530
Shani Moideen <shani.moideen@wipro.com> wrote:

> Hi,
> 
> Replacing current->state with set_current_state in kernel/signal.c
> 	

> @@ -2596,7 +2596,7 @@ sys_signal(int sig, __sighandler_t handler)
>  asmlinkage long
>  sys_pause(void)
>  {
> -       current->state = TASK_INTERRUPTIBLE;
> +       set_current_state(TASK_INTERRUPTIBLE);
>         schedule();

Hi Shani

Either you think you corrected a BUG, so please state it clearly in Changelog so that Linus immediatly apply your patch for 2.6.21 :)

Either you dont know the exact semantic of set_current_state() and think it's a cleaner way to set current->state.
It might looks better for you but it's not the *same* thing.

I suggest you carefully study the difference between set_current_state() and __set_current_state(), and submit a new patch, once you feel comfortable with it.

Here is the relevant extract from include/linux/sched.h

/*
 * set_current_state() includes a barrier so that the write of current->state
 * is correctly serialised wrt the caller's subsequent test of whether to
 * actually sleep:
 *
 *      set_current_state(TASK_UNINTERRUPTIBLE);
 *      if (do_i_need_to_sleep())
 *              schedule();
 *
 * If the caller does not need such serialisation then use __set_current_state()
 */
#define __set_current_state(state_value)                        \
        do { current->state = (state_value); } while (0)
#define set_current_state(state_value)          \
        set_mb(current->state, (state_value))


Thank you
