Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYFTOL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYFTOL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYFTOLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:11:48 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53992 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYFTOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:11:48 -0400
Date: Fri, 20 Jun 2008 18:14:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, Eli Cohen <eli@dev.mellanox.co.il>,
       general@lists.openfabrics.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: wait_for_completion_timeout() spurious failure under heavy load?
Message-ID: <20080620141400.GA411@tv-sign.ru>
References: <ada63s5w088.fsf@cisco.com> <485B50F1.2020802@gmail.com> <20080620112042.GE7439@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620112042.GE7439@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Ingo Molnar wrote:
>
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4405,6 +4405,16 @@ do_wait_for_common(struct completion *x, long timeout, int state)
>  			spin_unlock_irq(&x->wait.lock);
>  			timeout = schedule_timeout(timeout);
>  			spin_lock_irq(&x->wait.lock);
> +
> +			/*
> +			 * If the completion has arrived meanwhile
> +			 * then return 1 jiffy time left:
> +			 */
> +			if (x->done && !timeout) {
> +				timeout = 1;
> +				break;
> +			}
> +
>  			if (!timeout) {
>  				__remove_wait_queue(&x->wait, &wait);
>  				return timeout;

This is the real nitpick, but I wonder what is the right behaviour
of wait_for_completion_timeout(x, 0) when x->done != 0. Perhaps we
can return 1 in that case too, just for the consistency?

IOW, how about the patch below? this also makes the code a bit
simpler because we factor out __remove_wait_queue().

Oleg.

--- kernel/sched.c
+++ kernel/sched.c
@@ -4746,15 +4746,13 @@ do_wait_for_common(struct completion *x,
 			spin_unlock_irq(&x->wait.lock);
 			timeout = schedule_timeout(timeout);
 			spin_lock_irq(&x->wait.lock);
-			if (!timeout) {
-				__remove_wait_queue(&x->wait, &wait);
-				return timeout;
-			}
-		} while (!x->done);
+		} while (!x->done && timeout);
 		__remove_wait_queue(&x->wait, &wait);
+		if (!x->done)
+			return 0;
 	}
 	x->done--;
-	return timeout;
+	return timeout ?: 1;
 }
 
 static long __sched

