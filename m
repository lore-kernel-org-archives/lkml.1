Return-Path: <linux-kernel-owner+w=401wt.eu-S1762399AbXEKTkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762399AbXEKTkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXEKTk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:40:29 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709AbXEKTk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:40:28 -0400
Date: Fri, 11 May 2007 12:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-Id: <20070511123959.190adfaf.akpm@linux-foundation.org>
In-Reply-To: <200705110036.26617.rjw@sisk.pl>
References: <200705110035.32229.rjw@sisk.pl>
	<200705110036.26617.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 00:36:25 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> The reading of PF_BORROWED_MM in is_user_space() without task_lock() is racy. 
> Fix it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  kernel/power/process.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/power/process.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/process.c	2007-05-10 21:44:23.000000000 +0200
> +++ linux-2.6/kernel/power/process.c	2007-05-10 21:44:28.000000000 +0200
> @@ -8,6 +8,7 @@
>  
>  #undef DEBUG
>  
> +#include <linux/sched.h>
>  #include <linux/interrupt.h>
>  #include <linux/suspend.h>
>  #include <linux/module.h>
> @@ -88,7 +89,12 @@ static void cancel_freezing(struct task_
>  
>  static inline int is_user_space(struct task_struct *p)
>  {
> -	return p->mm && !(p->flags & PF_BORROWED_MM);
> +	int ret;
> +
> +	task_lock(p);
> +	ret = p->mm && !(p->flags & PF_BORROWED_MM);
> +	task_unlock(p);
> +	return ret;
>  }

The whole function is racy, isn't it?  I mean, the condition which it is
testing can go from true->false or false->true at any instant after this
function returns its now-wrong value.

iow, callers of this function need to to something to prevent the expression
`p->mm && !(p->flags & PF_BORROWED_MM);' from changing value _anyway_.  In
which case the new locking is not needed?

