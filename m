Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXEUDgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXEUDgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 23:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXEUDf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 23:35:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835AbXEUDf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 23:35:58 -0400
Date: Sun, 20 May 2007 20:31:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: righiandr@users.sourceforge.net
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] limit print_fatal_signal() rate (was: [RFC] log
 out-of-virtual-memory events)
Message-Id: <20070520203123.5cde3224.akpm@linux-foundation.org>
In-Reply-To: <464ED258.2010903@users.sourceforge.net>
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net>
	<464ED258.2010903@users.sourceforge.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 12:33:04 +0200 (MEST) Andrea Righi <righiandr@users.sourceforge.net> wrote:

> Bernd Eckenfels wrote:
> > In article <464DCEAB.3090905@users.sourceforge.net> you wrote:
> >>        printk("%s/%d: potentially unexpected fatal signal %d.\n",
> >>                current->comm, current->pid, signr);
> > 
> > can we have both KERN_WARNING please?
> > 
> > Gruss
> > Bernd
> 
> Depends on print_fatal_signals patch.
> 
> ---
> 
> Limit the rate of print_fatal_signal() to avoid potential denial-of-service
> attacks.
> 
> Signed-off-by: Andrea Righi <a.righi@cineca.it>
> 
> diff -urpN linux-2.6.22-rc1-mm1/kernel/signal.c linux-2.6.22-rc1-mm1-vm-log-enomem/kernel/signal.c
> --- linux-2.6.22-rc1-mm1/kernel/signal.c	2007-05-19 11:25:24.000000000 +0200
> +++ linux-2.6.22-rc1-mm1-vm-log-enomem/kernel/signal.c	2007-05-19 11:30:00.000000000 +0200
> @@ -790,7 +790,10 @@ static void print_vmas(void)
>  
>  static void print_fatal_signal(struct pt_regs *regs, int signr)
>  {
> -	printk("%s/%d: potentially unexpected fatal signal %d.\n",
> +	if (unlikely(!printk_ratelimit()))
> +		return;
> +
> +	printk(KERN_WARNING "%s/%d: potentially unexpected fatal signal %d.\n",
>  		current->comm, current->pid, signr);
>  
>  #ifdef __i386__

Well OK.  But vdso-print-fatal-signals.patch is designated not-for-mainline
anyway.

I think the DoS which you identify has been available for a very long time
on ia64, x86_64 and perhaps others.


