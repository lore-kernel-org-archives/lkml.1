Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0BWWt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:49:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:27008 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0BWWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:49:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fOPciN7oAUNzZHszZUWJoBQD8z6YY8G6y8LXzjGHj910DsxUTjbTURqlUvD84gm0l
	k9uwWXmFtxKMLSWTYN8ig==
Date: Tue, 23 Feb 2010 14:49:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] memcg: page fault oom improvement v2
In-Reply-To: <20100223160714.72520b48.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002231443410.8693@chino.kir.corp.google.com>
References: <20100223120315.0da4d792.kamezawa.hiroyu@jp.fujitsu.com> <20100223140218.0ab8ee29.nishimura@mxp.nes.nec.co.jp> <20100223152116.327a777e.nishimura@mxp.nes.nec.co.jp> <20100223152650.e8fc275d.kamezawa.hiroyu@jp.fujitsu.com>
 <20100223155543.796138fc.nishimura@mxp.nes.nec.co.jp> <20100223160714.72520b48.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, KAMEZAWA Hiroyuki wrote:

> Ouch, I missed to add memcontrol.h to quilt's reflesh set..
> This is updated one. Anyway, I'd like to wait for the next mmotm.
> We already have several changes. 
> 

I think it would be better to just remove mem_cgroup_out_of_memory() and 
make it go through out_of_memory() by specifying a non-NULL pointer to a 
struct mem_cgroup.  We don't need the duplication in code that these two 
functions have and then we can begin to have some consistency with how to 
deal with panic_on_oom.

It would be much better to prefer killing current in pagefault oom 
conditions, as the final patch in my oom killer rewrite does, if it is 
killable.  If not, we scan the tasklist and find another suitable 
candidate.  If current is bound to a memcg, we pass that to 
select_bad_process() so that we only kill other tasks from the same 
cgroup.

This allows us to hijack the TIF_MEMDIE bit to detect when there is a 
parallel pagefault oom killing when the oom killer hasn't necessarily been 
invoked to kill a system-wide task (it's simply killing current, by 
default, and giving it access to memory reserves).  Then, we can change 
out_of_memory(), which also now handles memcg oom conditions, to always 
scan the tasklist first (including for mempolicy and cpuset constrained 
ooms), check for any candidates that have TIF_MEMDIE, and return 
ERR_PTR(-1UL) if so.  That catches the parallel pagefault oom conditions 
from needlessly killing memcg tasks.  panic_on_oom would only panic after 
the tasklist scan has completed and returned != ERR_PTR(-1UL), meaning 
pagefault ooms are exempt from that sysctl.

Anyway, do you think it would be possible to rebase on mmotm with my oom 
killer rewrite patches?  They're at 
http://www.kernel.org/pub/linux/kernel/people/rientjes/oom-killer-rewrite
