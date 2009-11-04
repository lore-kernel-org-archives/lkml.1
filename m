Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZKDL1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZKDL1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZKDL07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:26:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57762 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbZKDL07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:26:59 -0500
Date: Wed, 4 Nov 2009 12:26:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091104112632.GA9243@elte.hu>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103002355.GB19891@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> On Mon, Nov 02, 2009 at 07:51:37PM +0100, Ingo Molnar wrote:
> > 
> > * Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > > > Have you ensured that no rlimit gets propagated during task init 
> > > > into some other value - under the previously correct assumption that 
> > > > rlimits dont change asynchronously under the feet of tasks?
> > > 
> > > I've looked, and the only place that I see the rlim array getting 
> > > copied is via copy_signal when we're in the clone path.  The 
> > > entire rlim array is copied from old task_struct to new 
> > > task_struct under the protection of the current->group_leader task 
> > > lock, which I also hold when updating via sys_setprlimit, so I 
> > > think we're safe in this case.
> > 
> > I mean - do we set up any data structure based on a particular 
> > rlimit, that can get out of sync with the rlimit being updated?
> > 
> > A prominent example would be the stack limit - we base address 
> > layout decisions on it. Check arch/x86/mm/mmap.c. RLIM_INFINITY has 
> > a special meaning plus we also set mmap_base() based on the rlim.
> 
> Ah, I didn't consider those.  Yes it looks like some locking might be 
> needed for cases like that.  what would you suggest, simply grabbing 
> the task lock before looking at the rlim array?  That seems a bit 
> heavy handed, especially if we want to use the locking consistently.  
> What if we just converted the int array of rlimit to atomic_t's?  
> Would that be sufficient, or still to heavy?

The main problem isnt even atomicity (word sized, naturally aligned 
variables are read/written atomic already), but logical coherency and 
races: how robust is it to change the rlimit 'under' a task that is 
running those VM routines on another CPU right now? How robust is it to 
change a task from RLIM_INFINITY and affecting fundamental properties of 
its layout?

The answer might easily be: "it causes no security problems and we dont 
care about self-inflicted damage" - but we have to consider each usage 
site individually and list them in the changelog i suspect.

I checked some other rlimit uses (the VFS ones) and most of them seemed 
to be fine, at first glance.

What we do here is to introduce a completely new mode of access to an 
ancient and quite fundamental data structure of the kernel, so i think 
all the usage sites and side-effects should be thought through.

I wouldnt go so far to suggest explicit, heavy-handed locking - _most_ 
of the uses are single-use. I just wanted to point out the possibilities 
that should be considered before we can have warm fuzzy feelings about 
your patch.

Maybe a read wrapper that does an ACCESS_ONCE() would be prudent, in 
case compilers do something silly in the future.

> > Also, there appears to be almost no security checks in the new 
> > syscall! We look up a PID but that's it - this code will allow 
> > unprivileged users to lower various rlimits of system daemons - as 
> > if it were their own limit. That's a rather big security hole.
> 
> Yeah, I kept all the old checks in place, but didn't consider that 
> other processes might need additional security checks, I guess the 
> rule needs to be that the callers uid needs to have CAP_SYS_RESOURCE 
> and must match the uid of the process being modified or be 0/root.  Is 
> that about right?

I think the regular ptrace or signal security checks could be reused 
(sans the legacy components).
 
Those tend to be a (tiny) bit more than just a uid+capability check - 
they are a [fse]uid check, i.e. the path of denial should be something 
like:

        if ((cred->uid != tcred->euid ||
             cred->uid != tcred->suid ||
             cred->uid != tcred->uid  ||
             cred->gid != tcred->egid ||
             cred->gid != tcred->sgid ||
             cred->gid != tcred->gid) &&
            !capable(CAP_SYS_RESOURCE)) {

	Ingo
