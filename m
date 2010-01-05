Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117Ab0AEDO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0AEDO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577Ab0AEDO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:14:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086Ab0AEDO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:14:27 -0500
Date: Mon, 4 Jan 2010 19:13:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1001041904250.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jan 2010, KAMEZAWA Hiroyuki wrote:
> 
> I'm sorry if I miss something...how does this patch series avoid
> that vma is removed while __do_fault()->vma->vm_ops->fault() is called ?
> ("vma is removed" means all other things as freeing file struct etc..)

I don't think you're missing anything. 

Protecting the vma isn't enough. You need to protect the whole FS stack 
with rcu. Probably by moving _all_ of "free_vma()" into the RCU path 
(which means that the whole file/inode gets de-allocated at that later RCU 
point, rather than synchronously). Not just the actual kfree.

However, it's worth noting that that actually has some very subtle and 
major consequences. If you have a temporary file that was removed, where 
the mmap() was the last user that kind of delayed freeing would also delay 
the final fput of that file that actually deletes it. 

Or put another way: if the vma was a writable mapping, a user may do

	munmap(mapping, size);

and the backing file is still active and writable AFTER THE MUNMAP! This 
can be a huge problem for something that wants to unmount the volume, for 
example, or depends on the whole writability-vs-executability thing. The 
user may have unmapped it, and expects the file to be immediately 
non-busy, but with the delayed free that isn't the case any more.

In other words, now you may well need to make munmap() wait for the RCU 
grace period, so that the user who did the unmap really is synchronous wrt 
the file accesses. We've had things like that before, and they have been 
_huge_ performance problems (ie it may take just a timer tick or two, but 
then people do tens of thousands of munmaps, and now that takes many 
seconds just due to RCU grace period waiting.

I would say that this whole series is _very_ far from being mergeable. 
Peter seems to have been thinking about the details, while missing all the 
subtle big picture effects that seem to actually change semantics.

		Linus
