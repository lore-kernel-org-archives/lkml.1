Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZKCAYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZKCAYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbZKCAYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:24:05 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33754 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbZKCAYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:24:04 -0500
Date: Mon, 2 Nov 2009 19:23:55 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091103002355.GB19891@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102185137.GA28803@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 07:51:37PM +0100, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > > Have you ensured that no rlimit gets propagated during task init 
> > > into some other value - under the previously correct assumption that 
> > > rlimits dont change asynchronously under the feet of tasks?
> > 
> > I've looked, and the only place that I see the rlim array getting 
> > copied is via copy_signal when we're in the clone path.  The entire 
> > rlim array is copied from old task_struct to new task_struct under the 
> > protection of the current->group_leader task lock, which I also hold 
> > when updating via sys_setprlimit, so I think we're safe in this case.
> 
> I mean - do we set up any data structure based on a particular rlimit, 
> that can get out of sync with the rlimit being updated?
> 
> A prominent example would be the stack limit - we base address layout 
> decisions on it. Check arch/x86/mm/mmap.c. RLIM_INFINITY has a special 
> meaning plus we also set mmap_base() based on the rlim.
> 
Ah, I didn't consider those.  Yes it looks like some locking might be needed for
cases like that.  what would you suggest, simply grabbing the task lock before
looking at the rlim array?  That seems a bit heavy handed, especially if we want
to use the locking consistently.  What if we just converted the int array of
rlimit to atomic_t's?  Would that be sufficient, or still to heavy?

> Also, there appears to be almost no security checks in the new syscall! 
> We look up a PID but that's it - this code will allow unprivileged users 
> to lower various rlimits of system daemons - as if it were their own 
> limit. That's a rather big security hole.
> 
Yeah, I kept all the old checks in place, but didn't consider that other
processes might need additional security checks,   I guess the rule needs to be
that the callers uid needs to have CAP_SYS_RESOURCE and must match the uid of
the process being modified or be 0/root.  Is that about right?

Regards
Neil

> 	Ingo
> 
