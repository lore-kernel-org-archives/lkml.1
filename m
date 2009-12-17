Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbZLQPB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbZLQPB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbZLQPB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:01:26 -0500
Received: from mail2.shareable.org ([80.68.89.115]:52109 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbZLQPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:01:25 -0500
Date: Thu, 17 Dec 2009 15:01:20 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217150120.GD24967@shareable.org>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> Use the new unreachable() macro instead of for(;;);
>  	*(int *)0 = 0;
>  
>  	/* Avoid "noreturn function does return" */
> -	for (;;);
> +	unreachable();

Will GCC-4.5 remove ("optimise away") the *(int *)0 = 0 because it
knows the branch of the code leading to unreachable can never be reached?

If GCC-4.5 does not, are you sure a future version of GCC will never
remove it?  In other words, is __builtin_unreachable() _defined_ in
such a way that it cannot remove the previous assignment?

We have seen problems with GCC optimising away important tests for
NULL pointers in the kernel, due to similar propagation of "impossible
to occur" conditions, so it's worth checking with GCC people what the
effect of this one would be.

In C, there is a general theoretical problem with back-propagation of
optimisations from code with undefined behaviour.  In the case of
__builtin_unreachable(), it would depend on all sorts of unclearly
defined semantics whether it can remove a preceding *(int *)0 = 0.

I'd strongly suggest asking on the GCC list.  (I'd have mentioned this
earlier, if I'd known about the patch for other architectures).

The documentation for __builtin_unreachable() only says the program is
undefined if control flow reaches it.  In other words, it does not say
what effect it can have on previous instructions, and I think it's
quite likely that it has not been analysed in a case like this.

One thing that would give me a lot more confidence, because the GCC
documentation does mention asm(), is this:

>       *(int *)0 = 0;
>       /* Ensure unreachableness optimisations cannot propagate back. *I/
>       __asm__ volatile("");
>       /* Avoid "noreturn function does return" */
>       unreachable();

-- Jamie
