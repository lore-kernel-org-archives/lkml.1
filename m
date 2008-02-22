Return-Path: <linux-kernel-owner+w=401wt.eu-S934931AbYBVN3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931AbYBVN3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbYBVN3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:29:38 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:40477 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbYBVN3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P9NcSHEhYMunIFIeioPdgIgp7Kfw+YLHfrYJR1u7RA2dPi7+4sfnyJJ85sA0fbxL5aQCsxfHdUFcD8+Z4X4RECCT5BVP52gLq5fAXi1KiPGWzqqKMdYEWSG1v7cEEABnjsk1/BjD19nUhuTRopUWlZ8TYQn0oR4eZq8KO3Z4MGk=
Message-ID: <47BECE30.8030100@gmail.com>
Date: Fri, 22 Feb 2008 08:29:20 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 05/14] rearrange rt_spin_lock sleep
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152651.4804.4702.stgit@novell1.haskins.net>
In-Reply-To: <20080221152651.4804.4702.stgit@novell1.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> @@ -732,14 +741,15 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>  
>  		debug_rt_mutex_print_deadlock(&waiter);
>  
> -		schedule_rt_mutex(lock);
> +		update_current(TASK_UNINTERRUPTIBLE, &saved_state);

I have a question for everyone out there about this particular part of 
the code. Patch 6/14 adds an optimization that is predicated on the 
order in which we modify the state==TASK_UNINTERRUPTIBLE vs reading the 
waiter.task below.

My assumption is that the xchg() (inside update_current()) acts as an 
effective wmb().  If xchg() does not have this property, then this code 
is broken and patch 6/14 should also add a:


+               smp_wmb();


> +		if (waiter.task)
> +			schedule_rt_mutex(lock);
> +		else
> +			update_current(TASK_RUNNING_MUTEX, &saved_state);
>  
>  		spin_lock_irqsave(&lock->wait_lock, flags);
>  		current->flags |= saved_flags;
>  		current->lock_depth = saved_lock_depth;
> -		state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
> -		if (unlikely(state == TASK_RUNNING))
> -			saved_state = TASK_RUNNING;


Does anyone know the answer to this?

Regards,
-Greg
