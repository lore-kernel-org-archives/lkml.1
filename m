Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab0BQAyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:54:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:3576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541Ab0BQAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:54:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=dh6C4+zHhalzPnH+vjYF4TUibbsTtq6aN9WVjQ5cHvvYdW9OVU8yqgps7Pjzg86uQ
	lmSiEuQFEKKfYdApAgLNg==
Date: Tue, 16 Feb 2010 16:54:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
In-Reply-To: <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com> <20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
 <20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com> <20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
 <20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com> <20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > This should panic in mem_cgroup_out_of_memory() and the documentation 
> > should be added to Documentation/sysctl/vm.txt.
> > 
> > The memory controller also has some protection in the pagefault oom 
> > handler that seems like it could be made more general: instead of checking 
> > for mem_cgroup_oom_called(), I'd rather do a tasklist scan to check for 
> > already oom killed task (checking for the TIF_MEMDIE bit) and check all 
> > zones for ZONE_OOM_LOCKED.  If no oom killed tasks are found and no zones 
> > are locked, we can check sysctl_panic_on_oom and invoke the system-wide 
> > oom.
> > 
> plz remove memcg's hook after doing that. Current implemantation is desgined 
> not to affect too much to other cgroups by doing unnecessary jobs.
> 

Ok, I'll eliminate pagefault_out_of_memory() and get it to use 
out_of_memory() by only checking for constrained_alloc() when
gfp_mask != 0.

> > >  2. Second, I'll add OOM-notifier and freeze_at_oom to memcg.
> > >     and don't call memcg_out_of_memory in oom_kill.c in this case. Because
> > >     we don't kill anything. Taking coredumps of all procs in memcg is not
> > >     very difficult.
> > > 
> > 
> > The oom notifier would be at a higher level than the oom killer, the oom 
> > killer's job is simply to kill a task when it is called. 
> > So for these particular cases, you would never even call into out_of_memory() to panic 
> > the machine in the first place. 
> 
> That's my point. 
> 

Great, are you planning on implementing a cgroup that is based on roughly 
on the /dev/mem_notify patchset so userspace can poll() a file and be 
notified of oom events?  It would help beyond just memcg, it has an 
application to cpusets (adding more mems on large systems) as well.  It 
can also be used purely to preempt the kernel oom killer and move all the 
policy to userspace even though it would be sacrificing TIF_MEMDIE.
