Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0BAK2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:28:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:56999 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0BAK2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:28:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yDW6t5/RZNj7WAoe4D2Qswi5dy+XJo99QOxsUIm4HrlZWS9FeTzU5KJZb4aZ413tz
	3jTUyzHleBTUOun/hOZTg==
Date: Mon, 1 Feb 2010 02:28:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, vedran.furac@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
In-Reply-To: <20100201090140.116cc704.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002010223510.12764@chino.kir.corp.google.com>
References: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com> <20100129162137.79b2a6d4@lxorguk.ukuu.org.uk> <c6c48fdf7f746add49bb9cc058b513ae.squirrel@webmail-b.css.fujitsu.com> <20100129163030.1109ce78@lxorguk.ukuu.org.uk>
 <5a0e6098f900aa36993b2b7f2320f927.squirrel@webmail-b.css.fujitsu.com> <alpine.DEB.2.00.1001291258490.2938@chino.kir.corp.google.com> <20100201090140.116cc704.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > >  109         /*
> > >  110          * Processes which fork a lot of child processes are likely
> > >  111          * a good choice. We add half the vmsize of the children if they
> > >  112          * have an own mm. This prevents forking servers to flood the
> > >  113          * machine with an endless amount of children. In case a single
> > >  114          * child is eating the vast majority of memory, adding only half
> > >  115          * to the parents will make the child our kill candidate of
> > > choice.
> > >  116          */
> > >  117         list_for_each_entry(child, &p->children, sibling) {
> > >  118                 task_lock(child);
> > >  119                 if (child->mm != mm && child->mm)
> > >  120                         points += child->mm->total_vm/2 + 1;
> > >  121                 task_unlock(child);
> > >  122         }
> > >  123
> > > ==
> > > This makes task launcher(the fist child of some daemon.) first victim.
> > 
> > That "victim", p, is passed to oom_kill_process() which does this:
> > 
> > 	/* Try to kill a child first */
> > 	list_for_each_entry(c, &p->children, sibling) {
> > 		if (c->mm == p->mm)
> > 			continue;
> > 		if (!oom_kill_task(c))
> > 			return 0;
> > 	}
> > 	return oom_kill_task(p);
> > 
> 
> Then, finally, per-process oom_adj(!=OOM_DISABLE) control is ignored ?
> Seems broken.
> 

No, oom_kill_task() returns 1 if the child has OOM_DISABLE set, meaning it 
never gets killed and we continue iterating through the child list.  If 
there are no children with seperate memory to kill, the selected task gets 
killed.  This prevents things from like sshd or bash from getting killed 
unless they are actually the memory leaker themselves.

It would naturally be better to select the child with the highest 
badness() score, but it only depends on the ordering of p->children at the 
moment.  That's because we only want to iterate through this potentially 
long list once, but improvements in this area (as well as sane tweaks to 
the heuristic) would certainly be welcome.
