Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZBDToV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZBDToV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZBDToI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:44:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbZBDToF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:44:05 -0500
Date: Wed, 4 Feb 2009 20:43:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2 v3] softlockup: check all tasks in hung_task
Message-ID: <20090204194339.GB22608@elte.hu>
References: <20090203122346.GE19979@elte.hu> <20090203205609.GA9581@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203205609.GA9581@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@google.com> wrote:

> +static void check_hung_rcu_refresh(struct task_struct *g, struct task_struct *t)

please rename this to rcu_lock_break().

>  	do_each_thread(g, t) {
> -		if (!--max_count)
> -			goto unlock;
> +		if (!--max_count) {
> +			max_count = sysctl_hung_task_check_count;
> +			check_hung_rcu_refresh(g, t);
> +			/* Exit if t or g was unhashed during refresh. */
> +			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> +				goto unlock;

Thinking about it some more, i think a slightly different approach (that has 
the same end effect):

 - Add a "static const int check_count_batching = 1024;" variable that adds 
   some natural batching - and initialize max_count to that value. There's 
   little point to make that batching configurable.

 - Leave sysctl_hung_task_check_count present but change its default to 
   something really large like MAX_PID.

Thanks,

	Ingo
