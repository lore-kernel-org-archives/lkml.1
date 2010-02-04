Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0BDAFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:05:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:56812 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab0BDAFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:05:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=oJAdD6mwOIyd7kACSGWW9aHcjJ/mZOINfMae8HuuG5TDDWU2AuyUo8unz7L7El+GV
	KD3qp16YCdronefe9yzYA==
Date: Wed, 3 Feb 2010 16:05:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lubos Lunak <l.lunak@suse.cz>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <201002032355.01260.l.lunak@suse.cz>
Message-ID: <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com> <201002032355.01260.l.lunak@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Lubos Lunak wrote:

> > 	unsigned int badness(struct task_struct *p,
> > 					unsigned long totalram)
> > 	{
> > 		struct task_struct *child;
> > 		struct mm_struct *mm;
> > 		int forkcount = 0;
> > 		long points;
> >
> > 		task_lock(p);
> > 		mm = p->mm;
> > 		if (!mm) {
> > 			task_unlock(p);
> > 			return 0;
> > 		}
> > 		points = (get_mm_rss(mm) +
> > 				get_mm_counter(mm, MM_SWAPENTS)) * 1000 /
> > 				totalram;
> > 		task_unlock(p);
> >
> > 		list_for_each_entry(child, &p->children, sibling)
> > 			/* No lock, child->mm won't be dereferenced */
> > 			if (child->mm && child->mm != mm)
> > 				forkcount++;
> >
> > 		/* Forkbombs get penalized 10% of available RAM */
> > 		if (forkcount > 500)
> > 			points += 100;
> 
>  As far as I'm concerned, this is a huge improvement over the current code 
> (and, incidentally :), quite close to what I originally wanted). I'd be 
> willing to test it in few real-world desktop cases if you provide a patch.
> 

There're some things that still need to be worked out, like discounting 
hugetlb pages on each allowed node, respecting current's cpuset mems, 
etc., but I think it gives us a good rough draft of where we might end up.  
I did use the get_mm_rss() that you suggested, but I think it's more 
helpful in the context of a fraction of total memory allowed so the other 
heursitics (forkbomb, root tasks, nice'd tasks, etc) are penalizing the 
points in a known quantity rather than a manipulation of that baseline.

Do you have any comments about the forkbomb detector or its threshold that 
I've put in my heuristic?  I think detecting these scenarios is still an 
important issue that we need to address instead of simply removing it from 
consideration entirely.
