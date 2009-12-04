Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZLDJyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZLDJyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZLDJyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:54:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41157 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbZLDJyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:54:12 -0500
Date: Fri, 4 Dec 2009 10:54:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] sched: fix GENTLE_FAIR_SLEEPERS dependency
Message-ID: <20091204095408.GA26118@elte.hu>
References: <4B18D66E.8020905@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B18D66E.8020905@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Jayaraman <sjayaraman@suse.de> wrote:

> The newly introduced GENTLE_FAIR_SLEEPERS does not seem to have any
> effect without FAIR_SLEEPERS. Fix sysctl.sched_features to reflect
> this. Without this change, a user who sets GENTLE_FAIR_SLEEPERS
> without FAIR_SLEEPERS would assume gentle sleeper fairness which
> is not guaranteed.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -761,10 +761,22 @@ sched_feat_write(struct file *filp, cons
>  		int len = strlen(sched_feat_names[i]);
>  
>  		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
> -			if (neg)
> +			if (neg) {
>  				sysctl_sched_features &= ~(1UL << i);
> -			else
> +				/*
> +				 * GENTLE_FAIR_SLEEPERS have no effect without
> +				 * FAIR_SLEEPERS.
> +				 */
> +				if (strncmp(cmp, "FAIR_SLEEPERS",
> +					    strlen("FAIR_SLEEPERS")) == 0)
> +					sysctl_sched_features &= ~(1UL << i+1);
> +			} else {
>  				sysctl_sched_features |= (1UL << i);
> +				if (strncmp(cmp, "GENTLE_FAIR_SLEEPERS",
> +					    strlen("GENTLE_FAIR_SLEEPERS"))
> +						== 0)
> +					sysctl_sched_features |= (1UL << i-1);
> +			}
>  			break;
>  		}
>  	}

There's a lot of other dependencies between scheduler features so it's 
possible to change it without it having an effect on the scheduler. 

sched_features is really a development/debugging facility, you have to 
know what you are doing.

Might be worth adding a comment to the feature definition place itself 
in the source - explain what it does and how it makes sense (and how it 
doesnt).

	Ingo
