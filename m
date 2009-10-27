Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbZJ0VEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbZJ0VEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZJ0VEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:04:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43245 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbZJ0VEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:04:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Xjo86LntMtmdcVmYkh151qQUrwqcZ2AVhDYJw0AKlGtSw1pduLLHrHldCyLlYMC/I
	AKkzx9TkMpRxmtQnBZfiQ==
Date: Tue, 27 Oct 2009 14:04:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, vedran.furac@gmail.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <Pine.LNX.4.64.0910271843510.11372@sister.anvils>
Message-ID: <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Hugh Dickins wrote:

> When preparing KSM unmerge to handle OOM, I looked at how the precedent
> was handled by running a little program which mmaps an anonymous region
> of the same size as physical memory, then tries to mlock it.  The
> program was such an obvious candidate to be killed, I was shocked
> by the poor decisions the OOM killer made.  Usually I ran it with
> mem=512M, with gnome and firefox active.  Often the OOM killer killed
> it right the first time, but went wrong when I tried it a second time
> (I think that's because of what's already swapped out the first time).
> 

The heuristics that the oom killer use in selecting a task seem to get 
debated quite often.

What hasn't been mentioned is that total_vm does do a good job of 
identifying tasks that are using far more memory than expected.  That 
seems to be the initial target: killing a rogue task that is hogging much 
more memory than it should, probably because of a memory leak.

The latest approach seems to be focused more on killing the task that will 
free the most resident memory.  That certainly is understandable to avoid 
killing additional tasks later and avoiding subsequent page allocations in 
the short term, but doesn't help to kill the memory leaker.

There's advantages to either approach, but it depends on the contextual 
goal of the oom killer when it's called: kill a rogue task that is 
allocating more memory than expected, or kill a task that will free the 
most memory.

> 1.  select_bad_process() tries to avoid killing another process while
> there's still a TIF_MEMDIE, but its loop starts by skipping !p->mm
> processes.  However, p->mm is set to NULL well before p reaches
> exit_mmap() to actually free the memory, and there may be significant
> delays in between (I think exit_robust_list() gave me a hang at one
> stage).  So in practice, even when the OOM killer selects the right
> process to kill, there can be lots of collateral damage from it not
> waiting long enough for that process to give up its memory.
> 
> I tried to deal with that by moving the TIF_MEMDIE test up before
> the p->mm test, but adding in a check on p->exit_state:
> 		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
> 		    !p->exit_state)
> 			return ERR_PTR(-1UL);
> But this is then liable to hang the system if there's some reason
> why the selected process cannot proceed to free its memory (e.g.
> the current KSM unmerge case).  It needs to wait "a while", but
> give up if no progress is made, instead of hanging: originally
> I thought that setting PF_MEMALLOC more widely in page_alloc.c,
> and giving up on the TIF_MEMDIE if it was waiting in PF_MEMALLOC,
> would deal with that; but we cannot be sure that waiting of memory
> is the only reason for a holdup there (in the KSM unmerge case it's
> waiting for an mmap_sem, and there may well be other such cases).
> 

I've proposed an oom killer timeout in the past which adds a jiffies count 
to struct task_struct and will defer killing other tasks until the 
predefined time limit (we use 10*HZ) has been exceeded.  The problem is 
that even if you kill another task, it is highly unlikely that the expired 
task will ever exit at that point and is still holding a substantial 
amount of memory since it also had access to memory reserves and has still 
failed to exit.

> 2.  I started out running my mlock test program as root (later
> switched to use "ulimit -l unlimited" first).  But badness() reckons
> CAP_SYS_ADMIN or CAP_SYS_RESOURCE is a reason to quarter your points;
> and CAP_SYS_RAWIO another reason to quarter your points: so running
> as root makes you sixteen times less likely to be killed.  Quartering
> is anyway debatable, but sixteenthing seems utterly excessive to me.
> 
> I moved the CAP_SYS_RAWIO test in with the others, so it does no
> more than quartering; but is quartering appropriate anyway?  I did
> wonder if I was right to be "subverting" the fine-grained CAPs in
> this way, but have since seen unrelated mail from one who knows
> better, implying they're something of a fantasy, that su and sudo
> are indeed what's used in the real world.  Maybe this patch was okay.
> 

I think someone (Nick?) proposed a patch at one time that removed most of 
the heuristics from select_bad_process() other than total_vm of the task 
and its children, mems_allowed intersection, and oom_adj.

> 4.  In some cases those children are sharing exactly the same mm,
> yet its total_vm is being added again and again to the points:
> I had a nasty inner loop searching back to see if we'd already
> counted this mm (but then, what if the different tasks sharing
> the mm deserved different adjustments to the total_vm?).
> 

oom_kill_process() may not kill the task selected by select_bad_process(), 
it will first attempt to kill one of these children with a different mm.
