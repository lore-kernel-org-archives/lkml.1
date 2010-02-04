Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab0BDAAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:00:33 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab0BDAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:00:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rthhE4lbzpcc2Gyu1G2oUZO5hgLNa3QjcgY+oLtMrq/xqLNN5HLwwQQ4tcgl3baqf
	gNm1d5bZk0ZPYxZ46Rj8w==
Date: Wed, 3 Feb 2010 16:00:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lubos Lunak <l.lunak@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Improving OOM killer
In-Reply-To: <201002032354.58352.l.lunak@suse.cz>
Message-ID: <alpine.DEB.2.00.1002031545120.27918@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <201002022210.06760.l.lunak@suse.cz> <alpine.DEB.2.00.1002021643240.3393@chino.kir.corp.google.com> <201002032354.58352.l.lunak@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Lubos Lunak wrote:

> 
>  Given that the badness() proposal I see in your another mail uses 
> get_mm_rss(), I take it that you've meanwhile changed your mind on the VmSize 
> vs VmRSS argument and considered that argument irrelevant now.

The argument was never to never factor rss into the heuristic, the 
argument was to prevent the loss of functionality of oom_adj and being 
able to define memory leakers from userspace.  With my proposal, I believe 
the new semantics of oom_adj are even clearer than before and allow users 
to either discount or bias a task with a quantity that they are familiar 
with: memory.

My rough draft was written in a mail editor, so it's completely untested 
and even has a couple of flaws: we need to discount free hugetlb memory 
from allowed nodes, we need to intersect the passed nodemask with 
current's cpuset, etc.

> I will comment 
> only on the suggested use of oom_adj on the desktop here. And actually I hope 
> that if something reasonably similar to your badness() proposal replaces the 
> current one it will make any use of oom_adj not needed on the desktop in the 
> usual case, so this may be irrelevant as well.
> 

If you define "on the desktop" performance of the oom killer merely as 
protecting a windows environment, then it should be helpful.  I'd still 
recommend using OOM_DISABLE for those tasks, though, because I agree that 
for users in that environment, KDE getting oom killed is just not a viable 
solution.

> > The kernel cannot possibly know what you consider a "vital" process, for
> > that understanding you need to tell it using the very powerful
> > /proc/pid/oom_adj tunable.  I suspect if you were to product all of
> > kdeinit's children by patching it to be OOM_DISABLE so that all threads it
> > forks will inherit that value you'd actually see much improved behavior.
> 
>  No. Almost everything in KDE is spawned by kdeinit, so everything would get 
> the adjustment, which means nothing would in practice get the adjustment.
> 

It depends on whether you change the oom_adj of children that you no 
longer want to protect which have been forked from kdeinit.

> > I'd also encourage you to talk to the KDE developers to ensure that proper
> > precautions are taken to protect it in such conditions since people who
> > use such desktop environments typically don't want them to be sacrificed
> > for memory.
> 
>  I am a KDE developer, it's written in my signature. And I've already talked 
> enough to the KDE developer who has done the oom_adj code that's already 
> there, as that's also me. I don't know kernel internals, but that doesn't 
> mean I'm completely clueless about the topic of the discussion I've started.
> 

Then I'd recommend that you protect those tasks with OOM_DISABLE, 
otherwise they will always be candidates for oom kill; the only way to 
explicitly prevent that is by changing oom_adj or moving it to its own 
memory controller cgroup.  A kernel oom heursitic that is implemented for 
a wide variety of platforms, including desktops, servers, and embedded 
devices, will never identify KDE as a vital task that cannot possibly be 
killed unless you tell the kernel it has that priority.  Whether you 
choose to use that power or not is up to the KDE team.

>  1) I think you missed that I said that every KDE application with the current 
> algorithm can be potentially a contender for selection, and I provided 
> numbers to demonstrate that in a selected case. Just because such application 
> is not vital does not mean it's good for it to get killed instead of an 
> obvious offender.
> 

This is exaggerating the point quite a bit, I don't think every single KDE 
thread is going to have a badness() score that is higher than all other 
system tasks all the time.  I think that there are the likely candidates 
that you've identified (kdeinit, ksmserver, etc) that are much more prone 
to high badness() scores given their total_vm size and the number of 
children they fork, but I don't think this is representative of every KDE 
thread.

>  2) You probably do not realize the complexity involved in using oom_adj in a 
> desktop. Even when doing that manually I would have some difficulty finding 
> the right setup for my own desktop use. It'd be probably virtually impossible 
> to write code that would do it at least somewhat right with all the widely 
> differing various desktop setups that dynamically change.
> 

Used in combination with /proc/pid/oom_score, it gives you a pretty good 
snapshot of how oom killer priorities look at any moment in time.  In your 
particular use case, however, you seem to be arguing from a perspective of 
only protecting certain tasks that you've identified from being oom killed 
for desktop environments, namely KDE.  For that, there is no confusion to 
be had: use OOM_DISABLE.  For server environments that I'm also concerned 
about, the oom_adj range is much more important to define a killing 
priority when used in combination with cpusets.

>  3) oom_adj is ultimately just a kludge to handle special cases where the 
> heuristic doesn't get it right for whatever strange reason. But even you 
> yourself in another mail presented a heuristic that I believe would make any 
> use of oom_adj on the desktop unnecessary in the usual cases. The usual 
> desktop is not a special case.
> 

The kernel will _always_ need user input into which tasks it believes to 
be vital.  For you, that's KDE.  For me, that's one of our job schedulers.  

> > The heuristics are always well debated in this forum and there's little
> > chance that we'll ever settle on a single formula that works for all
> > possible use cases.  That makes oom_adj even more vital to the overall
> > efficiency of the oom killer, I really hope you start to use it to your
> > advantage.
> 
>  I really hope your latest badness() heuristics proposal allows us to dump 
> even the oom_adj use we already have.
> 

For your environment, I hope the same.  In production servers we'll still 
need the ability to tune /proc/pid/oom_adj to define memory leakers and 
tasks using far more memory than expected, so perhaps my rough draft can 
be a launching pad into a positive discussion about the future of the 
heuristic based on consensus and input from all impacted parties.
