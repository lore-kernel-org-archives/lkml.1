Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0BOWPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:15:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab0BOWPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:15:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=m3pJlg9KHEKsUqx3rk8trIP0D9eCDHfWxQjU6l4usfipdlImGavf0ha2S244yFoeD
	Az4AAdiusFoLqaFlPgEGw==
Date: Mon, 15 Feb 2010 14:15:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 5/7 -mm] oom: replace sysctls with quick mode
In-Reply-To: <20100215170634.729E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002151411530.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100229250.8001@chino.kir.corp.google.com> <20100215170634.729E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010, KOSAKI Motohiro wrote:

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
> "_quick" is always bad sysctl name.

Why?  It does exactly what it says: it kills current without doing an 
expensive tasklist scan and suppresses the possibly long tasklist dump.  
That's the oom killer's "quick mode."

> instead, turnning oom_dump_tasks on
> by default is better.
> 

It's now on by default and can be disabled by enabling oom_kill_quick.

> plus, this patch makes unnecessary compatibility issue.
> 

It's the perfect opportunity when totally rewriting the oom killer to 
combine two sysctls with the exact same users into one.  Users will notice 
that the tasklist is always dumped now (we're defaulting oom_dump_tasks 
to be enabled), so there is no reason why we can't remove oom_dump_tasks, 
we're just giving them a new way to disable it.  oom_kill_allocating_task 
no longer always means what it once did: with the mempolicy-constrained 
oom rewrite, we now iterate the tasklist for such cases to kill a task.  
So users need to reassess whether this should be set if all tasks on the 
system are constrained by mempolicies, a typical configuration for 
extremely large systems.  
