Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbYJBFBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbYJBFBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYJBFBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:01:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYJBFBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:01:37 -0400
Date: Thu, 2 Oct 2008 01:01:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 3/5] genirq: add threaded interrupt handler support
In-Reply-To: <20081001223301.999771125@linutronix.de>
Message-ID: <alpine.DEB.1.10.0810020058020.11373@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de> <20081001223301.999771125@linutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Oct 2008, Thomas Gleixner wrote:
>  #define irqreturn_t	enum irqreturn
> Index: linux-2.6-tip/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/handle.c
> +++ linux-2.6-tip/kernel/irq/handle.c
> @@ -143,13 +143,34 @@ irqreturn_t handle_IRQ_event(unsigned in
>  			ret = IRQ_NEEDS_HANDLING;
>  
>  		switch (ret) {
> -		default:
> +		case IRQ_NEEDS_HANDLING:
> +			if (!(action->flags & IRQF_THREADED)) {
> +				ret = action->handler(irq, action->dev_id);
> +				if (ret == IRQ_HANDLED)
> +					status |= action->flags;
> +				break;
> +			}
> +			/*
> +			 * Warn once when a quick check handler asked
> +			 * for invoking the threaded (main) handler
> +			 * directly
> +			 */
> +			WARN(!(action->flags & IRQF_WARNED_THREADED),
> +			     "IRQ %d requested to run threaded handler "
> +			     "in hard interrupt context\n", irq);
> +			set_bit(IRQF_WARNED_THREADED, &action->flags);

Do you purposely fall through to the next case statement here?
If so, could you please add a comment.

			/* fall through */

or something similar so we know it's not a bug.

> +
> +		case IRQ_WAKE_THREAD:
> +			set_bit(IRQF_RUNTHREAD, &action->flags);
> +			wake_up_process(action->thread);
> +			/*
> +			 * Set it to handled so the spurious check
> +			 * does not trigger.
> +			 */
> +			ret = IRQ_HANDLED;
>  			break;
>  
> -		case IRQ_NEEDS_HANDLING:
> -			ret = action->handler(irq, action->dev_id);
> -			if (ret == IRQ_HANDLED)
> -				status |= action->flags;
> +		default:
>  			break;
>  		}
>  		retval |= ret;


-- Steve

