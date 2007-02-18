Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXBRXdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXBRXdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXBRXdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:33:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50530 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbXBRXdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:33:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] fix refrigerator() vs thaw_process() race
Date: Mon, 19 Feb 2007 00:28:03 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20070218221737.GA4880@tv-sign.ru>
In-Reply-To: <20070218221737.GA4880@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702190028.03619.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 23:17, Oleg Nesterov wrote:
> refrigerator() can miss a wakeup, "wait event" loop needs a proper memory
> ordering.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

ACK 

> --- WQ/kernel/power/process.c~WAKE	2007-02-18 22:56:49.000000000 +0300
> +++ WQ/kernel/power/process.c	2007-02-19 01:04:26.000000000 +0300
> @@ -46,8 +46,10 @@ void refrigerator(void)
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
> 
> 
> 

-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
