Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZG3TFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZG3TFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZG3TFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:05:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZG3TFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:05:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=j0tP8yoWZnVJKbtRguflh5dhhqSfjOwBR/rH5cXkyvmA379Q5e2WEn/aEgpkwh2hv
	xCIbRRyUQ7AEggaqqC25g==
Date: Thu, 30 Jul 2009 12:05:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
In-Reply-To: <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com> <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com> <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009, KAMEZAWA Hiroyuki wrote:

> > If you have suggestions for a better name, I'd happily ack it.
> > 
> 
> Simply, reset_oom_adj_at_new_mm_context or some.
> 

I think it's preferred to keep the name relatively short which is an 
unfortuante requirement in this case.  I also prefer to start the name 
with "oom_adj" so it appears alongside /proc/pid/oom_adj when listed 
alphabetically.

> > > 2. More simple plan is like this, IIUC.
> > > 
> > >   fix oom-killer's select_bad_process() not to be in deadlock.
> > > 
> > 
> > Alternate ideas?
> > 
> At brief thiking.
> 
> 1. move oom_adj from mm_struct to signal struct. or somewhere.
>    (see copy_signal())
>    Then,
>     - all threads in a process will have the same oom_adj.
>     - vfork()'ed thread will inherit its parent's oom_adj.   
>     - vfork()'ed thread can override oom_adj of its own.
> 
>     In other words, oom_adj is shared when CLONE_PARENT is not set.
> 

Hmm, didn't we talk about signal_struct already?  The problem with that 
approach is that oom_adj values represent a killable quantity of memory, 
so having multiple threads sharing the same mm_struct with one set to 
OOM_DISABLE and the other at +15 will still livelock because the oom 
killer can't kill either.

> 2. rename  mm_struct's oom_adj as shadow_oom_adj.
> 
>    update this shadow_oom_adj as the highest oom_adj among
>    the values all threads share this mm_struct have.
>    This update is done when
>    - mm_init()
>    - oom_adj is written.
> 
>    User's 
>    # echo XXXX > /proc/<x>/oom_adj
>    is not necessary to be very very fast.
> 
>    I don't think a process which calls vfork() is multi-threaded.
> 
> 3. use shadow_oom_adj in select_bad_process().
> 

Ideas 2 & 3 here seem to be a single proposal.  The problem is that it 
still leaves /proc/pid/oom_score to be inconsistent with the badness 
scoring that the oom killer will eventually use since if it oom kills one 
task, it must kill all tasks sharing the same mm_struct to lead to future 
memory freeing.

Additionally, if you were to set one thread to OOM_DISABLE, storing the 
highest oom_adj value in mm_struct isn't going to help because 
oom_kill_task() will still require a tasklist scan to ensure no threads 
sharing the mm_struct are OOM_DISABLE and the livelock persists.

In other words, the issue here is larger than the inheritance of the 
oom_adj value amongst children, it addresses a livelock that neither of 
your approaches solve.  The fix actually makes /proc/pid/oom_adj (and 
/proc/pid/oom_score) consistent with how the oom killer behaves.
