Return-Path: <linux-kernel-owner+w=401wt.eu-S965526AbXCLKuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbXCLKuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXCLKuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:50:16 -0400
Received: from www.osadl.org ([213.239.205.134]:53532 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965526AbXCLKuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:50:15 -0400
Subject: Re: [patch] futex: PI state locking fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>
In-Reply-To: <20070312091342.GA27425@elte.hu>
References: <20070312091342.GA27425@elte.hu>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 10:28:28 +0100
Message-Id: <1173691708.13341.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 10:13 +0100, Ingo Molnar wrote:
> Subject: [patch] futex: PI state locking fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> testing of -rt by IBM uncovered a locking bug in wake_futex_pi(): the PI 
> state needs to be locked before we access it.
> 
> this patch has been tested in -rt. Must-have for v2.6.21.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> --
>  kernel/futex.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux/kernel/futex.c
> ===================================================================
> --- linux.orig/kernel/futex.c
> +++ linux/kernel/futex.c
> @@ -566,6 +566,7 @@ static int wake_futex_pi(u32 __user *uad
>  	if (!pi_state)
>  		return -EINVAL;
>  
> +	spin_lock(&pi_state->pi_mutex.wait_lock);
>  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
>  
>  	/*
> @@ -605,6 +606,7 @@ static int wake_futex_pi(u32 __user *uad
>  	pi_state->owner = new_owner;
>  	spin_unlock_irq(&new_owner->pi_lock);
>  
> +	spin_unlock(&pi_state->pi_mutex.wait_lock);
>  	rt_mutex_unlock(&pi_state->pi_mutex);
>  
>  	return 0;

