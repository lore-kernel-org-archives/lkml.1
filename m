Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbZFOQof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbZFOQof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbZFOQoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:44:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762889AbZFOQoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:44:22 -0400
Date: Mon, 15 Jun 2009 18:39:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] Use copy_wait_opts_to_user() in do_wait()
Message-ID: <20090615163923.GA7425@redhat.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com> <1242048349-2766-4-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242048349-2766-4-git-send-email-v.mayatskih@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn. I am sorry for the huge delay. Finally I have read this series
carefully.

On 05/11, Vitaly Mayatskikh wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1600,8 +1600,6 @@ end:
>  	__set_current_state(TASK_RUNNING);
>  	remove_wait_queue(&current->signal->wait_chldexit,&wait);
>  	if (wo->wo_info) {
> -		struct siginfo __user *infop = wo->wo_info;
> -
>  		if (retval > 0)
>  			retval = 0;
>  		else {
> @@ -1610,18 +1608,7 @@ end:
>  			 * we would set so the user can easily tell the
>  			 * difference.
>  			 */
> -			if (!retval)
> -				retval = put_user(0, &infop->si_signo);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_errno);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_code);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_pid);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_uid);
> -			if (!retval)
> -				retval = put_user(0, &infop->si_status);
> +			retval = copy_wait_opts_to_user(wo, 0, 0, 0, 0, 0, 0);

This looks wrong.

copy_wait_opts_to_user()->getrusage() will OOPS if ->wo_rusage != NULL,
because we pass p == NULL.

Easy to fix, but I am not sure what is the most clean fix...

Oleg.

