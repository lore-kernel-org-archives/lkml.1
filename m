Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZAISZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZAISZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZAISZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:25:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbZAISY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:24:59 -0500
Date: Fri, 9 Jan 2009 10:24:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Steven Rostedt <rostedt@goodmis.org>, Chris Mason <chris.mason@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231524964.442.103.camel@twins>
Message-ID: <alpine.LFD.2.00.0901091021070.6528@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>  <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins>  <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com> 
 <alpine.LFD.2.00.0901090828510.6528@localhost.localdomain>  <alpine.DEB.1.10.0901091142060.17378@gandalf.stny.rr.com> <1231524964.442.103.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Peter Zijlstra wrote:
> 
> On that note:
> 
> Index: linux-2.6/kernel/mutex.c
> ===================================================================
> --- linux-2.6.orig/kernel/mutex.c
> +++ linux-2.6/kernel/mutex.c
> @@ -220,7 +220,9 @@ __mutex_lock_common(struct mutex *lock, 
>  		__set_task_state(task, state);
>  
>  		/* didnt get the lock, go to sleep: */
> +		preempt_disable();
>  		spin_unlock_mutex(&lock->wait_lock, flags);
> +		preempt_enable_no_resched();
>  		schedule();

Yes. I think this is a generic issue independently of the whole adaptive 
thing.

In fact, I think wee could make the mutex code use explicit preemption and 
then the __raw spinlocks to make this more obvious. Because now there's a 
hidden "preempt_enable()" in that spin_unlock_mutex, and anybody looking 
at the code and not realizing it is going to just say "Whaa? Who is this 
crazy Peter Zijlstra guy, and what drugs is he on? I want me some!".

Because your patch really doesn't make much sense unless you know how 
spinlocks work, and if you _do_ know how spinlocks work, you go "eww, 
that's doing extra preemption crud in order to just disable the 
_automatic_ preemption crud".

			Linus
