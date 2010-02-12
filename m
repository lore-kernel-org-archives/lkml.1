Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0BLJ6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:58:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:53113 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0BLJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:58:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nI3xDZB6xeA3RGw3/9iWy6bCvhbgRvod8mO83eUkh2iTD2jbP/NClWxRQ5M/599JZ
	ppub5VUfRlPeuP509BJ0w==
Date: Fri, 12 Feb 2010 01:58:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 5/7 -mm] oom: replace sysctls with quick mode
In-Reply-To: <20100212092634.60a76cf9.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002120150380.22883@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com> <alpine.DEB.2.00.1002100229250.8001@chino.kir.corp.google.com> <20100212092634.60a76cf9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, KAMEZAWA Hiroyuki wrote:

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
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> seems reasonable..but how old these APIs are ? Replacement is ok ?
> 

I'm not concerned about /proc/sys/vm/oom_dump_tasks because it was 
disabled by default and is now enabled by default (unless the user sets 
this new /proc/sys/vm/oom_kill_quick).  So existing users of 
oom_dump_tasks will just have their write fail but identical behavior as 
before.

/proc/sys/vm/oom_kill_allocating_task is different since it now requires 
enabling /proc/sys/vm/oom_kill_quick, but I think there are such few users 
(SGI originally requested it a couple years ago when we started scanning 
the tasklist for CONSTRAINT_CPUSET in 2.6.24) and the side-effect of not 
enabling it is minimal, it's just a long delay at oom kill time because 
they must scan the tasklist.  Therefore, I don't see it as a major problem 
that will cause large disruptions, instead I see it as a great opportunity 
to get rid of one more sysctl without taking away functionality.

> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Thanks!
