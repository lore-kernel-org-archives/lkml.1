Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310Ab0A0X4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0A0X4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636Ab0A0X4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:56:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:54633 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0A0X4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:56:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PaDw9R8UkIVZEm/pUuSNaIWviGnhqblQ2hVzX9e5wfWCJHZmt4dl+svm1y2KyGJzX
	OU2ardIb0SgxN/nhrZazQ==
Date: Wed, 27 Jan 2010 15:56:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
In-Reply-To: <20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001271547200.4663@chino.kir.corp.google.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com> <20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com> <20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com> <20100126151202.75bd9347.akpm@linux-foundation.org>
 <20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com> <20100126161952.ee267d1c.akpm@linux-foundation.org> <20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, KAMEZAWA Hiroyuki wrote:

> Now, /proc/<pid>/oom_score and /proc/<pid>/oom_adj are used by servers.

Nonsense, there are plenty of userspace applications such as udev that 
tune their own oom_adj value on their own!  oom_adj is used by anyone who 
wants to define oom killer priority by polarizing the badness heuristic 
for certain tasks to, for example, always prefer them or completely 
disable oom killing for them.

> After this patch, badness() returns different value based on given context.
> Changing format of them was an idea, but, as David said, using "RSS" values
> will show unstable oom_score. So, I didn't modify oom_score (for this time).
> 

That's a seperate issue: you cannot define the baseline of the heuristic 
in terms of rss because it does not allow userspace to define when a task 
has become "rogue", i.e. when it is consuming far more memory than 
expected, because it is a dynamic value that depends on the state of the 
VM at the time of oom.  That is one of the two most popular reasons for 
tuning oom_adj, the other aforementioned.

The issue with using lowmem rss for CONSTRAINT_LOWMEM is that it 
misinterprets oom_adj values given to tasks; users will tune their oom_adj 
based on global, system-wide ooms (or use /proc/pid/oom_score to reveal 
the priority) and will never understand how it affects the value of a 
resident page in lowmem for GFP_DMA allocations.

> To be honest, all my work are for guys who don't tweak oom_adj based on oom_score.
> IOW, this is for usual novice people. And I don't wan't to break servers which
> depends on oom black magic currently supported.
> 

Why can't you simply create your own heuristic, seperate from badness(), 
for CONSTRAINT_LOWMEM?  Define the criteria that you see as important in 
selecting a task in that scenario and then propose it as a seperate 
function, there is no requirement that we must have a single heuristic 
that works for all the various oom killer constraints.  It would be 
entirely appropriate to ignore oom_adj in that heuristic, as well, since 
its not defined for such oom conditions (OOM_DISABLE is already taken care 
of in the tasklist scan and needs no further support).
