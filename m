Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXBZLc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXBZLc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 06:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbXBZLc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 06:32:28 -0500
Received: from mail.screens.ru ([213.234.233.54]:56289 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXBZLc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 06:32:27 -0500
Date: Mon, 26 Feb 2007 14:32:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH -mm 2/6] Freezer: Fix memory ordering in refrigerator
Message-ID: <20070226113220.GC164@tv-sign.ru>
References: <200702260800.49603.rjw@sisk.pl> <200702260805.14870.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702260805.14870.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Rafael J. Wysocki wrote:
>
> From: Oleg Nesterov <oleg@tv-sign.ru>
> 
> refrigerator() can miss a wakeup, "wait event" loop needs a proper memory
> ordering.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  kernel/power/process.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.20-mm2/kernel/power/process.c
> ===================================================================
> --- linux-2.6.20-mm2.orig/kernel/power/process.c
> +++ linux-2.6.20-mm2/kernel/power/process.c
> @@ -47,8 +47,10 @@ void refrigerator(void)
>  	recalc_sigpending(); /* We sent fake signal, clean it up */
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -	while (frozen(current)) {
> -		current->state = TASK_UNINTERRUPTIBLE;
> +	for (;;) {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		if (!frozen(current))
> +			break;
>  		schedule();
>  	}
>  	pr_debug("%s left refrigerator\n", current->comm);

This one is already in -mm tree.

Oleg.

