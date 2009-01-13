Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbZAMJye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbZAMJye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbZAMJy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:54:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50235 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZAMJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:54:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=O2v2s8KIio/JvENO5zBS1KuZbBP+cUzKJctcx0FajBsLgpadEqzNwZRR6JN4HnbQn
	1x1t4v1HsR+uQ3KgvClWw==
Date: Tue, 13 Jan 2009 01:54:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bill Davidsen <davidsen@tmr.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090113085244.GA13796@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk>
 <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.65
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Evgeniy Polyakov wrote:

> It is a theory, not a practice. OOM-killer most of time starts from ssh,
> database and lighttpd on the tested machines, when it could start in
> the reverse order and do not touch ssh at all. Better not from daemon
> itself, but its fastcgi spawned processes.
> 

In the unconstrained system-wide oom case, it scans each task on the 
system (which can take very long, ask SGI) and rates its badness scoring.  
When a memory-hogging task is identified, which you have complete control 
over in userspace by tuning /proc/pid/oom_adj, it attempts to kill a child 
first if it will allow for memory freeing without killing the parent.

> I agree, that there are ways to tune the way oom-killer selects the
> victim, and likely after hours of games this subtly will work for the
> specified workload.

It doesn't involve "hours of games," it is a very simple heuristic that 
you can easily tune to specify your preferences.

What you're looking for with your patch is simply a way to specify an oom 
preference before the task has been forked, but that's simple to do with 
the current logic since oom_adj scores are inherited and preference is 
given to killing a child before parent.

> What I propose is the simplest way for the most
> commonly used case.

No, procfs is the correct interface for tuning oom kill preferences and 
not by name parsing.

With oom_adj scores, you have the ability to specify oom kill preferences 
within a cpuset or memory controller as well, whereas oom_victim_name is 
global and very costly when not found in select_bad_process().

> It is a help for the admin and not the force to
> invent complex machinery which will be error-prone and hard to debug
> when eventually oom happens.

It's very simple to debug the oom killer's decisions, which is why I 
introduced /proc/sys/vm/oom_dump_tasks.

It also requires two expensive scans of the entire tasklist (I introduced 
/proc/sys/vm/oom_kill_allocating_task specifically to avoid _one_ 
expensive scan) when oom_victim_name isn't found.
