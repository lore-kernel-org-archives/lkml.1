Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbXHBSk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbXHBSk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbXHBSkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:40:14 -0400
Received: from mail.screens.ru ([213.234.233.54]:56010 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbXHBSkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:40:13 -0400
Date: Thu, 2 Aug 2007 22:40:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping (updated)
Message-ID: <20070802184002.GA283@tv-sign.ru>
References: <200708012328.23939.rjw@sisk.pl> <20070801164831.ed40546d.akpm@linux-foundation.org> <200708021315.18851.rjw@sisk.pl> <200708021938.37547.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708021938.37547.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Rafael J. Wysocki wrote:
>
> @@ -171,6 +186,10 @@ static int try_to_freeze_tasks(int freez
>  
>  	end_time = jiffies + TIMEOUT;
>  	do {
> +		DEFINE_WAIT(wait);
> +
> +		add_wait_queue(&refrigerator_waitq, &wait);

Hmm. In that case I'd sugest to use prepare_to_wait(). This means that
multiple wakeups from refrigerator() won't do unnecessary work, and

> +
>  		todo = 0;
>  		read_lock(&tasklist_lock);
>  		do_each_thread(g, p) {
> @@ -189,7 +208,12 @@ static int try_to_freeze_tasks(int freez
>  				todo++;
>  		} while_each_thread(g, p);
>  		read_unlock(&tasklist_lock);
> -		yield();			/* Yield is okay here */
> +
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		if (todo && !list_empty_careful(&wait.task_list))
> +			schedule_timeout(WAIT_TIME);

we don't need to check list_empty_careful() before schedule, prepare_to_wait()
sets TASK_UNINTERRUPTIBLE under wait_queue_head_t->lock.

Still, I personally agree with Pavel. Perhaps it is better to just replace
yield() with schedule_timeout(a_bit).

Oleg.

