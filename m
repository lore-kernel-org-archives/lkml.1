Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZKBRyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZKBRyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbZKBRyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:54:10 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54281 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZKBRyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:54:09 -0500
Date: Mon, 2 Nov 2009 12:54:07 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091102175407.GE4075@hmsreliant.think-freely.org>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102152520.GG23776@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:25:20PM +0100, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Ok, I give.  I was hoping that some of the requestors of this feature 
> > would pipe up and support the use case for the proc file interface to 
> > set limits.  clearly they're not that interested, but I still think 
> > theres merit in the patch.  So heres version 7 of this patch set.  Its 
> > the same as before, but the proc interface has been dropped, leaving 
> > only the syscall interface behind.  I've tested the interface on intel 
> > 32 and 64 bit, with success
> > 
> > Summary:
> > 
> > Its been requested often that we have the ability to read and modify 
> > process rlimit values from contexts external to the owning process.  
> > Ideally this allows sysadmins to adjust rlimits on long running 
> > processes wihout the need to stop and restart those processes, which 
> > incurs undesireable downtime.  This patch enables that functionality, 
> > It does so in two places.  First it enables process limit setting by 
> > writing to the /proc/pid/limits file a string in the format: <limit> 
> > <current limit> <max limit> > /proc/<pid>/limits where limit is one of 
> > [as,core,cpu,data,fsize,locks,memlock,msgqueue,nice,nofile,nproc,rss,rtprio,rttime]
> > 
> > Secondly it allows for programatic setting of these limits via 2 new 
> > syscalls, getprlimit, and setprlimit, which act in an identical 
> > fashion to getrlimit and setrlimit respectively, except that they 
> > except a process id as an extra argument, to specify the process id of 
> > the rlimit values that you wish to read/write
> 
> This looks potentially useful but i think the implementation might be 
> too optimistic, from a security POV.
> 
> Have you ensured that no rlimit gets propagated during task init into 
> some other value - under the previously correct assumption that rlimits 
> dont change asynchronously under the feet of tasks?
> 
I've looked, and the only place that I see the rlim array getting copied is via
copy_signal when we're in the clone path.  The entire rlim array is copied from
old task_struct to new task_struct under the protection of the
current->group_leader task lock, which I also hold when updating via
sys_setprlimit, so I think we're safe in this case.

> Also, there's SMP safety: right now all the accesses to 
> current->signal->rlim[] are unlocked and assume that if we are executing 
> in a syscall those values cannot change. Is this a safe assumption on 
> all SMP architectures?
> 
I was concerned about this too a bit, but looking at it all the RLIM's are 32
bit values.  So this is going to be an atomic write on any arch that is 32 bits
or larger (or am I mistaken there?).  Sure, there might be some caching effects
that result in an old value getting read on another processor, but such
inconsistencies should be short lived, shouldn't they?  Just thinking that
introducing locking to prevent such temporary inconsistencies might not be worth
the performance hit.  Certainly open to opinion on this though.

> Plus, the locking looks structured in a weird way: why is the 
> sighand-lock taken in the procfs code instead of moving it where the 
> data structure is updated (the resource limits code).
> 
Lack of change is really the answer.  Thats the way it was previously, and since
Andrew was interested in just going with the syscall implementation, I didn't
introduce more changes to the proc path.  figured I would update the proc path
when/if this got accpeted.

> Also, a patch submission observation: every single patch you submitted 
> here had a messed up title that had a 'Re: ' in it, making it hard to 
> sort out what is the latest. Some of the patches also had their 
Thats why I appended a version number to the end.

> changelog indented. Please use the standard patch submission methods.
> 
Yeah, sorry about that.

I'll make the changes you requested in your first note, let me know what you
think of the above, and I'll make further changes as needed.
Thanks!
Neil

