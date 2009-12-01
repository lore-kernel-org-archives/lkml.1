Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZLAWUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZLAWUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZLAWUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:20:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:17744 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbZLAWUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:20:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qkHZmD4viPuVK/hOnc8OwKVfUo9XyUc2weO63JWxqvywLZ2w6a8niILGl0kbJiFRp
	LFr/vaAZGlHPaiqisjEKg==
Date: Tue, 1 Dec 2009 14:20:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, vedran.furac@gmail.com
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
In-Reply-To: <20091201131509.5C19.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912011414510.27500@chino.kir.corp.google.com>
References: <20091127182607.GA30235@random.random> <alpine.DEB.2.00.0911301502160.12038@chino.kir.corp.google.com> <20091201131509.5C19.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, KOSAKI Motohiro wrote:

> > The purpose of /proc/pid/oom_adj is not always to polarize the heuristic 
> > for the task it represents, it allows userspace to define when a task is 
> > rogue.  Working with total_vm as a baseline, it is simple to use the 
> > interface to tune the heuristic to prefer a certain task over another when 
> > its memory consumption goes beyond what is expected.  With this interface, 
> > I can easily define when an application should be oom killed because it is 
> > using far more memory than expected.  I can also disable oom killing 
> > completely for it, if necessary.  Unless you have a consistent baseline 
> > for all tasks, the adjustment wouldn't contextually make any sense.  Using 
> > rss does not allow users to statically define when a task is rogue and is 
> > dependent on the current state of memory at the time of oom.
> > 
> > I would support removing most of the other heuristics other than the 
> > baseline and the nodes intersection with mems_allowed to prefer tasks in 
> > the same cpuset, though, to make it easier to understand and tune.
> 
> I feel you talked about oom_adj doesn't fit your use case. probably you need
> /proc/{pid}/oom_priority new knob. oom adjustment doesn't fit you.
> you need job severity based oom killing order. severity doesn't depend on any
> hueristic.
> server administrator should know job severity on his system.
> 

That's the complete opposite of what I wrote above, we use oom_adj to 
define when a user application is considered "rogue," meaning that it is 
using far more memory than expected and so we want it killed.  As you 
mentioned weeks ago, the kernel cannot identify a memory leaker; this is 
the user interface to allow the oom killer to identify a memory-hogging 
rogue task that will (probably) consume all system memory eventually.  
The way oom_adj is implemented, with a bit shift on a baseline of 
total_vm, it can also polarize the badness heuristic to kill an 
application based on priority by examining /proc/pid/oom_score, but that 
wasn't my concern in this case.  Using rss as a baseline reduces my 
ability to tune oom_adj appropriately to identify those rogue tasks 
because it is highly dynamic depending on the state of the VM at the time 
of oom.
