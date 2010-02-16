Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0BPI6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:58:16 -0500
Received: from smtp-out.google.com ([216.239.33.17]:9392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0BPI6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:58:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=N3hPYdbbaHC+1LXANGlyBeHTLpjMSNEecG3jvFk8n0HdPey82HL8AmroBxdOp6I1C
	waZAo7+MFvyGMwCpSw6JA==
Date: Tue, 16 Feb 2010 00:58:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 7/9 v2] oom: replace sysctls with quick mode
In-Reply-To: <20100216062833.GB5723@laptop>
Message-ID: <alpine.DEB.2.00.1002160052010.17122@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151419120.26927@chino.kir.corp.google.com> <20100216062833.GB5723@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Nick Piggin wrote:

> > Two VM sysctls, oom dump_tasks and oom_kill_allocating_task, were
> > implemented for very large systems to avoid excessively long tasklist
> > scans.  The former suppresses helpful diagnostic messages that are
> > emitted for each thread group leader that are candidates for oom kill
> > including their pid, uid, vm size, rss, oom_adj value, and name; this
> > information is very helpful to users in understanding why a particular
> > task was chosen for kill over others.  The latter simply kills current,
> > the task triggering the oom condition, instead of iterating through the
> > tasklist looking for the worst offender.
> > 
> > Both of these sysctls are combined into one for use on the aforementioned
> > large systems: oom_kill_quick.  This disables the now-default
> > oom_dump_tasks and kills current whenever the oom killer is called.
> > 
> > The oom killer rewrite is the perfect opportunity to combine both sysctls
> > into one instead of carrying around the others for years to come for
> > nothing else than legacy purposes.
> 
> I just don't understand this either. There appears to be simply no
> performance or maintainability reason to change this.
> 

When oom_dump_tasks() is always emitted for out of memory conditions as my 
patch does, then these two tunables have the exact same audience: users 
with large systems that have extremely long tasklists.  They want to avoid 
tasklist scanning (either to select a bad process to kill or dump their 
information) in oom conditions and simply kill the allocating task.  I 
chose to combine the two: we're not concerned about breaking the 
oom_dump_tasks ABI since it's now the default behavior and since we scan 
the tasklist for mempolicy-constrained ooms, users may now choose to 
enable oom_kill_allocating_task when they previously wouldn't have.  To do 
that, they can either use the old sysctl or convert to this new sysctl 
with the benefit that we've removed one unnecessary sysctl from 
/proc/sys/vm.

As far as I know, oom_kill_allocating_task is only used by SGI, anyway, 
since they are the ones who asked for it when I implemented cpuset 
tasklist scanning.  It's certainly not widely used and since the semantics 
for mempolicies have changed, oom_kill_quick may find more users.
