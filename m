Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0BLAPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:15:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:50499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0BLAP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:15:29 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jffSwbhIzjlGVlFe2RfMWgKx5ZFRpbCeP0DofTltT3Ph8XXQBHmkyajYkm95F8yz9
	a2mv0MA8HinblQJZxXnuw==
Date: Thu, 11 Feb 2010 16:15:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 2/7 -mm] oom: sacrifice child with highest badness score
 for parent
In-Reply-To: <20100212090009.3e5b8738.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002111611520.11711@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100228240.8001@chino.kir.corp.google.com> <20100212090009.3e5b8738.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, KAMEZAWA Hiroyuki wrote:

> Maybe better than current logic..but I'm not sure why we have to check children ;)
> 
> BTW,
> ==
>         list_for_each_entry(child, &p->children, sibling) {
>                 task_lock(child);
>                 if (child->mm != mm && child->mm)
>                         points += child->mm->total_vm/2 + 1;
>                 task_unlock(child);
>         }
> ==
> I wonder this part should be
> 	points += (child->total_vm/2) >> child->signal->oom_adj + 1
> 
> If not, in following situation,
> ==
> 	parent (oom_adj = 0)
> 	  -> child (oom_adj=-15, very big memory user)
> ==
> the child may be killd at first, anyway. Today, I have to explain customers
> "When you set oom_adj to a process, please set the same value to all ancestors.
>  Otherwise, your oom_adj value will be ignored."
> 

This is a different change than the forkbomb detection which is rewritten 
in the fourth patch in the series.  We must rely on badness() being able 
to tell us how beneficial it will be to kill a task, so iterating through 
the child list and picking the most beneficial is the goal of this patch.  
It reduces the chances of needlessly killing a child using very little 
memory for no benefit just because it was forked first.
