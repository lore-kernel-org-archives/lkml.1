Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZAFXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZAFXCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZAFXCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:02:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbZAFXB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:01:58 -0500
Date: Tue, 6 Jan 2009 15:00:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
In-Reply-To: <1231281801.11687.125.camel@twins>
Message-ID: <alpine.LFD.2.00.0901061456280.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain> 
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Peter Zijlstra wrote:
> 
> Indeed, the below does boot -- which means I get to sleep now ;-)

Well, if you didn't go to sleep, a few more questions..

>  int __sched
>  mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
>  {
> +	int ret;
> +
>  	might_sleep();
> -	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
> +	ret =  __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
> +	if (!ret)
> +		lock->owner = current;
> +
> +	return ret;

This looks ugly. Why doesn't __mutex_lock_common() just set the lock 
owner? Hate seeing it done in the caller that has to re-compute common 
(yeah, yeah, it's cheap) and just looks ugly.

IOW, why didn't this just get done with something like

	--- a/kernel/mutex.c
	+++ b/kernel/mutex.c
	@@ -186,6 +186,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
	 done:
	 	lock_acquired(&lock->dep_map, ip);
	 	/* got the lock - rejoice! */
	+	lock->owner = task;
	 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
	 	debug_mutex_set_owner(lock, task_thread_info(task));

instead?  That takes care of all callers, including the conditional thing 
(since the error case is a totally different path).

		Linus
