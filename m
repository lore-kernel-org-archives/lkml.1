Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZHCH7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZHCH7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 03:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZHCH73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 03:59:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZHCH72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 03:59:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=k7uNMdLKJ0kKjmZecQtjOnZpk0nG9OH9lIwNWHc/5Lxne7Boj0SvicBxiExrRpLZD
	vTQwcaig1CfyaYjsOp9og==
Date: Mon, 3 Aug 2009 00:59:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
In-Reply-To: <20090803104244.b58220ba.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908030050160.30778@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com> <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com> <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com> <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com> <7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
 <alpine.DEB.2.00.0907311212240.22732@chino.kir.corp.google.com> <77df8765230d9f83859fde3119a2d60a.squirrel@webmail-b.css.fujitsu.com> <alpine.DEB.2.00.0908011303050.22174@chino.kir.corp.google.com> <20090803104244.b58220ba.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, KAMEZAWA Hiroyuki wrote:

> >  - /proc/pid/oom_score is inconsistent when tuning /proc/pid/oom_adj if it
> >    relies on the per-thread oom_adj; it now really represents nothing but
> >    an incorrect value if other threads share that memory and misleads the
> >    user on how the oom killer chooses victims, or
> 
> What's why I said to show effective_oom_adj if necessary..
> 

Right, but which of the following two behaviors do you believe the 
majority of today's user applications are written to use?

 (1) /proc/pid/oom_score represents the badness heuristic that the oom
     killer uses to determine which task to kill, or

 (2) /proc/pid/oom_adj can be adjusted after vfork() and prior to exec()
     to represent the oom preference of the child without simultaneously
     changing the oom preference of the parent.

The two are at a complete contrast and cannot co-exist.  I favor behavior 
(1), which is why my patches make it consistent in _all_ cases, since it 
is more likely than not that the majority of user applications use that 
behavior if, for no other reason, than it is the DOCUMENTED reason.

If you feel that's an unreasonable conclusion, then please say that so 
your argument can be judged based on your interpretation of that behavior 
which I believe most others would disagree with.  Otherwise, our 
discussion will continue to go in circles.

> >  - /proc/pid/oom_score is inconsistent when the thread that set the
> >    effective per-mm oom_adj exits and it is now obsolete since you have
> >    no way to determine what the next effective oom_adj value shall be.
> > 
> plz re-caluculate it. it's not a big job if done in lazy way.
> 

You can't recalculate it if all the remaining threads have a different 
oom_adj value than the effective oom_adj value from the thread that is now 
exited.  There is no assumption that, for instance, the most negative 
oom_adj value shall then be used.  Imagine the effective oom_adj value 
being +15 and a thread sharing the same memory has an oom_adj value of 
-16.  Under no reasonable circumstance should the oom preference of the 
entire thread then change to -16 just because its the side-effect of a 
thread exiting.

That's the _entire_ reason why we need consistency in oom_adj values so 
that userspace is aware of how the oom killer really works and chooses 
tasks.  I understand that it differs from the previously allowed behavior, 
but those userspace applications need to be fixed if, for no other reason, 
they are now consistent with how the oom killer kills tasks.  I think 
that's a very worthwhile goal and the cost of moving to a new interface 
such as /proc/pid/oom_adj_child to have the same inheritance property that 
was available in the past is justified.
