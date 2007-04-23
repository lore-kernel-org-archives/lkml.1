Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbXDWKkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbXDWKkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXDWKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:40:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56700 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754137AbXDWKkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:40:36 -0400
Date: Mon, 23 Apr 2007 12:40:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com
Subject: Re: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Message-ID: <20070423104024.GB5635@elf.ucw.cz>
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu> <200704222128.49419.rjw@sisk.pl> <200704222141.00680.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222141.00680.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Fix the problem with kthread_stop() that causes the freezer to fail if a
> freezable thread is attempting to stop a frozen one and that may cause the
> freezer to fail if the thread being stopped is freezable and
> try_to_freeze_tasks() is running concurrently with kthread_stop().

Parse error.

> Index: linux-2.6.21-rc6-mm1/kernel/kthread.c
> ===================================================================
> --- linux-2.6.21-rc6-mm1.orig/kernel/kthread.c	2007-04-09 15:23:48.000000000 +0200
> +++ linux-2.6.21-rc6-mm1/kernel/kthread.c	2007-04-22 19:05:29.000000000 +0200
> @@ -232,6 +233,14 @@ int kthread_stop(struct task_struct *k)
>  
>  	/* Now set kthread_should_stop() to true, and wake it up. */
>  	kthread_stop_info.k = k;
> +	if (!freezer_should_exempt(current)) {
> +		/* We are freezable, so we must make sure that the thread being
> +		 * stopped is not frozen and will not be frozen until it dies
> +		 */
> +		freezer_exempt(k);
> +		if (frozen(k))
> +			clear_frozen_flag(k);
> +	}
>  	wake_up_process(k);
>  	put_task_struct(k);
>  

Do we need to take some locks to access other process' flags? Or do
frozen_exempt() etc take enough locks, already?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
