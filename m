Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbZANRSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbZANRSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbZANRSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:18:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:36723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbZANRSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:18:03 -0500
Date: Wed, 14 Jan 2009 18:18:00 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -v11][RFC] mutex: implement adaptive spinning
Message-ID: <20090114171800.GA18621@wotan.suse.de>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231952436.14825.28.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 06:00:36PM +0100, Peter Zijlstra wrote:
> Full series, including changelogs available at:
> 
>  http://programming.kicks-ass.net/kernel-patches/mutex-adaptive-spin/
> 
> and should shortly appear in a git tree near Ingo :-)

Linus is going to take a wholesale conversion of mutexes to adaptive
mutexes? He's gone soft. I put on my asbestos underwear for no reason,
then.

 
> @@ -173,21 +237,21 @@ __mutex_lock_common(struct mutex *lock, 
>  			spin_unlock_mutex(&lock->wait_lock, flags);
>  
>  			debug_mutex_free_waiter(&waiter);
> +			preempt_enable();
>  			return -EINTR;
>  		}
>  		__set_task_state(task, state);
>  
>  		/* didnt get the lock, go to sleep: */
>  		spin_unlock_mutex(&lock->wait_lock, flags);
> -		schedule();
> +		__schedule();

Why does this need to do a preempt-disabled schedule? After we schedule
away, the next task can do arbitrary things or reschedule itself, so if
we have not anticipated such a condition here, then I can't see what
__schedule protects. At least a comment is in order?

Pity to add the call overhead to schedule just for this case. BTW.
__schedule shouldn't need to be asmlinkage?

>  		spin_lock_mutex(&lock->wait_lock, flags);
>  	}
>  
