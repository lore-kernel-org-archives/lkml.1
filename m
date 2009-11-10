Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZKJRLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZKJRLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbZKJRLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:11:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290AbZKJRLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:11:35 -0500
Date: Tue, 10 Nov 2009 09:10:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
In-Reply-To: <4AF90254.40909@kernel.org>
Message-ID: <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain>
References: <4AF90254.40909@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Nov 2009, Tejun Heo wrote:
> 
> Please pull from the following percpu fix branch.

No way in hell.

> It fixes a possible deadlock caused by lock ordering inversion through
> irq.

.. and it does so by introducing a new bug. No thank you.

> +
> +	/*
> +	 * pcpu_mem_free() might end up calling vfree() which uses
> +	 * IRQ-unsafe lock and thus can't be called with pcpu_lock
> +	 * held.  Release and reacquire pcpu_lock if old map needs to
> +	 * be freed.
> +	 */
> +	if (old) {
> +		spin_unlock_irqrestore(&pcpu_lock, *flags);
> +		pcpu_mem_free(old, size);
> +		spin_lock_irqsave(&pcpu_lock, *flags);
> +	}

Routines that drop and then re-take the lock should be banned, as it's 
almost always a bug waiting to happen. As it is this time:

>  	return 0;

Now the caller will happily continue to traverse a list that may no longer 
be valid, because you dropped the lock.

Really. This thing is total sh*t. It was misdesigned to start with, and 
the calling convention is wrong. That 'pcpu_extend_area_map()' function 
should be split up into two functions: 'pcpu_needs_to_extend()' that never 
drops the lock, and 'pcpu_extend_area()' that _always_ drops the lock 
(and then returns an error if it can't allocate the memory).

Not that shit-for-brains that may or may not drop the lock, and then 
returns an incorrect error return depending on whether it did.

In other words: fix the sh*t, don't add even more to it. That 'return 0' 
was and is wrong. It should have been a 'return 1'. And thank the Gods 
that I looked at it, 

Sure, you can fix the bug by just returning 1. But you can't fix the total 
crap of a calling convention that way. Fix it properly as outlined above, 
and remember: functions that drop locks that were held when called are 
EVIL and almost always the source of really subtle races.

As it was in this case.

			Linus
