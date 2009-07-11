Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZGKICu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZGKICu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZGKICN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:02:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56605 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbZGKICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:02:11 -0400
Date: Sat, 11 Jul 2009 10:01:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Turner <pjt@google.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Bug in SCHED_IDLE interaction with group scheduling?
Message-ID: <20090711080154.GA13792@elte.hu>
References: <alpine.DEB.1.00.0907101649570.29914@kitami.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0907101649570.29914@kitami.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Turner <pjt@google.com> wrote:

> Hi Peter,
> 
> It seems like there's an assumption in the sched_idle policy check in 
> place_entity that the sched_entity we are looking at belongs to a task?
> 
> - Paul
> 
> --
> 
> sched: bug in SCHED_IDLE interaction with group scheduling
> 
> One of the isolation modifications for SCHED_IDLE is the 
> unitization of sleeper credit.  However the check for this assumes 
> that the sched_entity we're placing always belongs to a task.
> 
> This is potentially not true with group scheduling and leaves us 
> rummaging randomly when we try to pull the policy.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  kernel/sched_fair.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index ba7fd6e..7c248dc 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -687,7 +687,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  			 * all of which have the same weight.
>  			 */
>  			if (sched_feat(NORMALIZED_SLEEPER) &&
> -					task_of(se)->policy != SCHED_IDLE)
> +					(!entity_is_task(se) ||
> +					 task_of(se)->policy != SCHED_IDLE))
>  				thresh = calc_delta_fair(thresh, se);

Ah, nice catch!

( Sidenote: we keep having these subtle bugs where we call 
  task_of(se) on a non-task entity - it's been the fifth such 
  incident or so. Perhaps we should add an active debug check to 
  task_of(), in the case of CONFIG_SCHED_DEBUG=y. )

	Ingo
