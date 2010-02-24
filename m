Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0BXC0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:26:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:16330 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab0BXC0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:26:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=XLX6E3vHkaVDbHf4ddL0br94W0Q6kt0EvaCfCugSfeaaYo9ZtuVeP+W50seAOc9mt
	kOGjYUQCvQfjY3Gy6J66g==
Date: Tue, 23 Feb 2010 18:26:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] memcg: page fault oom improvement v2
In-Reply-To: <20100224104839.6547ab78.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002231818540.9613@chino.kir.corp.google.com>
References: <20100223120315.0da4d792.kamezawa.hiroyu@jp.fujitsu.com> <20100223140218.0ab8ee29.nishimura@mxp.nes.nec.co.jp> <20100223152116.327a777e.nishimura@mxp.nes.nec.co.jp> <20100223152650.e8fc275d.kamezawa.hiroyu@jp.fujitsu.com>
 <20100223155543.796138fc.nishimura@mxp.nes.nec.co.jp> <20100223160714.72520b48.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002231443410.8693@chino.kir.corp.google.com> <20100224090836.ba86a4a6.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002231738070.3435@chino.kir.corp.google.com> <20100224104839.6547ab78.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > > > This allows us to hijack the TIF_MEMDIE bit to detect when there is a 
> > > > parallel pagefault oom killing when the oom killer hasn't necessarily been 
> > > > invoked to kill a system-wide task (it's simply killing current, by 
> > > > default, and giving it access to memory reserves).  Then, we can change 
> > > > out_of_memory(), which also now handles memcg oom conditions, to always 
> > > > scan the tasklist first (including for mempolicy and cpuset constrained 
> > > > ooms), check for any candidates that have TIF_MEMDIE, and return 
> > > > ERR_PTR(-1UL) if so.  That catches the parallel pagefault oom conditions 
> > > > from needlessly killing memcg tasks.  panic_on_oom would only panic after 
> > > > the tasklist scan has completed and returned != ERR_PTR(-1UL), meaning 
> > > > pagefault ooms are exempt from that sysctl.
> > > > 
> > > Sorry, I see your concern but I'd like not to do clean-up and bug-fix at
> > > the same time.  
> > > 
> > > I think clean up after fix is easy in this case.
> > > 
> > 
> > If you develop on top of my oom killer rewrite, pagefault ooms already 
> > attempt to kill current first and then defer back to killing another task 
> > if current is unkillable.  
> 
> After my fix, page_fault_out_of_memory is never called. (because memcg doesn't
> return needless failure.)
> 

Of course it's called, it's called from the pagefault handler whenever we 
return VM_FAULT_OOM.  Whenever that happens, we'd needlessly panic the 
machine for panic_on_oom if we didn't do the tasklist scan and check for 
eligible tasks with TIF_MEMDIE set because it prefers to kill current 
first in pagefault conditions without consideration given to the sysctl.  
pagefault_out_of_memory() has changed radically with my rewrite, so I'd 
encourage you to develop on top of that where I've completely removed 
mem_cgroup_oom_called() and memcg->last_oom_jiffies already because 
they're nonsense.

My patches are available from 
http://www.kernel.org/pub/linux/kernel/people/rientjes/oom-killer-rewrite

Thanks.
