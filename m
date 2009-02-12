Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbZBLXZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbZBLXZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZBLXZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:25:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZBLXZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:25:08 -0500
Date: Thu, 12 Feb 2009 21:24:59 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rt/threadirqs: don't need to save irqs in
	do_hardirq()
Message-ID: <20090212232459.GD5348@ghostprotocols.net>
References: <4994ae18.1358560a.454d.403b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4994ae18.1358560a.454d.403b@mx.google.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 12, 2009 at 07:27:08PM +0100, Frederic Weisbecker escreveu:
> do_hardirq() has only one caller do_irqd() in a path where irq are already
> disabled. So we don't need to save irqs while holding desc->lock
> 
> Replace spin_lock_irqsave by spin_lock.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/irq/manage.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index ed7c5e3..6e9baf8 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -905,7 +905,7 @@ static void do_hardirq(struct irq_desc *desc)
>  {
>  	unsigned long flags;

Can flags be removed too?
  
> -	spin_lock_irqsave(&desc->lock, flags);
> +	spin_lock(&desc->lock);
>  
>  	if (!(desc->status & IRQ_INPROGRESS))
>  		goto out;
> @@ -921,7 +921,7 @@ static void do_hardirq(struct irq_desc *desc)
>  	else
>  		thread_do_irq(desc);
>   out:
> -	spin_unlock_irqrestore(&desc->lock, flags);
> +	spin_unlock(&desc->lock);
>  
>  	if (waitqueue_active(&desc->wait_for_handler))
>  		wake_up(&desc->wait_for_handler);
