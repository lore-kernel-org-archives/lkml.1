Return-Path: <linux-kernel-owner+w=401wt.eu-S1763737AbZFOQsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763737AbZFOQsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbZFOQsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:48:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbZFOQsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:48:18 -0400
Date: Mon, 15 Jun 2009 18:43:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Use copy_wait_opts_to_user() in wait_task_zombie()
Message-ID: <20090615164324.GB7425@redhat.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com> <1242048349-2766-5-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242048349-2766-5-git-send-email-v.mayatskih@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Vitaly Mayatskikh wrote:
>
> @@ -1267,36 +1265,21 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
>  	 */
>  	read_unlock(&tasklist_lock);
>
> -	retval = wo->wo_rusage
> -		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
>  	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
>  		? p->signal->group_exit_code : p->exit_code;
> -	if (!retval && wo->wo_stat)
> +	if (wo->wo_stat)
>  		retval = put_user(status, wo->wo_stat);

We don't check retval, and then later

> [...snip...]
> +	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);

we overwrite it.

This needs a fix.

Oleg.

