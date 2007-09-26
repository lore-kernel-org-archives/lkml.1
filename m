Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbXIZUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbXIZUsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbXIZUsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:48:06 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:44642 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbXIZUsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:48:05 -0400
Message-ID: <46FAC57A.3090309@tiscali.nl>
Date: Wed, 26 Sep 2007 22:47:54 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@yahoo.fr>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] taskstats: fix stats->ac_exitcode to work on threads
 and	use group_exit_code
References: <20070926162800.29434.67786.stgit@cheypa.inria.fr> <20070926162831.29434.29622.stgit@cheypa.inria.fr>
In-Reply-To: <20070926162831.29434.29622.stgit@cheypa.inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain wrote:

[...]

> @@ -65,13 +65,15 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
>  void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *tsk,
>  			    bool tg_stats)
>  {
> +	int group_exit_code;
> +
>  	fill_wall_times(stats, tsk);
>  
> -	if (thread_group_leader(tsk)) {
> -		stats->ac_exitcode = tsk->exit_code;
> -		if (tsk->flags & PF_FORKNOEXEC)
> -			stats->ac_flag |= AFORK;
> -	}
> +	if (thread_group_leader(tsk) && ((tsk->flags & PF_FORKNOEXEC)))

	if (thread_group_leader(tsk) && (tsk->flags & PF_FORKNOEXEC))

> +		stats->ac_flag |= AFORK;
> +
> +	group_exit_code = tg_stats ? tsk->signal->group_exit_code : 0;
> +	stats->ac_exitcode = group_exit_code ? : tsk->exit_code;

Isn't this just confusing? why not

	if (tg_stats) {
		group_exit_code = tsk->signal->group_exit_code;
		stats->ac_exitcode = group_exit_code;
		
	} else {
		group_exit_code = 0;
		stats->ac_exitcode = tsk->exit_code;
	}
