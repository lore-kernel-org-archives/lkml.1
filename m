Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZGaTSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZGaTSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 15:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZGaTSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 15:18:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11765 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZGaTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 15:18:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=vlxU1ETKLncApWqZdw+xFhV1S4FAjfm3Ywm3gwgj4upMChjBZHsEdbMVtLkHB49ZK
	fE6EQYVWypxQqWQhFmpuQ==
Date: Fri, 31 Jul 2009 12:18:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
In-Reply-To: <7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com> <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com> <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com> <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com> <7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, KAMEZAWA Hiroyuki wrote:

> > Can you help think of any names that start with oom_adj_* and are
> > relatively short?  I'd happily ack it.
> >
> There have been traditional name "effective" as uid and euid.
> 
>  then,  per thread oom_adj as oom_adj
>         per proc   oom_adj as effective_oom_adj
> 
> is an natural way as Unix, I think.
> 

I don't think effective_oom_adj is a suitable name replacement for 
oom_adj_child since it doesn't imply that the value is a no-op for the 
thread itself and only serves a purpose when an mm is initialized for a 
child.

> > It livelocks if a thread is chosen and passed to oom_kill_task() while
> > another per-thread oom_adj value is OOM_DISABLE for a thread sharing the
> > same memory.
> >
> I say "why don't modify buggy selection logic?"
> 
> Why we have to scan all threads ?
> As fs/proc/readdir does, you can scan only "process group leader".
> 
> per-thread scan itself is buggy because now we have per-process
> effective-oom-adj.
> 

Without my patches to change oom_adj from task_struct to mm_struct, you'd 
need to scan all tasks and not just the tgids because their oom_adj values 
can differ amongst threads in the same thread group.  So while it may now 
be possible to shorten the scan as a result of my approach, it isn't a 
solution itself to the problem.

> > How else do you propose the oom killer use oom_adj values on a per-thread
> > basis without considering other threads sharing the same memory?
> As I wrote.
>    per-process(signal struct) or per-thread oom_adj and add
>    mm->effecitve_oom_adj
> 
> task scanning isn't necessary to do per-thread scan and you can scan
> only process-group-leader. What's bad ?
> If oom_score is problem, plz fix it to show effective_oom_score.
> 

When only using (and showing) mm->effective_oom_adj for a task, userspace 
will not be able to adjust /proc/pid/oom_score with /proc/pid/oom_adj 
as Documentation/filesystems/proc.txt says you can for a thread unless it 
exceeds effective_oom_adj.
