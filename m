Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbZGaJg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbZGaJg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZGaJg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:36:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61826 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZGaJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:36:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=dp7ngSnEbP6tw1TxJCmZUBDrDezx8NtLNdGVVxsQp8i7KqrzmiYbsiRzEKABd7MxV
	dXCoYqjbGq+zyxkquB1nw==
Date: Fri, 31 Jul 2009 02:36:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
In-Reply-To: <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com> <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com> <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com> <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, KAMEZAWA Hiroyuki wrote:

> > > Simply, reset_oom_adj_at_new_mm_context or some.
> > > 
> > 
> > I think it's preferred to keep the name relatively short which is an 
> > unfortuante requirement in this case.  I also prefer to start the name 
> > with "oom_adj" so it appears alongside /proc/pid/oom_adj when listed 
> > alphabetically.
> > 
> But misleading name is bad.
> 

Can you help think of any names that start with oom_adj_* and are 
relatively short?  I'd happily ack it.

> Why don't you think select_bad_process()-> oom_kill_task() implementation is bad ?

It livelocks if a thread is chosen and passed to oom_kill_task() while 
another per-thread oom_adj value is OOM_DISABLE for a thread sharing the 
same memory.

> IMHO, it's bad manner to fix an os-implementation problem by adding _new_ user
> interface which is hard to understand.
> 

How else do you propose the oom killer use oom_adj values on a per-thread 
basis without considering other threads sharing the same memory?  It does 
no good for the oom killer to kill a thread if another one sharing its 
memory is OOM_DISABLE because it can't kill all of them.  That means the 
memory cannot be freed and it must choose another task, but the end result 
is that it needlessly killed others.  That's not a desirable result, 
sorry.

> > In other words, the issue here is larger than the inheritance of the 
> > oom_adj value amongst children, it addresses a livelock that neither of 
> > your approaches solve.  The fix actually makes /proc/pid/oom_adj (and 
> > /proc/pid/oom_score) consistent with how the oom killer behaves.
> 
> This oom_adj_child itself is not related to livelock problem. Don't make
> the problem bigger than it is.
> oom_adj_child itself is just a problem how to handle vfork().
> 

Right, that's why it wasn't part of my original patchset which fixed the 
livelock.  We had seen that others had use cases where they still needed 
to set a newly initialized mm to have a starting oom_adj value different 
from its parent.  That's entirely understandable, and that's why I 
proposed oom_adj_child.
