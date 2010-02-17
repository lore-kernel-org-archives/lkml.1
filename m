Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab0BQCiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:38:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53467 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633Ab0BQCiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:38:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 11:34:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100217113430.9528438d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002161825280.2768@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com>
	<20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
	<20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
	<20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
	<20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com>
	<20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com>
	<20100217111319.d342f10e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161825280.2768@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 18:28:05 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > What do you think about making pagefaults use out_of_memory() directly and 
> > > respecting the sysctl_panic_on_oom settings?
> > > 
> > 
> > I don't think this patch is good. Because several memcg can
> > cause oom at the same time independently, system-wide oom locking is
> > unsuitable. BTW, what I doubt is much more fundamental thing.
> > 
> 
> We want to lock all populated zones with ZONE_OOM_LOCKED to avoid 
> needlessly killing more than one task regardless of how many memcgs are 
> oom.
> 
Current implentation archive what memcg want. Why remove and destroy memcg ?


> > What I doubt at most is "why VM_FAULT_OOM is necessary ? or why we have
> > to call oom_killer when page fault returns it".
> > Is there someone who returns VM_FAULT_OOM without calling page allocator
> > and oom-killer helps something in such situation ?
> > 
> 
> Before we invoked the oom killer for VM_FAULT_OOM, we simply sent a 
> SIGKILL to current because we simply don't have memory to fault the page 
> in, it's better to select a memory-hogging task to kill based on badness() 
> than to constantly kill current which may not help in the long term.
> 
What I mean is
 - What VM_FAULT_OOM means is not "memory is exhausted" but "something is exhausted".

For example, when hugepages are all used, it may return VM_FAULT_OOM.
Especially when nr_overcommit_hugepage == usage_of_hugepage, it returns VM_FAULT_OOM.

Then, what oom-killer can help it ? I think never and the requester should die.

Before modifying current code, I think we have to check all VM_FAULT_OOM and distinguish
 - memory is exhausted (and page allocater wasn't called.)
 - something other than memory is exhausted.

And, in hugepage case, even order > PAGE_ALLOC_COSTLY_ORDER, oom-killer is
called and pagegault_oom_kill kills tasks randomly.

Thanks,
-Kame

