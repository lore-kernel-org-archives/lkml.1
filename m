Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbZBERte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbZBERte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZBERtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:49:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbZBERtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:49:04 -0500
Date: Thu, 5 Feb 2009 09:48:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@google.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH 2/2 v4] softlockup: check all tasks in hung_task
Message-Id: <20090205094834.0dd9cfaa.akpm@linux-foundation.org>
In-Reply-To: <20090205143453.GG28443@elte.hu>
References: <20090204194339.GB22608@elte.hu>
	<20090205043548.GA18933@google.com>
	<20090205143453.GG28443@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009 15:34:53 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> Subject: [PATCH] softlockup: check all tasks in hung_task
> 
> Impact: extend the scope of hung-task checks
> 

A nanonit:

> +static const int hung_task_batching = 1024;

static const definitions look pretty but they're a bit misleading.

>  static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  {
> +	int batch_count = hung_task_batching;
>  	int max_count = sysctl_hung_task_check_count;
>  	unsigned long now = get_timestamp();
>  	struct task_struct *g, *t;
> @@ -131,6 +159,13 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  	do_each_thread(g, t) {
>  		if (!--max_count)
>  			goto unlock;
> +		if (!--batch_count) {
> +			batch_count = hung_task_batching;
> +			rcu_lock_break(g, t);
> +			/* Exit if t or g was unhashed during refresh. */
> +			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> +				goto unlock;
> +		}
>  		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
>  		if (t->state == TASK_UNINTERRUPTIBLE)
>  			check_hung_task(t, now, timeout);

The reader of this area of the code will expect that hung_task_batching
is a variable.  It _looks_ like the value of that variable can be altered
at any time by some other thread.  It _looks_ like this code will explode
if someone has accidentally set hung_task_batching to zero, etc.

But none of that is actually true, because hung_task_batching is, surprisingly,
a compile-time constant.

All this misleadingness would be fixed if it were called
HUNG_TASK_BATCHING.  But then it wouldn't be pretty.

