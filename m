Return-Path: <linux-kernel-owner+w=401wt.eu-S1764355AbZAULNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764355AbZAULNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764156AbZAULNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:13:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53644 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764144AbZAULNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:13:22 -0500
Date: Wed, 21 Jan 2009 12:13:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH] softlockup: remove hung_task_check_count
Message-ID: <20090121111314.GA23469@elte.hu>
References: <20090121014615.GA21018@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121014615.GA21018@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@google.com> wrote:

>  	read_lock(&tasklist_lock);
>  	do_each_thread(g, t) {
> -		if (!--max_count)
> -			goto unlock;
> +		if (!--max_count) {
> +			/*
> +			 * Drop the lock every once in a while and resched if
> +			 * necessary. Don't want to hold the lock too long.
> +			 */
> +			get_task_struct(t);
> +			read_unlock(&tasklist_lock);
> +			max_count = HUNG_TASK_CHECK_COUNT;
> +			if (need_resched())
> +				schedule();
> +			read_lock(&tasklist_lock);
> +			put_task_struct(t);
> +			/*
> +			 * t was unlinked from tasklist. Can't continue in this
> +			 * case. Exit and try again next time.
> +			 */
> +			if (t->state == TASK_DEAD)
> +				goto unlock;
> +		}

firstly, this bit should move into a helper function. Also, why dont you 
do the need_resched() check first (it's very lighweight) - and thus only 
do the heavy ops (get-task-struct & tasklist_lock unlock) if that is set?

But most importantly, isnt the logic above confused? --max_count will 
reach zero exactly once, and then we'll loop for a long time.

	Ingo
