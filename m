Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZK3RGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZK3RGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZK3RGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:06:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZK3RGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:06:11 -0500
Date: Mon, 30 Nov 2009 09:05:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <20091130163923.GC6762@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0911300852410.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de> <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain> <20091130154031.GE21639@wotan.suse.de>
 <alpine.LFD.2.00.0911300754420.2872@localhost.localdomain> <20091130163923.GC6762@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, Paul E. McKenney wrote:
> 
> My suggestion would be to put the nesting counter in the task structure
> to avoid this problem.

It still doesn't end up being all that cheap. Now you'd need to disable 
preemption in order to fix the race between the local counter and the real 
lock.

That should be cheaper than cli/sti, but the downside is that now you need 
that task struct pointer (both for the preemption disable and the 
counter), so now you're adding some register pressure too. Of course, 
maybe you don't even want to inline it anyway, in which case that doesn't 
matter.

One advantage with your suggestion of using preemption is that (unlike irq 
disables) you can keep the preemt counter over the whole lock, so you 
don't need to re-do the preempt disable/enable in both read-lock and 
read-unlock.

So you might end up with something like (UNTESTED!):

	static void tasklist_write_lock(void)
	{
		spin_lock_irq(&tasklist_lock);
	}

	static void tasklist_write_unlock(void)
	{
		spin_unlock_irq(&tasklist_lock);
	}

	static void tasklist_read_lock(void)
	{
		preempt_disable();
		if (!current->tasklist_count++)
			spin_lock(&tasklist_lock);
	}

	static void tasklist_read_unlock(void)
	{
		if (!--current->tasklist_count)
			spin_unlock(&tasklist_lock);
		preempt_enable();
	}

And the upside, of course, is that a spin_unlock() is cheaper than a 
read_unlock() (no serializing atomic op), so while there is overhead, 
there are also some advantages.. Maybe that atomic op advantage is enough 
to offset the extra instructions.

And maybe we could use 'raw_spin_[un]lock()' in the above read-[un]lock 
sequences, since tasklist_lock is pretty special, and since we do the 
preempt disable by hand (no need to do it again in the spinlock code). 
That looks like it might cut down the overhead of all of the above to 
almost nothing for what is probably the common case today (ie preemption 
enabled).

			Linus
