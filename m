Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbYDDJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbYDDJ1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758495AbYDDJ10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:27:26 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:37542 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYDDJ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:27:25 -0400
Message-ID: <47F5F3FA.7060709@linux.vnet.ibm.com>
Date: Fri, 04 Apr 2008 14:55:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <6599ad830804040112q3dd5333aodf6a170c78e61dc8@mail.gmail.com> <47F5E69C.9@linux.vnet.ibm.com> <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com>
In-Reply-To: <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Apr 4, 2008 at 1:28 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  It won't uncharge for the memory controller from the root cgroup since each page
>>   has the mem_cgroup information associated with it.
> 
> Right, I realise that the memory controller is OK because of the ref counts.
> 
>>  For other controllers,
>>  they'll need to monitor exit() callbacks to know when the leader is dead :( (sigh).
> 
> That sounds like a nightmare ...
> 

Yes, it would be, but worth the trouble. Is it really critical to move a dead
cgroup leader to init_css_set in cgroup_exit()?

>>  Not having the group leader optimization can introduce big overheads (consider
>>  thousands of tasks, with the group leader being the first one to exit).
> 
> Can you test the overhead?
> 

I probably can write a program and see what the overhead looks like

> As long as we find someone to pass the mm to quickly, it shouldn't be
> too bad - I think we're already optimized for that case. Generally the
> group leader's first child will be the new owner, and any subsequent
> times the owner exits, they're unlikely to have any children so
> they'll go straight to the sibling check and pass the mm to the
> parent's first child.
> 
> Unless they all exit in strict sibling order and hence pass the mm
> along the chain one by one, we should be fine. And if that exit
> ordering does turn out to be common, then simply walking the child and
> sibling lists in reverse order to find a victim will minimize the
> amount of passing.
> 


Finding the next mm might not be all that bad, but doing it each time a task
exits, can be an overhead, specially for large multi threaded programs. This can
get severe if the new mm->owner belongs to a different cgroup, in which case we
need to use callbacks as well.

If half the threads belonged to a different cgroup and the new mm->owner kept
switching between cgroups, the overhead would be really high, with the callbacks
and the mm->owner changing frequently.

> One other thing occurred to me - what lock protects the child and
> sibling links? I don't see any documentation anywhere, but from the
> code it looks as though it's tasklist_lock rather than RCU - so maybe
> we should be holding that with a read_lock(), at least for the first
> two parts of the search? (The full thread search is RCU-safe).
> 

You are right about the read_lock()

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
