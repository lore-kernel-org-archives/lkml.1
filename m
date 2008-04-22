Return-Path: <linux-kernel-owner+w=401wt.eu-S1763522AbYDVReM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763522AbYDVReM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763244AbYDVRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:33:56 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1219 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbYDVRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:33:55 -0400
Subject: Re: [PATCH] Fix  max-stack calculators to skip canary
From: Joe Perches <joe@perches.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <480E1DED.9040104@sandeen.net>
References: <480D5F27.1030101@redhat.com> <20080422084404.GA2388@elte.hu>
	 <480E15DC.5040301@sandeen.net>  <480E1DED.9040104@sandeen.net>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 10:33:14 -0700
Message-Id: <1208885594.8636.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 12:18 -0500, Eric Sandeen wrote:
> Index: linux-2.6.25/kernel/exit.c
> ===================================================================
> --- linux-2.6.25.orig/kernel/exit.c	2008-04-20 22:34:16.000000000 -0500
> +++ linux-2.6.25/kernel/exit.c	2008-04-22 11:38:05.769412824 -0500
> @@ -826,6 +826,8 @@ static void check_stack_usage(void)
>  	unsigned long *n = end_of_stack(current);
>  	unsigned long free;
>  
> +	n++;	/* skip over canary at end */
> +
>  	while (*n == 0)
>  		n++;
>  	free = (unsigned long)n - (unsigned long)end_of_stack(current);
> Index: linux-2.6.25/kernel/sched.c
> ===================================================================
> --- linux-2.6.25.orig/kernel/sched.c	2008-04-20 22:34:19.000000000 -0500
> +++ linux-2.6.25/kernel/sched.c	2008-04-22 11:48:06.975407495 -0500
> @@ -5190,6 +5190,8 @@ void sched_show_task(struct task_struct 
>  #ifdef CONFIG_DEBUG_STACK_USAGE
>  	{
>  		unsigned long *n = end_of_stack(p);
> +
> +		n++;	/* skip over canary at end */
>  		while (!*n)
>  			n++;
>  		free = (unsigned long)n - (unsigned long)end_of_stack(p);
> 

Wouldn't it be better to have exactly the same code?
How about using a statement expression macro?

#define DEBUG_STACK_FREE(process) \
({ \
	unsigned long *n = end_of_stack(process); \
	do { 	/* Skip over canary */\
		n++; \
	} while (!*n); \
	(unsigned long)n - (unsigned long)end_of_stack(process); \
})

