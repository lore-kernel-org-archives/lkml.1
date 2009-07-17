Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZGQXM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZGQXM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 19:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbZGQXM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 19:12:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:19383 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991AbZGQXM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 19:12:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=OXznE673qsZ+n8yDBbOJ5j8/Djl7GA9JIF4aNA/k7fdMdSyOVALtsuEYL6sXIlHPi
	HAR6Imcmpd/AQcRtzZAZA==
Date: Fri, 17 Jul 2009 16:12:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <6599ad830907171303v255a0d65t64885d37c41b764a@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org> <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com> <20090714210557.0f983c37@bree.surriel.com> <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
 <6599ad830907161629p54783716p7246e030b8da00fe@mail.gmail.com> <alpine.DEB.2.00.0907170225570.15373@chino.kir.corp.google.com> <6599ad830907171303v255a0d65t64885d37c41b764a@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-1356783825-1247872371=:30600"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-1356783825-1247872371=:30600
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 17 Jul 2009, Paul Menage wrote:

> > The only way to workaround that is by using the highest oom_adj user for
> > the mm_struct from the array in reporting /proc/pid/oom_score, as well.
> 
> That sounds fine to me.
> 

It's better than what we did before my patchset, which would be report an 
erroneous oom_score if another thread attached to the same mm_struct had a 
less immune (more positive) oom_adj score.

With my patches in 2.6.31-rc3, there is no ambiguity and /proc/pid/oom_adj 
and /proc/pid/oom_score are consistent for all threads.  Because of that, 
they now accurately reflect in all circumstances how the oom killer 
chooses a victim, which should be very important to users who are tuning 
oom_adj values in the first place.

> > But that would lead to /proc/pid/oom_adj not affecting oom_score at all,
> > which isn't consistent.
> 
> Isn't consistent with what? It's perfectly consistent with saying "the
> oom_score of a task is based on the highest oom_adj value of any task
> sharing the same mm". Admittedly it's not 100% consistent with the old
> semantics, but I'm having trouble imagining a scenario where someone
> was relying on the changed semantics.
> 

I'm sure that most users who tune /proc/pid/oom_adj for a group of tasks, 
especially when tuning them in terms of killing priority in oom conditions 
as opposed to simply using OOM_DISABLE, rely on /proc/pid/oom_score to 
determine when a task should be killed because it is using an egregious 
amount of memory.  That's why oom_score is exported to userspace; 
otherwise, tuning oom_adj for anything other than OOM_DISABLE would be 
difficult.

> But taking a completely different approach, is there a reason that we
> couldn't have just moved the do_each_thread() check for OOM_DISABLED
> out of oom_kill_task() and into select_bad_process() at the point
> where we've decided that the thread in question is a better victim
> than the current victim? That would fix the OOM livelock while
> allowing us to keep exactly the same oom_adj/oom_score semantics as in
> previous kernels.
> 

My patches don't merely address threads that have an oom_adj value of 
OOM_DISABLE while others sharing the same memory do not, they address a 
consistency issue whereas those threads may all share memory but have 
radically different oom_adj values: that means that only the highest 
oom_adj value amongst them is actually used by the oom killer and all 
other oom_adj values set by the user for those threads are wrong.

> > The inheritance issue should be fixed with Rik's patch with the exception
> > of vfork -> change /proc/pid-of-child/oom_adj -> execve.  If scripts were
> > written to do that with the old behavior, they'll have to adjust to change
> > oom_adj _after_ the execve
> 
> Think about what you're suggesting here - execve() replaces your code
> with whatever you're execing, so unless that code is also written to
> handle oom_adj (which for something like a generic job scheduler, the
> exec'd code is unlikely to do) you're stuck.
> 

The burden to adjust /proc/pid/oom_adj has always been on the admin, the 
only thing the kernel needs to provide is an inheritance property (as 
added with Rik's patch) to have any consistency with a priority based 
killing approach, i.e. forked children should have the same oom_adj value 
to begin with to not be more immune or a higher priority to kill than the 
parent unless explicitly changed by the admin.
--497827084-1356783825-1247872371=:30600--
