Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbYEXDCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbYEXDCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 23:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYEXDC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 23:02:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbYEXDC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 23:02:26 -0400
Date: Fri, 23 May 2008 23:02:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, tglx@linutronix.de, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH 5/5] remove the extra call to try_to_take_lock
In-Reply-To: <20080520144936.15992.48894.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0805232301080.12686@gandalf.stny.rr.com>
References: <20080520143954.15992.85900.stgit@novell1.haskins.net>
 <20080520144936.15992.48894.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 May 2008, Gregory Haskins wrote:

> From: Peter W. Morreale <pmorreale@novell.com>
>
> Remove the redundant attempt to get the lock.  While it is true that the
> exit path with this patch adds an un-necessary xchg (in the event the
> lock is granted without further traversal in the loop) experimentation
> shows that we almost never encounter this situation.
>
> Signed-off-by: Peter W. Morreale <pmorreale@novell.com>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/rtmutex.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index ec1f7d4..1da7813 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -785,12 +785,6 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>  	spin_lock_irqsave(&lock->wait_lock, flags);
>  	init_lists(lock);
>
> -	/* Try to acquire the lock again: */
> -	if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
> -		spin_unlock_irqrestore(&lock->wait_lock, flags);
> -		return;
> -	}
> -

This would suggested that lock stealing doesn't happen. On lock stealing,
this is the condition that is triggered and we have a nice quick exit.

-- Steve



>  	BUG_ON(rt_mutex_owner(lock) == current);
>
>  	/*
>
